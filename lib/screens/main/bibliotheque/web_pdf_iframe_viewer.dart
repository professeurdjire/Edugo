// Web-specific PDF viewer using iframe
// This file is only imported on web platform

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

/// Widget for displaying PDF in an iframe on web platform
class WebPdfIframeViewer extends StatefulWidget {
  final Uint8List bytes;

  const WebPdfIframeViewer({super.key, required this.bytes});

  @override
  State<WebPdfIframeViewer> createState() => _WebPdfIframeViewerState();
}

class _WebPdfIframeViewerState extends State<WebPdfIframeViewer> {
  String? _iframeId;
  String? _blobUrl;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _createBlobUrl();
    }
  }

  void _createBlobUrl() {
    try {
      // Create a unique ID for the iframe
      _iframeId = 'pdf-viewer-${DateTime.now().millisecondsSinceEpoch}';
      
      // Create blob from PDF bytes
      final blob = html.Blob([widget.bytes], 'application/pdf');
      _blobUrl = html.Url.createObjectUrlFromBlob(blob);
      
      print('[WebPdfIframeViewer] Created blob URL: $_blobUrl');
      print('[WebPdfIframeViewer] PDF size: ${widget.bytes.length} bytes');
      
      // Register the iframe element
      _registerIframe();
      
      // Trigger rebuild after iframe is registered
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('[WebPdfIframeViewer] Error creating blob URL: $e');
    }
  }

  void _registerIframe() {
    if (!kIsWeb || _iframeId == null || _blobUrl == null) return;
    
    try {
      // Create iframe element
      final iframe = html.IFrameElement()
        ..src = _blobUrl
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%';
      
      // Register the platform view
      ui_web.platformViewRegistry.registerViewFactory(
        _iframeId!,
        (int viewId) => iframe,
      );
    } catch (e) {
      print('[WebPdfIframeViewer] Error registering iframe: $e');
    }
  }

  @override
  void dispose() {
    // Clean up blob URL
    if (kIsWeb && _blobUrl != null) {
      try {
        html.Url.revokeObjectUrl(_blobUrl!);
        print('[WebPdfIframeViewer] Revoked blob URL');
      } catch (e) {
        print('[WebPdfIframeViewer] Error revoking blob URL: $e');
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || _iframeId == null || _blobUrl == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Chargement du PDF...'),
          ],
        ),
      );
    }

    return HtmlElementView(
      viewType: _iframeId!,
    );
  }
}

