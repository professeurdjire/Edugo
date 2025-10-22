import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal
const Color _colorBlack = Color(0xFF000000); // Texte noir
const String _fontFamily = 'Roboto'; // Police principale

class PartnersScreen extends StatelessWidget {
  const PartnersScreen({super.key});

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // 3. Liste des Partenaires
                  _buildPartnersList(),
                  
                  const SizedBox(height: 80), // Espace final pour la barre de navigation
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
                  // Retour à la page précédente (Accueil)
                  onPressed: () => Navigator.pop(context), 
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Partenaires éducatifs',
                      style: TextStyle(
                        color: _colorBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Espace pour aligner le titre
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPartnersList() {
    // Données simulées pour les Partenaires
    const List<Map<String, dynamic>> partners = [
      {'name': 'Khan Academy', 'description': 'Des milliers de leçons gratuites sur tous les sujets', 'logo': 'khan_academy_logo.png', 'color': Color(0xFF147A83)},
      {'name': 'Duolingo', 'description': 'Des milliers de leçon gratuites sur tous les sujets', 'logo': 'duolingo_logo.png', 'color': Color(0xFF58CC02)},
      {'name': 'Busuu', 'description': 'Des milliers de leçon gratuites sur tous les sujets', 'logo': 'busuu_logo.png', 'color': Color(0xFF1456D3)},
      {'name': 'Busuu', 'description': 'Des milliers de leçon gratuites sur tous les sujets', 'logo': 'busuu_logo.png', 'color': Color(0xFF1456D3)},
    ];
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: partners.length,
      itemBuilder: (context, index) {
        final item = partners[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _PartnerCard(
            name: item['name']!,
            description: item['description']!,
            logoPath: 'assets/logos/${item['logo']!}', // Simulé
            logoColor: item['color'] as Color,
          ),
        );
      },
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGETS DE COMPOSANTS ---
// -------------------------------------------------------------------

class _PartnerCard extends StatelessWidget {
  final String name;
  final String description;
  final String logoPath;
  final Color logoColor; // Couleur principale du logo/carte pour le Khan Academy et Busuu.

  const _PartnerCard({
    required this.name,
    required this.description,
    required this.logoPath,
    required this.logoColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo (Simulé par une icône ou un conteneur coloré)
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: logoColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            // Utiliser une icône si l'asset n'est pas disponible, 
            // ou un Image.asset(logoPath) si les logos sont disponibles.
            child: Icon(Icons.school, color: logoColor), 
          ),
          
          const SizedBox(width: 15),

          // Détails du Partenaire
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontFamily: _fontFamily,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 10),

          // Bouton Visiter
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _purpleMain,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            ),
            child: const Text(
              'Visiter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}