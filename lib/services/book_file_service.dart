// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;
// import 'package:edugo/services/auth_service.dart';
// import 'package:edugo/models/fichier_livre.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:edugo/screens/main/bibliotheque/pdf_viewer.dart';

// class BookFileService {
//   static final BookFileService _instance = BookFileService._internal();
  
//   final AuthService _authService = AuthService();
  
//   factory BookFileService() {
//     return _instance;
//   }
  
//   BookFileService._internal();

//   Dio get _dio => _authService.dio;
  
//   /// Download a book file and save it locally using the correct API endpoint
//   Future<String?> downloadBookFile(FichierLivre fichier) async {
//     try {
//       print('Starting download of book file: ${fichier.nom}');
//       print('File ID: ${fichier.id}, Format: ${fichier.format}');
      
//       // Get the download directory
//       final directory = await getApplicationDocumentsDirectory();
//       final downloadDir = Directory('${directory.path}/books');
//       print('Download directory: ${downloadDir.path}');
      
//       // Create directory if it doesn't exist
//       if (!await downloadDir.exists()) {
//         print('Creating download directory');
//         await downloadDir.create(recursive: true);
//       }
      
//       // Construct the full file path
//       final fileName = '${fichier.id}_${fichier.nom}.${fichier.format}';
//       final filePath = path.join(downloadDir.path, fileName);
//       print('Full file path: $filePath');
      
//       // Check if file already exists
//       final file = File(filePath);
//       if (await file.exists()) {
//         print('File already exists, returning path');
//         return filePath;
//       }
      
//       // Get the file download URL
//       final fileId = fichier.id;
//       final downloadUrl = '/api/livres/fichiers/$fileId/download';
//       print('📥 URL de téléchargement: ${_dio.options.baseUrl}$downloadUrl');
      
//       // Download the file using the correct endpoint with authentication
//       final response = await _dio.get(
//         downloadUrl,
//         options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: true,
//           validateStatus: (status) {
//             return status! < 500;
//           },
//           headers: {
//             'Authorization': _dio.options.headers['Authorization']?.toString() ?? '',
//           },
//         ),
//       );
      
//       print('✅ Download response status: ${response.statusCode}');
      
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print('💾 Saving file to disk...');
//         // Vérifier que les données sont bien des bytes
//         if (response.data == null) {
//           print('❌ Response data is null');
//           return null;
//         }
        
//         // Save the file
//         await file.writeAsBytes(response.data as List<int>);
//         print('✅ File saved successfully to: $filePath');
        
//         // Vérifier que le fichier existe bien
//         if (await file.exists()) {
//           final fileSize = await file.length();
//           print('✅ File verified: ${fileSize} bytes');
//           return filePath;
//         } else {
//           print('❌ File was not created');
//           return null;
//         }
//       } else {
//         print('❌ Download failed with status: ${response.statusCode}');
//         if (response.data != null) {
//           print('Response data: ${response.data}');
//         }
//         // Handle 401 Unauthorized specifically
//         if (response.statusCode == 401) {
//           print('⚠️ Authentication required for download. Please check if user is logged in.');
//         }
//       }
//     } catch (e) {
//       print('❌ Error downloading book file: $e');
//       if (e is DioException) {
//         print('   Dio error type: ${e.type}');
//         print('   Dio error message: ${e.message}');
//         print('   Request URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
//         print('   Request method: ${e.requestOptions.method}');
//         if (e.response != null) {
//           print('   Response status: ${e.response?.statusCode}');
//           print('   Response data: ${e.response?.data}');
//           print('   Response headers: ${e.response?.headers}');
//         } else {
//           print('   No response received (connection error)');
//         }
//       } else {
//         print('   Exception type: ${e.runtimeType}');
//         print('   Stack trace: ${StackTrace.current}');
//       }
//     }
//     return null;
//   }
  
//   /// Open a book file based on its type
//   Future<void> openBookFile(FichierLivre fichier, String filePath, BuildContext context) async {
//     try {
//       final file = File(filePath);
//       if (!await file.exists()) {
//         print('Book file does not exist: $filePath');
//         return;
//       }
      
//       // Handle different file types
//       switch (fichier.type) {
//         case FichierLivreTypeEnum.PDF:
//           // For PDF files, we can display them in the app using a PDF viewer
//           print('Opening PDF file: $filePath');
//           // Navigate to PDF viewer screen
//           if (context.mounted) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PdfViewerScreen(
//                   filePath: filePath,
//                   title: fichier.nom ?? 'Document PDF',
//                 ),
//               ),
//             );
//           }
//           break;
          
