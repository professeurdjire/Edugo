import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';

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

  // Données de lectures simulées (maintenant comme objets ReadingItem)
  final List<ReadingItem> _allReadings = [
    ReadingItem(title: 'Le jardin invisible', author: 'Auteur : C.S.Lewis', progress: 1.0, imagePath: 'assets/images/book1.png'),
    ReadingItem(title: 'Rêves du Feu', author: 'Auteur : C.S.Lewis', progress: 0.75, imagePath: 'assets/images/book1.png'),
    ReadingItem(title: 'Les larmes du lac', author: 'Marie Havard', progress: 1.0, imagePath: 'assets/images/book1.png'),
    ReadingItem(title: 'La peine de Fer', author: 'Auteur : C.S.Lewis', progress: 0.45, imagePath: 'assets/images/book1.png'),
    ReadingItem(title: 'Le jardin invisible', author: 'Auteur : C.S.Lewis', progress: 1.0, imagePath: 'assets/images/book1.png'),
    ReadingItem(title: 'Les contes du Mandé', author: 'Auteur : Marie Paule Huet', progress: 0.10, imagePath: 'assets/images/book1.png'),
  ];

  // --- LOGIQUE DE FILTRAGE ---
  List<ReadingItem> get _filteredReadings {
    switch (_currentFilter) {
      case ReadingFilter.all:
        return _allReadings;
      case ReadingFilter.inProgress:
        return _allReadings.where((item) => !item.isFinished).toList();
      case ReadingFilter.finished:
        return _allReadings.where((item) => item.isFinished).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.themeService.currentPrimaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildCustomAppBar(context),
          Expanded(
            child: SingleChildScrollView(
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
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE STRUCTURE ET FILTRES ---

  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_sharp, color: _colorBlack), // Flèche en noir
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Toutes mes Lectures',
                      style: TextStyle(
                        color: _colorBlack, // Titre en noir
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ],
        ),
      ),
    );
  }

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