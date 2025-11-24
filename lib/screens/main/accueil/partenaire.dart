import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/services/partenaire_service.dart';
import 'package:edugo/models/partenaire.dart';
import 'package:built_collection/built_collection.dart';
import 'package:edugo/screens/main/bibliotheque/webview_screen.dart';

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
  final PartenaireService _partenaireService = PartenaireService();
  BuiltList<Partenaire>? _partners;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _themeService = widget.themeService ?? ThemeService();
    _loadPartners();
  }

  Future<void> _loadPartners() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final partners = await _partenaireService.getPartenairesActifs();
      if (mounted) {
        setState(() {
          _partners = partners;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading partners: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement des partenaires: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Partenaires éducatifs',
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // 3. Liste des Partenaires
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildPartnersList(primaryColor),

                const SizedBox(height: 80), // Espace final pour la barre de navigation
              ],
            ),
          ),
        );
      },
    );
  }

  // --- WIDGETS DE STRUCTURE PRINCIPALE ---

  Widget _buildPartnersList(Color primaryColor) {
    if (_partners == null || _partners!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.business_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 20),
              const Text(
                'Aucun partenaire disponible pour le moment.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: _colorBlack,
                  fontFamily: _fontFamily,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _partners!.length,
      itemBuilder: (context, index) {
        final partner = _partners![index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _PartnerCard(
            partner: partner,
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
  final Partenaire partner;
  final Color primaryColor;

  const _PartnerCard({
    required this.partner,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final name = partner.nom ?? 'Partenaire';
    final description = partner.description ?? '';
    final logoUrl = partner.logoUrl;
    final siteWeb = partner.siteWeb;
    final domaine = partner.domaine;
    final type = partner.type;
    final pays = partner.pays;
    
    return GestureDetector(
      onTap: siteWeb != null && siteWeb!.isNotEmpty
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewScreen(
                    url: siteWeb!.startsWith('http') ? siteWeb! : 'https://$siteWeb',
                    title: name,
                  ),
                ),
              );
            }
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor.withOpacity(0.1),
              primaryColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: primaryColor.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview du site (header avec logo)
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryColor.withOpacity(0.1),
                            primaryColor.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Logo centré
                  Center(
                    child: logoUrl != null && logoUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Image.network(
                                logoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.business,
                                    color: primaryColor,
                                    size: 40,
                                  );
                                },
                              ),
                            ),
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.business,
                              color: primaryColor,
                              size: 40,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            
            // Contenu de la card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom du partenaire
                  Text(
                    name,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: _fontFamily,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Description
                  if (description.isNotEmpty) ...[
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                        fontFamily: _fontFamily,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // Attributs supplémentaires
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (domaine != null && domaine!.isNotEmpty)
                        _buildAttributeChip(
                          Icons.category,
                          domaine!,
                          primaryColor,
                        ),
                      if (type != null && type!.isNotEmpty)
                        _buildAttributeChip(
                          Icons.business_center,
                          type!,
                          primaryColor,
                        ),
                      if (pays != null && pays!.isNotEmpty)
                        _buildAttributeChip(
                          Icons.location_on,
                          pays!,
                          primaryColor,
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Bouton Visiter
                  if (siteWeb != null && siteWeb!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.open_in_new, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Visiter le site',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: _fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAttributeChip(IconData icon, String label, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              fontFamily: _fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}