import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/services/livre_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/progression_response.dart';
import 'package:built_collection/built_collection.dart';

// --- CONSTANTES DE STYLES ---
const Color _colorBlack = Color(0xFF000000);
const Color _colorGreen = Color(0xFF32C832); // Vert de validation
const Color _shadowColor = Color(0xFFEEEEEE); // Couleur de l'ombre
const String _fontFamily = 'Roboto';

// --- ENUM pour gérer l'état de filtrage ---
enum ReadingFilter { all, inProgress, finished }

// --- STRUCTURE DE DONNÉES (Pour la cohérence) ---
class ReadingItem {
  final String title;
  final String author;
  final double progress;
  final String imagePath;

  ReadingItem({
    required this.title,
    required this.author,
    required this.progress,
    required this.imagePath,
  });

  bool get isFinished => progress >= 1.0;
}

// ===================================================================
// ÉCRAN PRINCIPAL : CONVERTI EN STATEFUL POUR LA GESTION DES FILTRES
// ===================================================================

class MyReadingsScreen extends StatefulWidget {
  final ThemeService themeService;

  const MyReadingsScreen({super.key, required this.themeService});

  @override
  State<MyReadingsScreen> createState() => _MyReadingsScreenState();
}

class _MyReadingsScreenState extends State<MyReadingsScreen> {
  ReadingFilter _currentFilter = ReadingFilter.all; // État de filtre initial
  
  final LivreService _livreService = LivreService();
  final AuthService _authService = AuthService();
  
