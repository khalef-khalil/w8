import 'package:flutter/material.dart';
import '../../../core/models/education_content.dart';
import '../../../core/widgets/education_overlay.dart';
import '../../../core/extensions/l10n_context.dart';

/// Page displaying all educational content
class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final allContent = EducationContentLibrary.getAllContent();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.tipsAndEducation),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: allContent.map((content) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                _getEducationIcon(content.icon),
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              title: Text(
                content.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  content.content.split('\n').first,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => EducationOverlay(
                    content: content,
                    onDismiss: () => Navigator.of(ctx).pop(),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getEducationIcon(String? iconName) {
    if (iconName == null) return Icons.info_rounded;
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
