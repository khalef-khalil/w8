import '../../l10n/app_localizations.dart';

/// Educational content item
class EducationContent {
  final String id;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) content;
  final String? icon;
  final EducationCategory category;

  const EducationContent({
    required this.id,
    required this.title,
    required this.content,
    this.icon,
    required this.category,
  });
}

/// Categories of educational content
enum EducationCategory {
  tracking,
  understanding,
  bestPractices,
  motivation,
}

/// Predefined educational content
class EducationContentLibrary {
  static List<EducationContent> getAllContent(AppLocalizations l10n) {
    return [
      // Tracking category
      EducationContent(
        id: 'why_fluctuates',
        title: (_) => l10n.educationWhyFluctuatesTitle,
        content: (_) => l10n.educationWhyFluctuatesContent,
        icon: 'water_drop',
        category: EducationCategory.tracking,
      ),
      EducationContent(
        id: 'weekly_medians',
        title: (_) => l10n.educationWeeklyMediansTitle,
        content: (_) => l10n.educationWeeklyMediansContent,
        icon: 'trending_up',
        category: EducationCategory.tracking,
      ),
      EducationContent(
        id: 'best_tracking_practices',
        title: (_) => l10n.educationBestPracticesTitle,
        content: (_) => l10n.educationBestPracticesContent,
        icon: 'check_circle',
        category: EducationCategory.bestPractices,
      ),
      EducationContent(
        id: 'understanding_plateaus',
        title: (_) => l10n.educationPlateausTitle,
        content: (_) => l10n.educationPlateausContent,
        icon: 'pause_circle',
        category: EducationCategory.understanding,
      ),
      EducationContent(
        id: 'context_tracking',
        title: (_) => l10n.educationContextTrackingTitle,
        content: (_) => l10n.educationContextTrackingContent,
        icon: 'insights',
        category: EducationCategory.understanding,
      ),
      EducationContent(
        id: 'staying_motivated',
        title: (_) => l10n.educationStayingMotivatedTitle,
        content: (_) => l10n.educationStayingMotivatedContent,
        icon: 'favorite',
        category: EducationCategory.motivation,
      ),
    ];
  }

  static EducationContent? getById(String id, AppLocalizations l10n) {
    try {
      return getAllContent(l10n).firstWhere(
        (content) => content.id == id,
      );
    } catch (e) {
      return null;
    }
  }

  static List<EducationContent> getByCategory(EducationCategory category, AppLocalizations l10n) {
    return getAllContent(l10n).where((c) => c.category == category).toList();
  }
}
