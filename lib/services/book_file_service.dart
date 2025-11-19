import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/fichier_livre.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:edugo/screens/main/bibliotheque/pdf_viewer.dart';

class BookFileService {
  static final BookFileService _instance = BookFileService._internal();
  
  final AuthService _authService = AuthService();
  
  factory BookFileService() {
    return _instance;
  }
  
  BookFileService._internal();

  Dio get _dio => _authService.dio;
  
  /// Download a book file and save it locally using the correct API endpoint
  Future<String?> downloadBookFile(FichierLivre fichier) async {
    try {
      print('Starting download of book file: ${fichier.nom}');
      print('File ID: ${fichier.id}, Format: ${fichier.format}');
      
      // Get the download directory
      final directory = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${directory.path}/books');
      print('Download directory: ${downloadDir.path}');
      
      // Create directory if it doesn't exist
      if (!await downloadDir.exists()) {
        print('Creating download directory');
        await downloadDir.create(recursive: true);
      }
      
      // Construct the full file path
      final fileName = '${fichier.id}_${fichier.nom}.${fichier.format}';
      final filePath = path.join(downloadDir.path, fileName);
      print('Full file path: $filePath');
      
      // Check if file already exists
      final file = File(filePath);
      if (await file.exists()) {
        print('File already exists, returning path');
        return filePath;
      }
      
      // Get the file download URL
      final fileId = fichier.id;
      final downloadUrl = '/api/livres/fichiers/$fileId/download';
      print('📥 URL de téléchargement: ${_dio.options.baseUrl}$downloadUrl');
      
      // Download the file using the correct endpoint with authentication
      final response = await _dio.get(
        downloadUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) {
            return status! < 500;
          },
          headers: {
            'Authorization': _dio.options.headers['Authorization']?.toString() ?? '',
          },
        ),
      );
      
      print('✅ Download response status: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('💾 Saving file to disk...');
        // Vérifier que les données sont bien des bytes
        if (response.data == null) {
          print('❌ Response data is null');
          return null;
        }
        
        // Save the file
        await file.writeAsBytes(response.data as List<int>);
        print('✅ File saved successfully to: $filePath');
        
        // Vérifier que le fichier existe bien
        if (await file.exists()) {
          final fileSize = await file.length();
          print('✅ File verified: ${fileSize} bytes');
          return filePath;
        } else {
          print('❌ File was not created');
          return null;
        }
      } else {
        print('❌ Download failed with status: ${response.statusCode}');
        if (response.data != null) {
          print('Response data: ${response.data}');
        }
        // Handle 401 Unauthorized specifically
        if (response.statusCode == 401) {
          print('⚠️ Authentication required for download. Please check if user is logged in.');
        }
      }
    } catch (e) {
      print('❌ Error downloading book file: $e');
      if (e is DioException) {
        print('   Dio error type: ${e.type}');
        print('   Dio error message: ${e.message}');
        print('   Request URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
        print('   Request method: ${e.requestOptions.method}');
        if (e.response != null) {
          print('   Response status: ${e.response?.statusCode}');
          print('   Response data: ${e.response?.data}');
          print('   Response headers: ${e.response?.headers}');
        } else {
          print('   No response received (connection error)');
        }
      } else {
        print('   Exception type: ${e.runtimeType}');
        print('   Stack trace: ${StackTrace.current}');
      }
    }
    return null;
  }
  
  /// Open a book file based on its type
  Future<void> openBookFile(FichierLivre fichier, String filePath, BuildContext context) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        print('Book file does not exist: $filePath');
        return;
      }
      
      // Handle different file types
      switch (fichier.type) {
        case FichierLivreTypeEnum.PDF:
          // For PDF files, we can display them in the app using a PDF viewer
          print('Opening PDF file: $filePath');
          // Navigate to PDF viewer screen
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfViewerScreen(
                  filePath: filePath,
                  title: fichier.nom ?? 'Document PDF',
                ),
              ),
            );
          }
          break;
          
        case FichierLivreTypeEnum.EPUB:
          // For EPUB files, we can display them in the app using an EPUB viewer
          print('Opening EPUB file: $filePath');
          // This would be handled by an EPUB viewer screen
          break;
          
        case FichierLivreTypeEnum.IMAGE:
          // For image files, we can display them in the app
          print('Opening image file: $filePath');
          // This would be handled by an image viewer
          break;
          
        case FichierLivreTypeEnum.VIDEO:
          // For video files, we can play them in the app
          print('Opening video file: $filePath');
          // This would be handled by a video player
          break;
          
        case FichierLivreTypeEnum.AUDIO:
          // For audio files, we can play them in the app
          print('Opening audio file: $filePath');
          // This would be handled by an audio player
          break;
          
        default:
          print('Unsupported file type: ${fichier.type}');
          // Try to open with external app
          await openWithExternalApp(filePath);
      }
    } catch (e) {
      print('Error opening book file: $e');
    }
  }
  
  /// Get the list of downloaded books
  Future<List<Map<String, dynamic>>> getDownloadedBooks() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${directory.path}/books');
      
      if (!await downloadDir.exists()) {
        return [];
      } 
      
      final files = downloadDir.listSync();
      final downloadedBooks = <Map<String, dynamic>>[];
      
      for (final file in files) {
        if (file is File) {
          final fileName = path.basename(file.path);
          final stats = await file.stat();
          
          downloadedBooks.add({
            'filePath': file.path,
            'fileName': fileName,
            'size': stats.size,
            'modified': stats.modified,
          });
        }
      }
      
      return downloadedBooks;
    } catch (e) {
      print('Error getting downloaded books: $e');
      return [];
    }
  }
  
  /// Delete a downloaded book file
  Future<bool> deleteDownloadedBook(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
    } catch (e) {
      print('Error deleting downloaded book: $e');
    }
    return false;
  }
  
  /// Check if a book file is already downloaded
  Future<bool> isBookDownloaded(FichierLivre fichier) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${directory.path}/books');
      
      if (!await downloadDir.exists()) {
        return false;
      }
      
      final fileName = '${fichier.id}_${fichier.nom}.${fichier.format}';
      final filePath = path.join(downloadDir.path, fileName);
      final file = File(filePath);
      
      return await file.exists();
    } catch (e) {
      print('Error checking if book is downloaded: $e');
      return false;
    }
  }
  
  /// Open file with external application
  Future<void> openWithExternalApp(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final uri = Uri.file(filePath);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          print('Cannot launch file: $filePath');
        }
      }
    } catch (e) {
      print('Error opening file with external app: $e');
    }
  }
}