import 'package:flutter/material.dart';

/// Widget pour afficher un badge de notification avec compteur
class NotificationBadge extends StatelessWidget {
  final Widget child;
  final int count;
  final Color badgeColor;
  final Color textColor;
  final double badgeSize;
  final double fontSize;
  final EdgeInsets padding;

  const NotificationBadge({
    super.key,
    required this.child,
    required this.count,
    this.badgeColor = Colors.red,
    this.textColor = Colors.white,
    this.badgeSize = 18.0,
    this.fontSize = 12.0,
    this.padding = const EdgeInsets.all(2.0),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            right: -padding.right,
            top: -padding.top,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
              constraints: BoxConstraints(
                minWidth: badgeSize,
                minHeight: badgeSize,
              ),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

