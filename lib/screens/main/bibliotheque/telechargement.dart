import 'package:flutter/material.dart';
import 'package:edugo/services/book_file_service.dart';
import 'package:edugo/models/fichier_livre.dart';
import 'package:edugo/screens/main/bibliotheque/pdf_viewer.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:path/path.dart' as path;

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleAppbar = Color(0xFFA885D8); // Violet clair
const Color _colorBlack = Color(0xFF000000);
const Color _colorUnselected = Color(0xFFE0E0E0); // Gris clair
const String _fontFamily = 'Roboto';
const Color _shadowColor = Color(0xFFEEEEEE);

// ===================================================================
// ÉCRAN : TÉLÉCHARGEMENTS
// ===================================================================

class TelechargementsScreen extends StatefulWidget {
  const TelechargementsScreen({super.key});

  @override
  State<TelechargementsScreen> createState() => _TelechargementsScreenState();
}

class _TelechargementsScreenState extends State<TelechargementsScreen> {
  final BookFileService _bookFileService = BookFileService();
  final ThemeService _themeService = ThemeService();
  
  // Données des téléchargements
  List<Map<String, dynamic>> _downloadItems = [];
  bool _isLoading = true;

  // Liste filtrée pour la barre de recherche
  List<Map<String, dynamic>> _filteredItems = [];

  // Contrôleur de texte pour la recherche
  final TextEditingController _searchController = TextEditingController();
  
  // Tri et filtrage
  String _sortOption = 'date'; // date, name, size
  bool _sortAscending = false;
  String _filterType = 'all'; // all, pdf, epub, audio, image, video

  @override
  void initState() {
    super.initState();
    _loadDownloadedBooks();
    _searchController.addListener(_filterItems); // Écoute les changements de la barre de recherche
  }