//         case FichierLivreTypeEnum.EPUB:
//           // For EPUB files, we can display them in the app using an EPUB viewer
//           print('Opening EPUB file: $filePath');
//           // This would be handled by an EPUB viewer screen
//           break;
          
//         case FichierLivreTypeEnum.IMAGE:
//           // For image files, we can display them in the app
//           print('Opening image file: $filePath');
//           // This would be handled by an image viewer
//           break;
          
//         case FichierLivreTypeEnum.VIDEO:
//           // For video files, we can play them in the app
//           print('Opening video file: $filePath');
//           // This would be handled by a video player
//           break;
          
//         case FichierLivreTypeEnum.AUDIO:
//           // For audio files, we can play them in the app
//           print('Opening audio file: $filePath');
//           // This would be handled by an audio player
//           break;
          
//         default:
//           print('Unsupported file type: ${fichier.type}');
//           // Try to open with external app
//           await openWithExternalApp(filePath);
//       }
//     } catch (e) {
//       print('Error opening book file: $e');
//     }
//   }
  
//   /// Get the list of downloaded books
//   Future<List<Map<String, dynamic>>> getDownloadedBooks() async {
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final downloadDir = Directory('${directory.path}/books');
      
//       if (!await downloadDir.exists()) {
//         return [];
//       } 
      
//       final files = downloadDir.listSync();
//       final downloadedBooks = <Map<String, dynamic>>[];
      
//       for (final file in files) {
//         if (file is File) {
//           final fileName = path.basename(file.path);
//           final stats = await file.stat();
          
//           downloadedBooks.add({
//             'filePath': file.path,
//             'fileName': fileName,
//             'size': stats.size,
//             'modified': stats.modified,
//           });
//         }
//       }
      
//       return downloadedBooks;
//     } catch (e) {
//       print('Error getting downloaded books: $e');
//       return [];
//     }
//   }
  
//   /// Delete a downloaded book file
//   Future<bool> deleteDownloadedBook(String filePath) async {
//     try {
//       final file = File(filePath);
//       if (await file.exists()) {
//         await file.delete();
//         return true;
//       }
//     } catch (e) {
//       print('Error deleting downloaded book: $e');
//     }
//     return false;
//   }
  
//   /// Check if a book file is already downloaded
//   Future<bool> isBookDownloaded(FichierLivre fichier) async {
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final downloadDir = Directory('${directory.path}/books');
      
//       if (!await downloadDir.exists()) {
//         return false;
//       }
      
//       final fileName = '${fichier.id}_${fichier.nom}.${fichier.format}';
//       final filePath = path.join(downloadDir.path, fileName);
//       final file = File(filePath);
      
//       return await file.exists();
//     } catch (e) {
//       print('Error checking if book is downloaded: $e');
//       return false;
//     }
//   }
  
//   /// Get the path of a downloaded book file
//   Future<String?> getDownloadedBookPath(FichierLivre fichier) async {
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final downloadDir = Directory('${directory.path}/books');
      
//       if (!await downloadDir.exists()) {
//         return null;
//       }
      
//       final fileName = '${fichier.id}_${fichier.nom}.${fichier.format}';
//       final filePath = path.join(downloadDir.path, fileName);
//       final file = File(filePath);
      
//       if (await file.exists()) {
//         return filePath;
//       }
//     } catch (e) {
//       print('Error getting downloaded book path: $e');
//     }
//     return null;
//   }
  
//   /// Open file with external application
//   Future<void> openWithExternalApp(String filePath) async {
//     try {
//       final file = File(filePath);
//       if (await file.exists()) {
//         final uri = Uri.file(filePath);
//         if (await canLaunchUrl(uri)) {
//           await launchUrl(uri);
//         } else {
//           print('Cannot launch file: $filePath');
//         }
//       }
//     } catch (e) {
//       print('Error opening file with external app: $e');
//     }
//   }
// }

// lib/services/book_file_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/fichier_livre.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:edugo/screens/main/bibliotheque/pdf_viewer.dart';

typedef ProgressCallback = void Function(int received, int total);

class BookFileService {
  static final BookFileService _instance = BookFileService._internal();
  factory BookFileService() => _instance;
  BookFileService._internal();

  final AuthService _authService = AuthService();
  Dio get _dio => _authService.dio;

  // Folder name used for downloads
  final String _booksDirName = 'books';

  // ---------- Helpers ----------
  String _sanitizeFileName(String name) {
    // Remove dangerous characters, keep letters, numbers, underscore and dot
    final sanitized = name.replaceAll(RegExp(r'[\/\\\<\>\:\*\?\"\|]'), '');
    return sanitized.replaceAll(RegExp(r'\s+'), '_');
  }

