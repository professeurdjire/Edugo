import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleAppbar = Color(0xFFA885D8); // Violet clair
const Color _colorBlack = Color(0xFF000000);
const Color _colorUnselected = Color(0xFFE0E0E0); // Gris clair
const String _fontFamily = 'Roboto';
const Color _shadowColor = Color(0xFFEEEEEE);

// --- STRUCTURE DE DONNÉES ---
class DownloadItem {
  final String id;
  final String title;
  final String author;
  final String imagePath;

  DownloadItem({
    required this.id,
    required this.title,
    required this.author,
    required this.imagePath,
  });
}

// ===================================================================
// ÉCRAN : TÉLÉCHARGEMENTS
// ===================================================================

class TelechargementsScreen extends StatefulWidget {
  const TelechargementsScreen({super.key});

  @override
  State<TelechargementsScreen> createState() => _TelechargementsScreenState();
}

class _TelechargementsScreenState extends State<TelechargementsScreen> {
  // Données initiales des téléchargements
  List<DownloadItem> _downloadItems = [
    DownloadItem(id: '1', title: 'Le jardin invisible', author: 'C.S.Lewis', imagePath: 'assets/images/book1.png'),
    DownloadItem(id: '2', title: 'Rêves du Feu', author: 'C.S.Lewis', imagePath: 'assets/images/book1.png'),
    DownloadItem(id: '3', title: 'Les larmes du lac', author: 'Marie Havard', imagePath: 'assets/images/book1.png'),
    DownloadItem(id: '4', title: 'La peine de Fer', author: 'C.S.Lewis', imagePath: 'assets/images/book1.png'),
    DownloadItem(id: '5', title: 'Le jardin invisible', author: 'C.S.Lewis', imagePath: 'assets/images/book1.png'),
    DownloadItem(id: '6', title: 'Les contes du Mandé', author: 'Marie Paule Huet', imagePath: 'assets/images/book1.png'),
  ];

  // Liste filtrée pour la barre de recherche
  List<DownloadItem> _filteredItems = [];

  // Contrôleur de texte pour la recherche
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = _downloadItems; // Initialise la liste filtrée avec tous les éléments
    _searchController.addListener(_filterItems); // Écoute les changements de la barre de recherche
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  // --- LOGIQUE DE RECHERCHE/FILTRE ---
  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _downloadItems;
      } else {
        _filteredItems = _downloadItems.where((item) {
          final titleLower = item.title.toLowerCase();
          final authorLower = item.author.toLowerCase();
          return titleLower.contains(query) || authorLower.contains(query);
        }).toList();
      }
    });
  }

  // --- LOGIQUE DE SUPPRESSION ---
  void _deleteItem(String id) {
    setState(() {
      _downloadItems.removeWhere((item) => item.id == id);
      _filterItems(); // Rafraîchit la liste filtrée après suppression
    });
    // Optionnel : Afficher un SnackBar de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Élément supprimé avec succès.')),
    );
  }

  // --- LOGIQUE D'AFFICHAGE DE LA MODALE DE SUPPRESSION ---
  void _showDeleteDialog(DownloadItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer "${item.title}" de vos téléchargements ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler', style: TextStyle(color: _colorBlack)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              // Utilise la couleur d'erreur pour attirer l'attention sur l'action
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteItem(item.id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: _buildCustomAppBar(context),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildSearchBar(),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Liste des éléments téléchargés (filtrés)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 40),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: _DownloadListItem(
                    item: item,
                    onDelete: () => _showDeleteDialog(item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE STRUCTURE ---

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      color: _purpleAppbar, // Fond violet pour la barre de statut
      child: SafeArea(
        bottom: false,
        child: Container(
          color: Colors.white, // Fond blanc pour la zone de navigation/titre
          padding: const EdgeInsets.only(top: 10.0, left: 0, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  // Icône de retour
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: _colorBlack),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Centrer le titre "Téléchargements"
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Téléchargements',
                        style: TextStyle(
                          color: _colorBlack,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Espace pour aligner le titre
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [ // Ajout d'une légère ombre pour l'aspect de l'image
          BoxShadow(
            color: _shadowColor,
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController, // Lié au contrôleur
        decoration: const InputDecoration(
          hintText: 'Rechercher un livre par nom ou auteur',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}


// ===================================================================
// COMPOSANT : ÉLÉMENT DE TÉLÉCHARGEMENT
// ===================================================================

class _DownloadListItem extends StatelessWidget {
  final DownloadItem item;
  final VoidCallback onDelete; // Callback pour l'action de suppression

  const _DownloadListItem({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _shadowColor,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.imagePath,
              width: 50,
              height: 75,
              fit: BoxFit.cover,
              // Utilise un placeholder si l'asset n'est pas trouvé
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 75,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.book, color: Colors.grey),
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
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Auteur : ${item.author}',
                  maxLines: 1,
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

          // 3. Bouton Menu (Trois points)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: _colorBlack),
            onSelected: (String result) {
              if (result == 'delete') {
                onDelete(); // Déclenche l'action de suppression définie dans _TelechargementsScreenState
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Supprimer', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            // Ajuster le style du menu si nécessaire
            surfaceTintColor: Colors.white,
          ),
        ],
      ),
    );
  }
}