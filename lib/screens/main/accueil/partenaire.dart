import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';

// --- CONSTANTES DE STYLES ---
const Color _colorBlack = Color(0xFF000000); // Texte noir
const String _fontFamily = 'Roboto'; // Police principale

class PartnersScreen extends StatefulWidget {
  final ThemeService? themeService; // Rendez optionnel

  const PartnersScreen({super.key, this.themeService}); // Enlevez required

  @override
  State<PartnersScreen> createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  late ThemeService _themeService;

  @override
  void initState() {
    super.initState();
    _themeService = widget.themeService ?? ThemeService();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
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
                      _buildPartnersList(primaryColor),

                      const SizedBox(height: 80), // Espace final pour la barre de navigation
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
                  icon: const Icon(Icons.arrow_back_ios, color: _colorBlack), // Flèche en noir
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Partenaires éducatifs',
                      style: TextStyle(
                        color: _colorBlack, // Titre en noir
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

  Widget _buildPartnersList(Color primaryColor) {
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
            primaryColor: primaryColor,
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
  final Color logoColor;
  final Color primaryColor;

  const _PartnerCard({
    required this.name,
    required this.description,
    required this.logoPath,
    required this.logoColor,
    required this.primaryColor,
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
            color: primaryColor.withOpacity(0.1), // Ombre adaptée au thème
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: primaryColor.withOpacity(0.1), // Bordure subtile adaptée au thème
          width: 1,
        ),
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
                  style: TextStyle(
                    color: primaryColor.withOpacity(0.7), // Texte adapté au thème
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
              backgroundColor: primaryColor, // Bouton avec couleur du thème
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