  BuiltList<ProgressionResponse>? _readingProgress;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadReadingProgress();
  }
  
  Future<void> _loadReadingProgress() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final eleveId = _authService.currentUserId;
      if (eleveId != null) {
        final progressions = await _livreService.getProgressionLecture(eleveId);
        if (mounted) {
          setState(() {
            _readingProgress = progressions;
            _isLoading = false;
          });
          
          // Charger les détails des livres si le titre est manquant
          if (progressions != null && progressions.isNotEmpty) {
            for (var progression in progressions) {
              if ((progression.livreTitre == null || progression.livreTitre!.isEmpty) && progression.livreId != null) {
                // Charger les détails du livre pour obtenir le titre
                try {
                  final livre = await _livreService.getLivreById(progression.livreId!);
                  if (livre != null && mounted) {
                    // Mettre à jour la progression avec le titre du livre
                    // Note: On ne peut pas modifier directement ProgressionResponse, donc on doit le refaire
                    setState(() {
                      // Recharger les progressions pour avoir les titres à jour
                    });
                  }
                } catch (e) {
                  print('Error loading book details for ${progression.livreId}: $e');
                }
              }
            }
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading reading progress: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // Convertir les progressions en ReadingItem
  List<ReadingItem> get _allReadings {
    if (_readingProgress == null || _readingProgress!.isEmpty) {
      // Retourner une liste vide ou des données par défaut
      return [];
    }
    
    return _readingProgress!.map((progression) {
      final progress = (progression.pourcentageCompletion ?? 0) / 100.0;
      // Utiliser le titre du livre, ou "Livre sans titre" si manquant
      final title = progression.livreTitre ?? 'Livre sans titre';
      // Note: eleveNom est le nom de l'élève, pas l'auteur du livre
      // Pour l'auteur, il faudrait charger les détails du livre, mais pour l'instant on affiche juste le titre
      return ReadingItem(
        title: title,
        author: 'Page ${progression.pageActuelle ?? 0} / ${progression.pourcentageCompletion ?? 0}%', // Afficher la page actuelle et le pourcentage
        progress: progress.clamp(0.0, 1.0),
        imagePath: 'assets/images/book1.png', // ProgressionResponse n'a pas d'image, utiliser une image par défaut
      );
    }).toList();
  }

  // --- LOGIQUE DE FILTRAGE ---
  List<ReadingItem> get _filteredReadings {
    switch (_currentFilter) {
      case ReadingFilter.all:
        return _allReadings;
      case ReadingFilter.inProgress:
        // Livres en cours: progression > 0% et < 100%
        return _allReadings.where((item) => item.progress > 0.0 && item.progress < 1.0).toList();
      case ReadingFilter.finished:
        // Livres terminés: progression = 100%
        return _allReadings.where((item) => item.progress >= 1.0).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: ThemeService().primaryColorNotifier,
      builder: (context, primaryColor, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Toutes mes Lectures',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                )
              : _allReadings.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'Aucune lecture en cours',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          _buildSearchBar(primaryColor),
                          const SizedBox(height: 20),
                          _buildStatusFilters(primaryColor), // Contient maintenant la logique onTap
                          const SizedBox(height: 20),
                          _buildReadingsList(primaryColor), // Utilise la liste filtrée
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  // --- WIDGETS DE STRUCTURE ET FILTRES ---

  Widget _buildSearchBar(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: primaryColor.withOpacity(0.3)), // Bordure adaptée au thème
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher un livre par nom ou auteur',
          hintStyle: TextStyle(color: primaryColor.withOpacity(0.5)),
          prefixIcon: Icon(Icons.search, color: primaryColor.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildStatusFilters(Color primaryColor) {
    return Row(
      children: [
        // Bouton 'Tout'
        Expanded(
          child: _StatusFilterChip(
            label: 'Tout',
            isSelected: _currentFilter == ReadingFilter.all,
            primaryColor: primaryColor,
            onTap: () {
              setState(() {
                _currentFilter = ReadingFilter.all;
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        // Bouton 'Encours'
        Expanded(
          child: _StatusFilterChip(
            label: 'Encours',
            isSelected: _currentFilter == ReadingFilter.inProgress,
            primaryColor: primaryColor,
            onTap: () {
              setState(() {
                _currentFilter = ReadingFilter.inProgress;
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        // Bouton 'Terminé'
        Expanded(
          child: _StatusFilterChip(
            label: 'Terminé',
            isSelected: _currentFilter == ReadingFilter.finished,
            primaryColor: primaryColor,
            onTap: () {
              setState(() {
                _currentFilter = ReadingFilter.finished;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReadingsList(Color primaryColor) {
    // Utilisation de la liste filtrée
    final filteredReadings = _filteredReadings;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredReadings.length,
      itemBuilder: (context, index) {
        final item = filteredReadings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _ReadingListItem(
            title: item.title,
            author: item.author,
            progress: item.progress,
            imagePath: item.imagePath,
            primaryColor: primaryColor,
          ),
        );
      },
    );
  }
}

// --- WIDGETS REUTILISABLES (Mis à jour pour inclure onTap) ---

class _StatusFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback? onTap;

  const _StatusFilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    required this.primaryColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: primaryColor, width: 1)
              : Border.all(color: primaryColor.withOpacity(0.3), width: 1), // Bordure adaptée
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : _colorBlack,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontFamily: _fontFamily,
          ),
        ),
      ),
    );
  }
}

// --- ITEM DE LISTE (inchangé, utilise le modèle ReadingItem) ---
class _ReadingListItem extends StatelessWidget {
  final String title;
  final String author;
  final double progress;
  final String imagePath;
  final Color primaryColor;

  const _ReadingListItem({
    super.key,
    required this.title,
    required this.author,
    required this.progress,
    required this.imagePath,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFinished = progress >= 1.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1), // Ombre adaptée au thème
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: primaryColor.withOpacity(0.1), // Bordure subtile adaptée
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 55,
              height: 75,
              fit: BoxFit.cover,
               errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 55,
                  height: 75,
                  color: Colors.grey.shade200,
                  child: Icon(Icons.book, color: primaryColor.withOpacity(0.5)),
                );
              },
            ),
          ),
          const SizedBox(width: 15),

          // 2. Texte (Titre et Auteur)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                ),
                Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primaryColor.withOpacity(0.7), // Auteur adapté au thème
                    fontSize: 14,
                    fontFamily: _fontFamily,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),

          // 3. Statut (Terminé / En Cours)
          if (isFinished)
            const Icon(Icons.check_circle, color: _colorGreen, size: 24)
          else
            SizedBox(
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(progress * 100).round()}%',
                    style: TextStyle(
                      color: primaryColor, // Pourcentage en couleur du thème
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: _fontFamily,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor), // Barre de progression adaptée
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}