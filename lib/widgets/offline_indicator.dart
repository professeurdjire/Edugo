import 'package:flutter/material.dart';
import 'package:edugo/services/connectivity_service.dart';

/// Widget pour afficher un indicateur de mode hors ligne
class OfflineIndicator extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;

  const OfflineIndicator({
    super.key,
    required this.child,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  @override
  State<OfflineIndicator> createState() => _OfflineIndicatorState();
}

class _OfflineIndicatorState extends State<OfflineIndicator> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivityService.connectionStream.listen((isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final isConnected = await _connectivityService.isConnected();
    if (mounted) {
      setState(() {
        _isConnected = isConnected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr, // Ajout de textDirection pour éviter l'erreur Directionality
      children: [
        widget.child,
        if (!_isConnected)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: widget.backgroundColor ?? Colors.orange,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Mode hors ligne activé',
                    style: TextStyle(
                      color: widget.textColor ?? Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

