import 'package:flutter/material.dart';

/// Accessible icon button with semantic label
class AccessibleIconButton extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double? size;

  const AccessibleIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.tooltip,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: onPressed != null,
      child: Tooltip(
        message: tooltip ?? semanticLabel,
        child: IconButton(
          icon: Icon(icon, color: color, size: size),
          onPressed: onPressed,
          tooltip: tooltip ?? semanticLabel,
        ),
      ),
    );
  }
}
