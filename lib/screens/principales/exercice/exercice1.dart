import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal
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
          // 1. App Bar personnalisé (avec barre de statut et titre)
          _buildCustomAppBar(context),

          // 2. Le corps de la page (Défilement)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  
                  // 3. Liste des Matières
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

  // --- WIDGETS DE STRUCTURE PRINCIPALE ---

  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
        child: Column(
          children: [
            // Barre de Statut (simulée)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('20 : 20', style: TextStyle(color: _colorBlack, fontSize: 15, fontWeight: FontWeight.w700)),
                Icon(Icons.circle, color: _colorBlack, size: 10),
                Row(
                  children: [
                    Icon(Icons.wifi, color: _colorBlack, size: 20),
                    SizedBox(width: 4),
                    Icon(Icons.battery_full, color: _colorBlack, size: 20),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            // Titre de la page
            Row(
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
          ],
        ),
      ),
    );
  }

  Widget _buildMatiereList(BuildContext context) {
    // Données de matières simulées (basées sur l'image)
    const List<String> matieres = [
      'Histoire', 
      'Géographie', 
      'Mathématique', 
      'Français', 
      'Physique', 
      'Chimie', 
      'Éducation Familiale', 
      'Éducation physique et morale'
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
              // Simuler la navigation vers la liste des Quiz pour cette matière
              // Navigator.push(context, MaterialPageRoute(builder: (c) => QuizzesScreen(matiere: matieres[index])));
            },
          ),
        );
      },
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGETS DE COMPOSANTS ---
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

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _NavBarItem({required this.icon, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? _purpleMain : _colorBlack,
          size: 24,
        ),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? _purpleMain : _colorBlack,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }
}