import 'dart:io';
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfExtractorService {
  /// Extrait le texte d'un fichier PDF local avec Syncfusion
  static Future<String> extractTextFromFile(String filePath) async {
    try {
      final file = File(filePath);

      if (!file.existsSync()) {
        throw Exception('Fichier introuvable : $filePath');
      }

      // Lire les bytes du fichier PDF
      final bytes = await file.readAsBytes();
      return extractTextFromBytes(bytes);
    } catch (e) {
      print('[PdfExtractorService] Erreur extraction : $e');
      return "Impossible d'extraire le texte du PDF.";
    }
  }

  /// Extrait le texte depuis des bytes PDF
  static String extractTextFromBytes(Uint8List bytes) {
    try {
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      // Utiliser PdfTextExtractor pour récupérer le texte
      final PdfTextExtractor extractor = PdfTextExtractor(document);
      String text = extractor.extractText();

      document.dispose();

      return text.isNotEmpty ? text : "Aucun texte trouvé dans ce PDF.";
    } catch (e) {
      print('[PdfExtractorService] Erreur extraction depuis bytes : $e');
      return "Impossible d'extraire le texte du PDF.";
    }
  }
}
