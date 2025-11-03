import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/exercice/exercice2.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _colorBlack = Color(0xFF000000); // Texte noir
const String _fontFamily = 'Roboto'; // Police principale
const Color _purpleAppbar = Color(0xFFA885D8); // Violet de la barre d'app
const Color _shadowColor = Color(0xFFE5E5E5); // Gris clair d’ombre


class MatiereListScreen extends StatelessWidget {
  const MatiereListScreen({super.key});

  // Liste des matières à afficher
  final List<String> matieres = const [
    'Histoire',
    'Géographie',
    'Mathématique',
    'Français',
    'Physique',
    'Chimie',
    'Éducation Familiale',
    'Éducation physique et morale',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Le Scaffold est blanc comme l'arrière-plan de l'écran principal
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // Hauteur pour l'en-tête
        child: _buildCustomAppBar(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Liste des cartes de matière
            _buildMatiereList(context),
            // La Barre de navigation inférieure (simulée pour l'aspect visuel)
            const SizedBox(height: 80),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  // --- WIDGET APPBAR PERSONNALISÉE (Similaire à l'écran Exercices) ---
  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      color: _purpleAppbar, // Couleur de fond pour la barre de statut (violet)
      child: SafeArea(
        bottom: false,
        child: Container(
          color: Colors.white, // Fond blanc pour la zone de navigation/titre
          padding: const EdgeInsets.only(top: 10.0, left: 0, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  // Icône de retour (en noir)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: _colorBlack),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Centrer le titre "Exercices"
                  Expanded(
                    child: Center(
                      child: Text(
                        'Exercices', // Titre pour la liste des matières
                        style: const TextStyle(
                          color: _colorBlack,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Pour aligner le titre
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET LISTE DES MATIÈRES ---
  Widget _buildMatiereList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: matieres.length,
      itemBuilder: (context, index) {
        final matiere = matieres[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              // *** C'EST ICI QUE LA NAVIGATION A LIEU ***
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseMatiereListScreen(matiere: matiere),
                ),
              );
            },
            child: _MatiereListItem(matiere: matiere),
          ),
        );
      },
    );
  }

  // --- WIDGET DE LA BARRE DE NAVIGATION INFÉRIEURE (Pour l'aspect visuel) ---
  Widget _buildBottomNavBar() {
    return Container(
      height: 70, // Hauteur de la barre inférieure
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      // Le contenu réel de la barre de navigation est omis pour la simplicité
    );
  }
}

// -------------------------------------------------------------------
// --- COMPOSANT DE CARTE DE MATIÈRE ---
// -------------------------------------------------------------------

class _MatiereListItem extends StatelessWidget {
  final String matiere;

  const _MatiereListItem({required this.matiere});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _shadowColor, // Ombre très claire et subtile
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            matiere,
            style: const TextStyle(
              color: _colorBlack,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: _fontFamily,
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 18,
          ),
        ],
      ),
    );
  }
}
