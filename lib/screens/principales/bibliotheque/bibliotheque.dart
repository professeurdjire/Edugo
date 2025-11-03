import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/bibliotheque/telechargement.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8);
const Color _colorBlack = Color(0xFF000000);
const String _fontFamily = 'Roboto';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Corps principal
      body: Column(
        children: [
          _buildCustomAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  _buildSearchBar(),
                  const SizedBox(height: 15),
                  _buildFilters(context),
                  const SizedBox(height: 15),
                  _buildBookGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE STRUCTURE ET EN-TÊTE ---

    // Remplacement de _buildHeader par _buildCustomAppBar
    Widget _buildCustomAppBar(BuildContext context) {
      // Cette structure reproduit l'en-tête sans la barre colorée
      return SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Titre "Livres"
              Row(
                children: [
                  // Icone de retour (absente de la capture Livres, mais souvent nécessaire)
                  // Retiré pour coller à l'image fournie, mais vous pouvez le remettre si besoin.
                  const SizedBox(width: 48), // Espace pour aligner le titre au centre

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Livres',
                        style: TextStyle(
                          color: _colorBlack,
                          fontSize: 24, // Ajusté pour coller au style de l'image
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ),
                  ),
                  // Placeholder pour aligner le titre
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    }
  // --- WIDGET UTILITAIRE POUR L'EFFET DE DÉGRADÉ ---
  Widget _buildFadingEdge({required Widget child, required BuildContext context}) {
    return ShaderMask(
      // Crée le masque de dégradé.
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          // Le dégradé va de la gauche (0.0) vers la droite (1.0).
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          // Les couleurs: transparent à 0% et 100%, opaque à 5% et 95%.
          colors: [Colors.transparent, Colors.black, Colors.black, Colors.transparent],
          stops: [
            0.0,  // Dégradé transparent (début)
            0.05, // Opaque (5% du chemin)
            0.95, // Opaque (jusqu'à 95% du chemin)
            1.0,  // Dégradé transparent (fin)
          ],
        ).createShader(bounds);
      },
      // Le mode de fusion de la couche ShaderMask.
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }

  // --- BARRE DE RECHERCHE ---
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Rechercher un livre par nom ou auteur",
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // --- FILTRES (Mes Télé, Niveau, Matières, Classe) AVEC EFFET DE DÉGRADÉ ---
  Widget _buildFilters(BuildContext context) {
    // Le contenu défilable
    final filtersRow = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // Note: un padding est nécessaire à l'intérieur de la Row pour que le dégradé soit visible
      // sans rogner le contenu, surtout à gauche.
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0), // Padding pour le dégradé
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _FilterChip(
              label: 'Mes Téléchargements',
              isPrimary: true,
              showArrow: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelechargementsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            const _FilterChip(label: 'Niveau', showArrow: true),
            const SizedBox(width: 8),
            const _FilterChip(label: 'Matières', showArrow: true),
            const SizedBox(width: 8),
            const _FilterChip(label: 'Classe', showArrow: true),
          ],
        ),
      ),
    );

    // Enveloppe la rangée défilable dans le ShaderMask
    return _buildFadingEdge(child: filtersRow, context: context);
  }

  // --- GRILLE DE LIVRES ---
  Widget _buildBookGrid() {
    final List<Map<String, String>> books = [
      {'title': 'Le jardin invisible', 'author': 'Auteur : C.S.Lewis', 'image': 'book1.png'},
      {'title': 'Le cœur se souvient', 'author': 'Auteur : C.S.Lewis', 'image': 'book1.png'},
      {'title': 'Libre comme l\'ère', 'author': 'Auteur : C.S.Lewis', 'image': 'book1.png'},
      {'title': 'En apnée', 'author': 'Auteur : C.S.Lewis', 'image': 'book1.png'},
      {'title': 'Libre comme l\'ère', 'author': 'Auteur : C.S.Lewis', 'image': 'book1.png'},
      {'title': 'En apnée', 'author': 'Auteur : C.S.Lewis', 'image': 'book1.png'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        childAspectRatio: 0.62, // réduit la zone blanche sous l'image
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return _BookCard(
          title: books[index]['title']!,
          author: books[index]['author']!,
          imagePath: 'assets/images/${books[index]['image']!}',
        );
      },
    );
  }
}

// --- WIDGET PERSONNALISÉ POUR LES FILTRES / BOUTONS ---
class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isPrimary;
  final bool showArrow;

  const _FilterChip({
    required this.label,
    this.icon,
    this.onTap,
    this.isPrimary = false,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 80),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary ? _purpleMain : Colors.white,
          border: Border.all(
            color: isPrimary ? _purpleMain : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, color: isPrimary ? Colors.white : Colors.black, size: 18),
            if (icon != null) const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis, // tronque si trop long
                maxLines: 1,
                style: TextStyle(
                  color: isPrimary ? Colors.white : _colorBlack,
                  fontSize: 13,
                  fontFamily: _fontFamily,
                  fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (showArrow) const SizedBox(width: 5),
            if (showArrow)
              Icon(Icons.keyboard_arrow_down,
                  size: 18, color: isPrimary ? Colors.white : _colorBlack),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET PERSONNALISÉ POUR LES LIVRES ---
class _BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String imagePath;

  const _BookCard({
    required this.title,
    required this.author,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image du livre
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Zone blanche réduite
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: _fontFamily,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: _fontFamily,
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.download,
                    color: Colors.black87,
                    size: 18, // un peu plus petit
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
