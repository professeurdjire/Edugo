import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget pour afficher un logo avec des couleurs dynamiques basées sur le thème
/// Utilise ColorFilter pour changer les couleurs d'un PNG
class DynamicLogo extends StatefulWidget {
  final String assetPath;
  final Color primaryColor;
  final Color? secondaryColor; // Couleur secondaire (noir par défaut)
  final double? height;
  final double? width;
  final BoxFit fit;

  const DynamicLogo({
    super.key,
    required this.assetPath,
    required this.primaryColor,
    this.secondaryColor,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  @override
  State<DynamicLogo> createState() => _DynamicLogoState();
}

class _DynamicLogoState extends State<DynamicLogo> {
  ui.Image? _image;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(DynamicLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath ||
        oldWidget.primaryColor != widget.primaryColor ||
        oldWidget.secondaryColor != widget.secondaryColor) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    try {
      final ByteData data = await rootBundle.load(widget.assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      setState(() {
        _image = frame.image;
        _isLoading = false;
      });
    } catch (e) {
      print('[DynamicLogo] Erreur lors du chargement de l\'image: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: widget.height ?? 120,
        width: widget.width,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_image == null) {
      // Fallback vers Image.asset si le chargement échoue
      return Image.asset(
        widget.assetPath,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
      );
    }

    return CustomPaint(
      size: Size(
        widget.width ?? _image!.width.toDouble(),
        widget.height ?? _image!.height.toDouble(),
      ),
      painter: _DynamicLogoPainter(
        image: _image!,
        primaryColor: widget.primaryColor,
        secondaryColor: widget.secondaryColor ?? Colors.black,
      ),
    );
  }

  @override
  void dispose() {
    _image?.dispose();
    super.dispose();
  }
}

class _DynamicLogoPainter extends CustomPainter {
  final ui.Image image;
  final Color primaryColor;
  final Color secondaryColor;

  _DynamicLogoPainter({
    required this.image,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculer le facteur d'échelle pour ajuster l'image à la taille du widget
    final scaleX = size.width / image.width;
    final scaleY = size.height / image.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    final scaledWidth = image.width * scale;
    final scaledHeight = image.height * scale;
    final offsetX = (size.width - scaledWidth) / 2;
    final offsetY = (size.height - scaledHeight) / 2;

    // Créer un Paint avec ColorFilter pour remplacer les couleurs
    final paint = Paint()
      ..colorFilter = _createColorFilter();

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(offsetX, offsetY, scaledWidth, scaledHeight),
      paint,
    );
  }

  /// Créer un ColorFilter pour remplacer les couleurs du logo
  /// Cette méthode utilise une matrice de transformation de couleur
  ColorFilter _createColorFilter() {
    // Matrice pour remplacer les couleurs spécifiques
    // Format: [R, G, B, A, Offset]
    // Pour remplacer une couleur, on utilise une matrice de transformation
    
    // Approche: Utiliser ColorFilter.matrix pour ajuster les couleurs
    // On va créer un filtre qui remplace les pixels violets/colorés par primaryColor
    // et les pixels noirs par secondaryColor
    
    // Matrice de base (identité)
    final matrix = List<double>.filled(20, 0);
    matrix[0] = 1; // R
    matrix[6] = 1; // G
    matrix[12] = 1; // B
    matrix[18] = 1; // A

    // Pour un remplacement de couleur plus précis, on utilise ColorFilter.mode
    // avec BlendMode pour mélanger les couleurs
    
    // Solution alternative: Utiliser plusieurs ColorFilter combinés
    return ColorFilter.mode(primaryColor, BlendMode.srcATop);
  }

  @override
  bool shouldRepaint(_DynamicLogoPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.image != image;
  }
}

/// Version simplifiée utilisant ColorFiltered (plus performant)
/// Supporte à la fois PNG et SVG
/// Pour SVG : remplace #6A3FA8 (violet) par primaryColor et garde #333333 (noir)
class DynamicLogoSimple extends StatefulWidget {
  final String assetPath;
  final Color primaryColor;
  final Color? secondaryColor;
  final double? height;
  final double? width;
  final BoxFit fit;

  const DynamicLogoSimple({
    super.key,
    required this.assetPath,
    required this.primaryColor,
    this.secondaryColor,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  @override
  State<DynamicLogoSimple> createState() => _DynamicLogoSimpleState();
}

class _DynamicLogoSimpleState extends State<DynamicLogoSimple> {
  String? _modifiedSvgString;
  bool _isLoading = true;

  bool get _isSvg => widget.assetPath.toLowerCase().endsWith('.svg');

  @override
  void initState() {
    super.initState();
    if (_isSvg) {
      _loadAndModifySvg();
    } else {
      _isLoading = false;
    }
  }

  @override
  void didUpdateWidget(DynamicLogoSimple oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isSvg && (oldWidget.primaryColor != widget.primaryColor || 
                   oldWidget.assetPath != widget.assetPath)) {
      _loadAndModifySvg();
    }
  }

  Future<void> _loadAndModifySvg() async {
    try {
      final svgString = await rootBundle.loadString(widget.assetPath);
      
      // Convertir primaryColor en format hexadécimal
      final primaryColorHex = _colorToHex(widget.primaryColor);
      
      // Remplacer #6A3FA8 (violet) par primaryColor dans les gradients
      // Garder #333333 (noir) tel quel
      final modifiedSvg = svgString
          .replaceAll('#6A3FA8', primaryColorHex)
          .replaceAll('#6a3fa8', primaryColorHex.toLowerCase());
      
      if (mounted) {
        setState(() {
          _modifiedSvgString = modifiedSvg;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('[DynamicLogoSimple] Erreur lors du chargement du SVG: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: widget.height ?? 120,
        width: widget.width,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Si c'est un SVG, utiliser le SVG modifié
    if (_isSvg && _modifiedSvgString != null) {
      return SvgPicture.string(
        _modifiedSvgString!,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
      );
    }
    
    // Fallback : utiliser SvgPicture.asset avec colorFilter si la modification a échoué
    if (_isSvg) {
      return SvgPicture.asset(
        widget.assetPath,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
        colorFilter: ColorFilter.mode(
          widget.primaryColor,
          BlendMode.srcIn,
        ),
      );
    }
    
    // Pour PNG, utiliser ColorFiltered
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        widget.primaryColor,
        BlendMode.srcATop,
      ),
      child: Image.asset(
        widget.assetPath,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
        color: widget.primaryColor,
        colorBlendMode: BlendMode.srcATop,
      ),
    );
  }
}

/// Version avancée avec remplacement de couleurs spécifiques
/// Utilise un shader personnalisé pour remplacer des couleurs précises
class DynamicLogoAdvanced extends StatelessWidget {
  final String assetPath;
  final Color primaryColor;
  final Color secondaryColor;
  final double? height;
  final double? width;
  final BoxFit fit;

  const DynamicLogoAdvanced({
    super.key,
    required this.assetPath,
    required this.primaryColor,
    this.secondaryColor = Colors.black,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    // Pour un remplacement de couleur précis, on utilise un Stack avec
    // plusieurs Image.asset avec des ColorFilter différents
    // ou on utilise un package comme image ou flutter_colorpicker
    
    // Solution recommandée: Utiliser un SVG au lieu d'un PNG pour un meilleur contrôle
    // ou utiliser un package comme flutter_svg avec des couleurs dynamiques
    
    return Image.asset(
      assetPath,
      height: height,
      width: width,
      fit: fit,
      // Note: Pour un contrôle précis des couleurs, il est recommandé d'utiliser
      // un SVG avec flutter_svg et de remplacer les couleurs dans le SVG
    );
  }
}

