import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/exercice/exercice2.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _colorBlack = Color(0xFF000000); // Texte noir
const String _fontFamily = 'Roboto'; // Police principale

class ExerciseMatiereScreen extends StatelessWidget {
  const ExerciseMatiereScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- BARRE D’EN-TÊTE ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Exercices',
                        style: TextStyle(
                          color: _colorBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          // --- CONTENU PRINCIPAL ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildMatiereList(context),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- LISTE DES MATIÈRES ---
  Widget _buildMatiereList(BuildContext context) {
    const List<String> matieres = [
      'Histoire',
      'Géographie',
      'Mathématique',
      'Français',
      'Physique',
      'Chimie',
      'Éducation Familiale',
      'Éducation physique et morale',
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: matieres.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _MatiereListItem(
            title: matieres[index],
            onTap: () {
              // Navigation vers la liste des exercices pour la matière choisie
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseMatiereListScreen(
                    matiere: matieres[index],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGET D’UNE MATIÈRE (CARTE CLIQUABLE) ---
// -------------------------------------------------------------------

class _MatiereListItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _MatiereListItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: _colorBlack,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: _fontFamily,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
