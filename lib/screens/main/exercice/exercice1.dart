import 'package:flutter/material.dart';
import 'package:edugo/screens/main/exercice/exercice2.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/matiere_service.dart';
import 'package:edugo/models/matiere_response.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:built_collection/built_collection.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _colorBlack = Color(0xFF000000); // Texte noir
const String _fontFamily = 'Roboto'; // Police principale
const Color _shadowColor = Color(0xFFE5E5E5); // Gris clair d'ombre
const Color _colorBackground = Color(0xFFF8F9FA); // Background color

class MatiereListScreen extends StatefulWidget {
  final int? eleveId;

  const MatiereListScreen({super.key, this.eleveId});

  @override
  State<MatiereListScreen> createState() => _MatiereListScreenState();
}

class _MatiereListScreenState extends State<MatiereListScreen> {
  final MatiereService _matiereService = MatiereService();
  final AuthService _authService = AuthService();
  final ThemeService _themeService = ThemeService();
  
  BuiltList<MatiereResponse>? _matieres;
  bool _isLoading = true;
  int? _currentEleveId;

  @override
  void initState() {
    super.initState();
    _currentEleveId = widget.eleveId ?? _authService.currentUserId;
    _loadMatieres();
  }

  Future<void> _loadMatieres() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Use the new method to get subjects for the specific student
      BuiltList<MatiereResponse>? matieres;
      if (_currentEleveId != null) {
        matieres = await _matiereService.getMatieresByEleve(_currentEleveId!);
      } else {
        matieres = await _matiereService.getAllMatieres();
      }
      
      if (mounted) {
        setState(() {
          _matieres = matieres;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading matieres: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors du chargement des matières')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final matiereList = _matieres?.toList() ?? [];
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          backgroundColor: _colorBackground,
          appBar: AppBar(
            title: const Text(
              'Exercices',
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
          ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : matiereList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Aucune matière disponible',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Les matières seront affichées lorsque des exercices seront disponibles',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildMatiereList(context, matiereList),
                    ],
                  ),
                ),
        );
      },
    );
  }


  // --- WIDGET EMPTY STATE ---
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            const Text(
              'Aucune matière disponible',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _colorBlack,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Il n\'y a actuellement aucune matière avec des exercices disponibles.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<Color>(
              valueListenable: _themeService.primaryColorNotifier,
              builder: (context, primaryColor, child) {
                return ElevatedButton(
                  onPressed: _loadMatieres,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  child: const Text(
                    'Réessayer',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET LISTE DES MATIÈRES ---
  Widget _buildMatiereList(BuildContext context, List<MatiereResponse> matieres) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          // Titre "Matières"
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Matières',
                style: TextStyle(
                  color: _colorBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: _fontFamily,
                ),
              ),
            ),
          ),

          // Liste des matières
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: matieres.length,
            itemBuilder: (context, index) {
              final matiere = matieres[index];
              final matiereId = matiere.id;
              final matiereNom = matiere.nom ?? 'Matière';
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: matiereId == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseMatiereListScreen(
                                matiereId: matiereId,
                                matiereName: matiereNom,
                                eleveId: _currentEleveId,
                              ),
                            ),
                          );
                        },
                  // Effet de survol avec MouseRegion pour un meilleur contrôle
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _shadowColor.withValues(alpha: 0.8),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            matiereNom,
                            style: const TextStyle(
                              color: _colorBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: _fontFamily,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}