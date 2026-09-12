import 'package:edugo/core/constants/constant.dart';
import 'package:edugo/models/livre.dart';
import 'package:edugo/services/api/api.dart';
import 'package:flutter/material.dart';

/// Onglet Bibliothèque : catalogue de livres servi par l'API
/// (`GET /livres` ; catalogue local en mode démo), avec recherche par
/// titre/auteur et filtres Niveau / Matières / Classe.
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Livre> _livres = const [];
  bool _isLoading = true;
  String? _errorMessage;

  String _recherche = '';
  String? _niveau;
  String? _matiere;
  String? _classe;

  @override
  void initState() {
    super.initState();
    _chargerLivres();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _chargerLivres() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final List<Livre> livres = await AuthService.instance.fetchLivres();
      if (!mounted) return;
      setState(() {
        _livres = livres;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (_) {
      // Réponse inattendue (JSON invalide…) : ne pas laisser le
      // chargement tourner indéfiniment.
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Impossible de charger les livres. Réessayez.';
        _isLoading = false;
      });
    }
  }

  List<Livre> get _livresFiltres {
    final String terme = _recherche.trim().toLowerCase();
    return _livres.where((livre) {
      if (_niveau != null && livre.niveauScolaire != _niveau) return false;
      if (_matiere != null && livre.matiere != _matiere) return false;
      if (_classe != null && livre.classe != _classe) return false;
      if (terme.isEmpty) return true;
      return livre.titre.toLowerCase().contains(terme) ||
          livre.auteur.toLowerCase().contains(terme);
    }).toList();
  }

  List<String> _valeurs(String Function(Livre) champ) {
    final Set<String> valeurs = {
      for (final livre in _livres)
        if (champ(livre).isNotEmpty) champ(livre),
    };
    final List<String> triees = valeurs.toList()..sort();
    return triees;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Livres',
          style: TextStyle(
            color: AppConst.textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: AppConst.fontFamily,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppConst.purpleDark,
        onRefresh: _chargerLivres,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildFilterBars(),
              const SizedBox(height: 20),
              _buildContenu(),
              const SizedBox(height: 20),
            ],
          ),
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
      child: TextField(
        controller: _searchController,
        onChanged: (valeur) => setState(() => _recherche = valeur),
        style: const TextStyle(
          fontFamily: AppConst.fontFamily,
          fontSize: 15,
          color: AppConst.textDark,
        ),
        decoration: const InputDecoration(
          hintText: 'Rechercher un livre par nom ou auteur',
          hintStyle: TextStyle(color: AppConst.textGrey),
          prefixIcon: Icon(Icons.search, color: AppConst.textGrey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildFilterBars() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            label: 'Niveau',
            selection: _niveau,
            valeurs: _valeurs((livre) => livre.niveauScolaire),
            onChanged: (valeur) => setState(() => _niveau = valeur),
          ),
          const SizedBox(width: 10),
          _buildFilterChip(
            label: 'Matières',
            selection: _matiere,
            valeurs: _valeurs((livre) => livre.matiere),
            onChanged: (valeur) => setState(() => _matiere = valeur),
          ),
          const SizedBox(width: 10),
          _buildFilterChip(
            label: 'Classe',
            selection: _classe,
            valeurs: _valeurs((livre) => livre.classe),
            onChanged: (valeur) => setState(() => _classe = valeur),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String? selection,
    required List<String> valeurs,
    required ValueChanged<String?> onChanged,
  }) {
    final bool actif = selection != null;
    return PopupMenuButton<String>(
      onSelected: (valeur) => onChanged(valeur == '' ? null : valeur),
      itemBuilder: (context) => [
        const PopupMenuItem(value: '', child: Text('Tous')),
        for (final valeur in valeurs)
          PopupMenuItem(value: valeur, child: Text(valeur)),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: actif ? AppConst.purpleInputFill : Colors.white,
          border: Border.all(
              color: actif ? AppConst.purpleDark : Colors.grey.shade400),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selection ?? label,
              style: TextStyle(
                color: actif ? AppConst.purpleDark : AppConst.textDark,
                fontSize: 14,
                fontFamily: AppConst.fontFamily,
              ),
            ),
            const SizedBox(width: 5),
            Icon(Icons.keyboard_arrow_down,
                size: 20,
                color: actif ? AppConst.purpleDark : AppConst.textDark),
          ],
        ),
      ),
    );
  }

  Widget _buildContenu() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 80),
        child: Center(
          child: CircularProgressIndicator(color: AppConst.purpleDark),
        ),
      );
    }
    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            const Icon(Icons.cloud_off_rounded,
                size: 48, color: AppConst.textGrey),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppConst.textGrey,
                fontSize: 14,
                fontFamily: AppConst.fontFamily,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _chargerLivres,
              icon: const Icon(Icons.refresh, color: AppConst.purpleDark),
              label: const Text(
                'Réessayer',
                style: TextStyle(
                  color: AppConst.purpleDark,
                  fontFamily: AppConst.fontFamily,
                ),
              ),
            ),
          ],
        ),
      );
    }
    final List<Livre> livres = _livresFiltres;
    if (livres.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.menu_book_rounded, size: 48, color: AppConst.textGrey),
            SizedBox(height: 12),
            Text(
              'Aucun livre ne correspond à votre recherche.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppConst.textGrey,
                fontSize: 14,
                fontFamily: AppConst.fontFamily,
              ),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 0.55,
      ),
      itemCount: livres.length,
      itemBuilder: (context, index) => _BookCard(livre: livres[index]),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Livre livre;

  const _BookCard({required this.livre});

  /// Couverture : URL réseau ou asset local, avec le même visuel de
  /// secours dans les deux cas.
  Widget _buildCouverture() {
    final String image = livre.image ?? 'assets/images/book1.png';
    Widget secours(BuildContext context, Object error, StackTrace? stack) {
      return Container(
        color: AppConst.purpleInputFill,
        child: const Center(
          child: Icon(Icons.menu_book_rounded,
              size: 48, color: AppConst.purpleDark),
        ),
      );
    }

    if (image.startsWith('http://') || image.startsWith('https://')) {
      return Image.network(
        image,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: secours,
      );
    }
    return Image.asset(
      image,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: secours,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildCouverture(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8, right: 8),
            child: Text(
              livre.titre,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppConst.textDark,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: AppConst.fontFamily,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8, right: 8),
            child: Text(
              'Auteur : ${livre.auteur}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppConst.textGrey,
                fontSize: 12,
                fontFamily: AppConst.fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