  Future<Directory?> _getDownloadDirectory() async {
    // path_provider doesn't work on web
    if (kIsWeb) {
      return null;
    }
    try {
      final directory = await getApplicationDocumentsDirectory();
      final downloadDir = Directory(p.join(directory.path, _booksDirName));
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
      return downloadDir;
    } catch (e) {
      print('[BookFileService] Error getting download directory: $e');
      return null;
    }
  }

  // ---------- Public API ----------

  /// Télécharge un fichier (supporte progress callback).
  /// Retourne le chemin local complet du fichier ou null si échec.
  Future<String?> downloadBookFile(
    FichierLivre fichier, {
    ProgressCallback? onProgress,
    CancelToken? cancelToken,
  }) async {
    // File downloads not supported on web
    if (kIsWeb) {
      print('[BookFileService] File downloads not supported on web platform');
      return null;
    }
    try {
      final downloadDir = await _getDownloadDirectory();
      if (downloadDir == null) {
        print('[BookFileService] Could not get download directory');
        return null;
      }

      // ensure format/nom safe
      final ext = (fichier.format ?? 'bin').toLowerCase();
      final rawName = '${fichier.id}_${fichier.nom ?? 'file'}';
      final fileName = '${_sanitizeFileName(rawName)}.$ext';
      final filePath = p.join(downloadDir.path, fileName);
      final file = File(filePath);

      // if exists return path
      if (await file.exists()) {
        print('[BookFileService] File already exists: $filePath');
        return filePath;
      }

      // Build download url (uses your backend endpoint)
      final fileId = fichier.id;
      final downloadUrl = '/api/livres/fichiers/$fileId/download';
      final resolvedUrl = (_dio.options.baseUrl ?? '') + downloadUrl;
      print('[BookFileService] Starting download from: $resolvedUrl');

      // Ensure Authorization exists (we rely on Dio configuration)
      final authHeader = _dio.options.headers['Authorization']?.toString();
      if (authHeader == null || authHeader.isEmpty) {
        print('[BookFileService][WARN] Authorization header is empty. ' 
              'If endpoint is protected the request will likely fail.');
      }

      final response = await _dio.get<List<int>>(
        downloadUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status != null && status < 500,
        ),
        onReceiveProgress: (received, total) {
          if (onProgress != null) onProgress(received, total == -1 ? 0 : total);
        },
        cancelToken: cancelToken,
      );

      print('[BookFileService] Download status: ${response.statusCode}');

      // Handle redirect or JSON that contains URL
      final contentType = response.headers.value('content-type') ?? '';
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        // Save bytes to disk
        final bytes = response.data!;
        await file.writeAsBytes(bytes, flush: true);
        final size = await file.length();
        print('[BookFileService] File saved: $filePath (${size} bytes)');
        return filePath;
      } else {
        // If server returned JSON with { "url": "..." } or redirect, handle it
        if (response.data == null || (response.statusCode != 200 && response.statusCode != 201)) {
          print('[BookFileService] Download failed. Status: ${response.statusCode}');
          if (response.data != null) {
            print('[BookFileService] Response data (non-bytes): ${response.data}');
          }
          return null;
        }
      }
    } on DioException catch (e) {
      print('[BookFileService] DioException: ${e.message}');
      if (e.response != null) {
        print(' -> status: ${e.response?.statusCode}');
        print(' -> data: ${e.response?.data}');
      }
    } catch (e, st) {
      print('[BookFileService] Error downloading: $e');
      print(st);
    }
    return null;
  }

  /// Ouvre le fichier local (tableau de dispatch par type).
  Future<void> openBookFile(
    FichierLivre fichier,
    String filePath,
    BuildContext context, {
    int? livreId,
    int? eleveId,
    int? totalPages,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        print('[BookFileService] File not found: $filePath');
        return;
      }

      switch (fichier.type) {
              case FichierLivreTypeEnum.PDF:
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PdfViewerScreen(
                        filePath: filePath,
                        title: fichier.nom ?? 'PDF',
                        livreId: livreId,
                        eleveId: eleveId,
                        totalPages: totalPages,
                      ),
                    ),
                  );
                }
                break;

        case FichierLivreTypeEnum.EPUB:
          // TODO: integrate EPUB viewer package (ex: epub_view)
          print('[BookFileService] EPUB open requested: $filePath (implement epub viewer)');
          await openWithExternalApp(filePath);
          break;

        case FichierLivreTypeEnum.IMAGE:
          // Open external for now or implement image viewer screen
          await openWithExternalApp(filePath);
          break;

        case FichierLivreTypeEnum.VIDEO:
          // Use video_player or open externally
          await openWithExternalApp(filePath);
          break;

        case FichierLivreTypeEnum.AUDIO:
          // Use any audio player widget or open externally
          await openWithExternalApp(filePath);
          break;

        default:
          print('[BookFileService] Unsupported type: ${fichier.type}');
          await openWithExternalApp(filePath);
      }
    } catch (e, st) {
      print('[BookFileService] Error opening file: $e');
      print(st);
    }
  }

  /// Check if file already downloaded
  Future<bool> isBookDownloaded(FichierLivre fichier) async {
    if (kIsWeb) {
      return false; // Downloads not supported on web
    }
    try {
      final downloadDir = await _getDownloadDirectory();
      if (downloadDir == null) return false;
      final ext = (fichier.format ?? 'bin').toLowerCase();
      final fileName = '${_sanitizeFileName('${fichier.id}_${fichier.nom ?? 'file'}')}.$ext';
      final filePath = p.join(downloadDir.path, fileName);
      return File(filePath).exists();
    } catch (e) {
      print('[BookFileService] Error checking downloaded: $e');
      return false;
    }
  }

  /// Get path of downloaded file or null
  Future<String?> getDownloadedBookPath(FichierLivre fichier) async {
    if (kIsWeb) {
      return null; // Downloads not supported on web
    }
    try {
      final downloadDir = await _getDownloadDirectory();
      if (downloadDir == null) return null;
      final ext = (fichier.format ?? 'bin').toLowerCase();
      final fileName = '${_sanitizeFileName('${fichier.id}_${fichier.nom ?? 'file'}')}.$ext';
      final filePath = p.join(downloadDir.path, fileName);
      final file = File(filePath);
      if (await file.exists()) return filePath;
    } catch (e) {
      print('[BookFileService] Error getting downloaded path: $e');
    }
    return null;
  }

  /// List all downloaded files metadata
  Future<List<Map<String, dynamic>>> getDownloadedBooks() async {
    if (kIsWeb) {
      return []; // Downloads not supported on web
    }
    final res = <Map<String, dynamic>>[];
    try {
      final downloadDir = await _getDownloadDirectory();
      if (downloadDir == null) return [];
      final files = downloadDir.listSync();
      for (final f in files) {
        if (f is File) {
          final stat = await f.stat();
          res.add({
            'filePath': f.path,
            'fileName': p.basename(f.path),
            'size': stat.size,
            'modified': stat.modified,
          });
        }
      }
    } catch (e) {
      print('[BookFileService] Error listing downloads: $e');
    }
    return res;
  }

  /// Delete downloaded file
  Future<bool> deleteDownloadedBook(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
    } catch (e) {
      print('[BookFileService] Error deleting file: $e');
    }
    return false;
  }

  /// Open with external app
  Future<void> openWithExternalApp(String filePath) async {
    try {
      final uri = Uri.file(filePath);
      if (!await canLaunchUrl(uri)) {
        print('[BookFileService] Cannot launch external for: $filePath');
        return;
      }
      await launchUrl(uri);
    } catch (e) {
      print('[BookFileService] Error launching external: $e');
    }
  }

  /// Get the server URL for a book file (for online reading without download)
  /// Returns the full URL to access the file directly from the server
  /// Note: The URL will need authentication headers when accessed
  String getBookFileUrl(FichierLivre fichier) {
    final fileId = fichier.id;
    if (fileId == null) {
      print('[BookFileService] File ID is null');
      return '';
    }
    
    // Build the download URL (this is the endpoint to access the file)
    // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
    final downloadUrl = '/api/livres/fichiers/$fileId/download';
    final baseUrl = _dio.options.baseUrl ?? '';
    
    // Combine baseUrl and downloadUrl
    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final cleanPath = downloadUrl.startsWith('/') ? downloadUrl : '/$downloadUrl';
    
    final fullUrl = '$cleanBaseUrl$cleanPath';
    print('[BookFileService] Generated file URL: $fullUrl');
    return fullUrl;
  }

  /// Get the authenticated URL for a book file
  /// This adds authentication token to the URL if needed
  /// For SfPdfViewer.network, we need to pass headers, so we'll use a different approach
  String getAuthenticatedBookFileUrl(FichierLivre fichier) {
    // For now, return the basic URL
    // The authentication will be handled by Dio when making the request
    // SfPdfViewer.network doesn't support custom headers directly,
    // so we might need to use a different approach or modify the viewer
    return getBookFileUrl(fichier);
  }

  /// Open book file directly from server (online reading without download)
  /// Downloads temporarily in memory for display, but doesn't save to disk
  Future<void> openBookFileOnline(
    FichierLivre fichier,
    BuildContext context, {
    int? livreId,
    int? eleveId,
    int? totalPages,
  }) async {
    try {
      final fileId = fichier.id;
      if (fileId == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fichier invalide')),
          );
        }
        return;
      }

      switch (fichier.type) {
        case FichierLivreTypeEnum.PDF:
          // For PDF, we need to download temporarily in memory to display it
          // because SfPdfViewer.network doesn't support authentication headers
          // But we don't save it to disk - it's only in memory for display
          if (context.mounted) {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );

            try {
              // Download the file temporarily in memory (not to disk)
              // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
              final downloadUrl = '/api/livres/fichiers/$fileId/download';
              print('[BookFileService] Downloading file from: ${_dio.options.baseUrl}$downloadUrl');
              final response = await _dio.get<List<int>>(
                downloadUrl,
                options: Options(
                  responseType: ResponseType.bytes,
                  followRedirects: true,
                  validateStatus: (status) => status != null && status < 500,
                ),
              );
              print('[BookFileService] Download response status: ${response.statusCode}');

              if (context.mounted) {
                Navigator.pop(context); // Close loading dialog
              }

              if (response.statusCode == 200 && response.data != null) {
                // Create a temporary file in memory or use memory viewer
                // For now, we'll save to a temp location that gets cleaned up
                // But the user explicitly requested not to save to phone
                // So we'll use a different approach: stream from memory
                
                // Alternative: Use a temporary file that's deleted after viewing
                // Or better: Use SfPdfViewer.memory with the bytes
                final bytes = Uint8List.fromList(response.data!);
                print('[BookFileService] File downloaded successfully, size: ${bytes.length} bytes');
                
                // Validate that we have actual PDF data
                if (bytes.length < 4) {
                  print('[BookFileService] File too small, might be invalid');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Le fichier téléchargé est invalide ou corrompu')),
                    );
                  }
                  return;
                }
                
                // Check PDF header (should start with %PDF)
                final pdfHeader = String.fromCharCodes(bytes.take(4));
                print('[BookFileService] File header: $pdfHeader');
                if (!pdfHeader.startsWith('%PDF')) {
                  print('[BookFileService] Warning: File does not appear to be a valid PDF');
                  // Check if it might be HTML or JSON error response
                  final firstBytes = String.fromCharCodes(bytes.take(100));
                  if (firstBytes.contains('<html') || firstBytes.contains('{')) {
                    print('[BookFileService] File appears to be HTML or JSON, not PDF');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Le serveur a retourné une réponse invalide au lieu du PDF')),
                      );
                    }
                    return;
                  }
                  // Still try to open it, might be a valid PDF with different header
                }
                
                // On web, SfPdfViewer.memory might have issues, so we'll try a different approach
                if (kIsWeb) {
                  // For web, create a blob URL and open in new tab or use iframe
                  // For now, we'll still try SfPdfViewer.memory but with better error handling
                  print('[BookFileService] Opening PDF on web platform');
                }
                
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PdfViewerScreen(
                        filePath: '', // Not used when using memory
                        title: fichier.nom ?? 'PDF',
                        pdfBytes: bytes, // Pass bytes directly
                        livreId: livreId,
                        eleveId: eleveId,
                        totalPages: totalPages,
                      ),
                    ),
                  );
                }
              } else {
                print('[BookFileService] Failed to download file. Status: ${response.statusCode}');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur lors du chargement du fichier (${response.statusCode})')),
                  );
                }
              }
            } catch (e) {
              if (context.mounted) {
                Navigator.pop(context); // Close loading dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur: $e')),
                );
              }
            }
          }
          break;

        case FichierLivreTypeEnum.EPUB:
          // TODO: integrate EPUB viewer package that supports URLs
          // For EPUB, we'll need to download temporarily in memory similar to PDF
          print('[BookFileService] EPUB online reading requested (implement epub viewer with memory support)');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lecture EPUB en ligne non encore implémentée')),
            );
          }
          break;

        case FichierLivreTypeEnum.IMAGE:
        case FichierLivreTypeEnum.VIDEO:
        case FichierLivreTypeEnum.AUDIO:
          // For images, videos, and audio, we can try to open directly
          // But we need authentication, so we'll download temporarily in memory
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lecture de ce type de fichier en ligne non encore implémentée')),
            );
          }
          break;

        default:
          print('[BookFileService] Unsupported type for online reading: ${fichier.type}');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Type de fichier non supporté pour la lecture en ligne')),
            );
          }
      }
    } catch (e, st) {
      print('[BookFileService] Error opening file online: $e');
      print(st);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'ouverture du fichier')),
        );
      }
    }
  }
}
