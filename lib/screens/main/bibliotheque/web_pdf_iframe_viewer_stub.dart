// Stub for non-web platforms
// This file is imported on non-web platforms

import 'package:flutter/material.dart';
import 'dart:typed_data';

/// Stub widget for non-web platforms
class WebPdfIframeViewer extends StatelessWidget {
  final Uint8List bytes;

  const WebPdfIframeViewer({super.key, required this.bytes});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Web PDF viewer is only available on web platform'),
    );
  }
}