  Future<void> _loadDownloadedBooks() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final downloadedBooks = await _bookFileService.getDownloadedBooks();
      setState(() {
        _downloadItems = downloadedBooks;
        _sortAndFilterItems();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading downloaded books: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sortAndFilterItems() {
    List<Map<String, dynamic>> items = List.from(_downloadItems);
    
    // Apply file type filter
    if (_filterType != 'all') {
      items = items.where((item) {
        final fileName = item['fileName'].toString().toLowerCase();
        switch (_filterType) {
          case 'pdf':
            return fileName.endsWith('.pdf');
          case 'epub':
            return fileName.endsWith('.epub');
          case 'audio':
            return fileName.endsWith('.mp3') || fileName.endsWith('.wav') || fileName.endsWith('.aac');
          case 'image':
            return fileName.endsWith('.jpg') || fileName.endsWith('.jpeg') || fileName.endsWith('.png') || fileName.endsWith('.gif');
          case 'video':
            return fileName.endsWith('.mp4') || fileName.endsWith('.avi') || fileName.endsWith('.mov');
          default:
            return true;
        }
      }).toList();
    }
    
    // Apply search filter
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      items = items.where((item) {
        final fileName = item['fileName'].toString().toLowerCase();
        return fileName.contains(query);
      }).toList();
    }
    
    // Apply sorting
    items.sort((a, b) {
      int compareResult;
      switch (_sortOption) {
        case 'name':
          compareResult = a['fileName'].toString().compareTo(b['fileName'].toString());
          break;
        case 'size':
          compareResult = (a['size'] as int).compareTo(b['size'] as int);
          break;
        case 'date':
        default:
          compareResult = (b['modified'] as DateTime).compareTo(a['modified'] as DateTime);
          break;
      }
      return _sortAscending ? compareResult : -compareResult;
    });
    
    setState(() {
      _filteredItems = items;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  // --- LOGIQUE DE RECHERCHE/FILTRE ---
  void _filterItems() {
    _sortAndFilterItems();
  }

  void _changeSort(String option) {
    if (_sortOption == option) {
      setState(() {
        _sortAscending = !_sortAscending;
      });
    } else {
      setState(() {
        _sortOption = option;
        _sortAscending = option == 'name'; // Default ascending for name, descending for others
      });
    }
    _sortAndFilterItems();
  }

  void _changeFilter(String type) {
    setState(() {
      _filterType = type;
    });
    _sortAndFilterItems();
  }

  // --- LOGIQUE DE SUPPRESSION ---
  void _deleteItem(String filePath) async {
    final success = await _bookFileService.deleteDownloadedBook(filePath);
    if (success) {
      setState(() {
        _downloadItems.removeWhere((item) => item['filePath'] == filePath);
        _filterItems(); // Rafraîchit la liste filtrée après suppression
      });
      // Optionnel : Afficher un SnackBar de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Élément supprimé avec succès.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la suppression.')),
      );
    }
  }

  // --- LOGIQUE D'OUVERTURE DE FICHIER ---
  void _openItem(Map<String, dynamic> item) async {
    final filePath = item['filePath'].toString();
    final fileName = item['fileName'].toString();
    
    // Try to determine file type from extension
    final extension = path.extension(fileName).toLowerCase();
    
    // For PDF files, open in our PDF viewer
    if (extension == '.pdf') {
      // Create a mock FichierLivre for the PDF viewer
      final fichier = FichierLivre((b) => b
        ..id = 0 // We don't have the actual ID
        ..nom = path.basenameWithoutExtension(fileName)
        ..format = 'pdf'
        ..type = FichierLivreTypeEnum.PDF
      );
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerScreen(
            filePath: filePath,
            title: fichier.nom ?? 'Document PDF',
          ),
        ),
      );
    } else {
      // For other file types, try to open with external app
      await _bookFileService.openWithExternalApp(filePath);
    }
  }

  // --- LOGIQUE D'AFFICHAGE DE LA MODALE DE SUPPRESSION ---
  void _showDeleteDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer "${item['fileName']}" de vos téléchargements ?'),
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
                _deleteItem(item['filePath']);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Téléchargements',
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
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
                    const SizedBox(height: 10),
                    _buildFilterAndSortBar(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // Liste des éléments téléchargés (filtrés)
              if (_isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                Expanded(
                  child: _filteredItems.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 40),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: _DownloadListItem(
                                item: item,
                                onOpen: () => _openItem(item),
                                onDelete: () => _showDeleteDialog(item),
                                accentColor: primaryColor,
                              ),
                            );
                          },
                        ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterAndSortBar() {
    return Row(
      children: [
        // Filter dropdown
        DropdownButton<String>(
          value: _filterType,
          items: const [
            DropdownMenuItem(value: 'all', child: Text('Tous')),
            DropdownMenuItem(value: 'pdf', child: Text('PDF')),
            DropdownMenuItem(value: 'epub', child: Text('EPUB')),
            DropdownMenuItem(value: 'audio', child: Text('Audio')),
            DropdownMenuItem(value: 'image', child: Text('Images')),
            DropdownMenuItem(value: 'video', child: Text('Vidéo')),
          ],
          onChanged: (value) {
            if (value != null) {
              _changeFilter(value);
            }
          },
          icon: const Icon(Icons.filter_list, size: 20),
          underline: Container(),
        ),
        const SizedBox(width: 10),
        
        // Sort dropdown
        DropdownButton<String>(
          value: _sortOption,
          items: const [
            DropdownMenuItem(value: 'date', child: Text('Date')),
            DropdownMenuItem(value: 'name', child: Text('Nom')),
            DropdownMenuItem(value: 'size', child: Text('Taille')),
          ],
          onChanged: (value) {
            if (value != null) {
              _changeSort(value);
            }
          },
          icon: Icon(
            _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
            size: 20,
          ),
          underline: Container(),
        ),
        const Spacer(),
        
        // Refresh button
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadDownloadedBooks,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_done,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          const Text(
            'Aucun téléchargement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Les livres que vous téléchargez apparaîtront ici',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE STRUCTURE ---

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
          hintText: 'Rechercher un livre par nom',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}

// COMPOSANT : ÉLÉMENT DE TÉLÉCHARGEMENT
// ===================================================================

class _DownloadListItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onOpen; // Callback pour l'action d'ouverture
  final VoidCallback onDelete; // Callback pour l'action de suppression
  final Color accentColor;

  const _DownloadListItem({
    required this.item,
    required this.onOpen,
    required this.onDelete,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    // Extract file information
    final fileName = item['fileName'].toString();
    final size = item['size'] as int;
    final modified = item['modified'] as DateTime;
    
    // Format file size
    String formattedSize;
    if (size < 1024) {
      formattedSize = '$size B';
    } else if (size < 1024 * 1024) {
      formattedSize = '${(size / 1024).toStringAsFixed(1)} KB';
    } else {
      formattedSize = '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    
    // Format date
    final formattedDate = '${modified.day}/${modified.month}/${modified.year}';

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
          // 1. Icon based on file type
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getFileIcon(fileName),
              color: accentColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),

          // 2. Texte (Nom du fichier, taille et date)
          Expanded(
            child: GestureDetector(
              onTap: onOpen, // Open file when tapped
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fileName,
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
                    '$formattedSize • $formattedDate',
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
                value: 'open',
                child: Row(
                  children: [
                    Icon(Icons.open_in_new, color: _purpleAppbar),
                    SizedBox(width: 8),
                    Text('Ouvrir', style: TextStyle(color: _purpleAppbar)),
                  ],
                ),
              ),
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
  
  IconData _getFileIcon(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    switch (extension) {
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.epub':
        return Icons.chrome_reader_mode;
      case '.mp3':
      case '.wav':
      case '.aac':
        return Icons.audiotrack;
      case '.mp4':
      case '.avi':
      case '.mov':
        return Icons.movie;
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return Icons.image;
      default:
        return Icons.description;
    }
  }
}