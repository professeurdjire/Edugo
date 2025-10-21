import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorGreen = Color(0xFF32C832); // Vert pour "Terminé"
const String _fontFamily = 'Roboto'; // Police principale

class MyReadingsScreen extends StatelessWidget {
  const MyReadingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. App Bar personnalisé (avec barre de statut)
          _buildCustomAppBar(context),

          // 2. Le corps de la page (Défilement)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  
                  // 3. Champ de recherche
                  _buildSearchBar(),
                  
                  const SizedBox(height: 20),
                  
                  // 4. Barres de filtres (Tout, Encours, Terminé)
                  _buildStatusFilters(),
                  
                  const SizedBox(height: 20),
                  
                  // 5. Liste des Lectures
                  _buildReadingsList(),
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
            const SizedBox(height: 20),

            // Titre de la page
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_sharp, color: _colorBlack),
                  onPressed: () => Navigator.pop(context), 
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Toutes mes Lectures',
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
  
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher un livre par nom ou auteur',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
  
  Widget _buildStatusFilters() {
    return Row(
      children: [
        _StatusFilterChip(label: 'Tout', isSelected: true),
        const SizedBox(width: 10),
        _StatusFilterChip(label: 'Encours'),
        const SizedBox(width: 10),
        _StatusFilterChip(label: 'Terminé'),
      ],
    );
  }

  Widget _buildReadingsList() {
    // Données de lectures simulées (basées sur l'image)
    final List<Map<String, dynamic>> readings = [
      {'title': 'Le jardin invisible', 'author': 'Auteur : C.S.Lewis', 'progress': 1.0, 'image': 'read_garden_invisible.jpg'},
      {'title': 'Rêves du Feu', 'author': 'Auteur : C.S.Lewis', 'progress': 0.75, 'image': 'read_reves_du_feu.jpg'},
      {'title': 'Les larmes du lac', 'author': 'Marie Havard', 'progress': 1.0, 'image': 'read_larmes_du_lac.jpg'},
      {'title': 'La peine de Fer', 'author': 'Auteur : C.S.Lewis', 'progress': 0.45, 'image': 'read_peine_de_fer.jpg'},
      {'title': 'Le jardin invisible', 'author': 'Auteur : C.S.Lewis', 'progress': 1.0, 'image': 'read_jardin_invisible_2.jpg'},
    ];
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: readings.length,
      itemBuilder: (context, index) {
        final item = readings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _ReadingListItem(
            title: item['title']!,
            author: item['author']!,
            progress: item['progress']!,
            imagePath: 'assets/images/${item['image']!}',
          ),
        );
      },
    );
  }

// --- WIDGETS DE COMPOSANTS RÉUTILISABLES ---

class _StatusFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _StatusFilterChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? _purpleMain : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? _purpleMain : Colors.grey.shade400),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : _colorBlack,
          fontSize: 14,
          fontFamily: _fontFamily,
        ),
      ),
    );
  }
}


class _ReadingListItem extends StatelessWidget {
  final String title;
  final String author;
  final double progress;
  final String imagePath;

  const _ReadingListItem({
    required this.title,
    required this.author,
    required this.progress,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFinished = progress >= 1.0;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image de couverture
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            width: 50,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 15),
        
        // Détails du livre
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
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: _fontFamily,
                ),
              ),
              if (!isFinished) 
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(_purpleMain),
                      minHeight: 5,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 15),

        // Statut (Coché ou Pourcentage)
        isFinished
            ? Icon(Icons.check_circle, color: _colorGreen, size: 24)
            : Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: _colorBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: _fontFamily,
                ),
              ),
      ],
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

// ----------------------------------------------------
// Point d'entrée pour le test :
// ----------------------------------------------------
/*
void main() {
  // Assurez-vous d'avoir configuré vos assets avant d'exécuter
  runApp(const MaterialApp(
    home: MyReadingsScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
*/