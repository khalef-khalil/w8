import 'package:flutter/material.dart';
import '../models/education_content.dart';
import '../extensions/l10n_context.dart';

/// Overlay widget for displaying educational content
class EducationOverlay extends StatelessWidget {
  final EducationContent content;
  final VoidCallback onDismiss;

  const EducationOverlay({
    super.key,
    required this.content,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        if (content.icon != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getIconData(content.icon!),
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        if (content.icon != null) const SizedBox(width: 16),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              content.title(context.l10n),
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: onDismiss,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Content
                    Text(
                      content.content(context.l10n),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    // Dismiss button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onDismiss,
                        child: Text(context.l10n.gotIt),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'water_drop':
        return Icons.water_drop_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'check_circle':
        return Icons.check_circle_rounded;
      case 'pause_circle':
        return Icons.pause_circle_rounded;
      case 'insights':
        return Icons.insights_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      default:
        return Icons.info_rounded;
    }
  }
}

/// Button that shows educational content when tapped
class EducationButton extends StatelessWidget {
  final String contentId;
  final Widget child;
  final String? tooltip;

  const EducationButton({
    super.key,
    required this.contentId,
    required this.child,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? context.l10n.learnMore,
      child: InkWell(
        onTap: () => _showEducation(context),
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
    );
  }

  void _showEducation(BuildContext context) {
    final content = EducationContentLibrary.getById(contentId, context.l10n);
    if (content == null) return;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => EducationOverlay(
        content: content,
        onDismiss: () => Navigator.of(ctx).pop(),
      ),
    );
  }
}
