/// Educational content item
class EducationContent {
  final String id;
  final String title;
  final String content;
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
  static List<EducationContent> getAllContent() {
    return [
      // Tracking category
      const EducationContent(
        id: 'why_fluctuates',
        title: 'Why Weight Fluctuates Daily',
        content: 'Your weight naturally fluctuates throughout the day and week. '
            'This is completely normal! Factors include:\n\n'
            '• Water retention (can vary by 1-2 kg)\n'
            '• Food and digestion\n'
            '• Sleep quality and duration\n'
            '• Hormonal changes\n'
            '• Exercise and muscle recovery\n\n'
            'That\'s why we use weekly medians - they smooth out daily noise and show your true progress.',
        icon: 'water_drop',
        category: EducationCategory.tracking,
      ),
      const EducationContent(
        id: 'weekly_medians',
        title: 'How Weekly Medians Work',
        content: 'Weekly medians help you see your real progress by reducing daily noise.\n\n'
            'Instead of focusing on day-to-day changes, we calculate the median weight for each week. '
            'This gives you a clearer picture of your overall trend.\n\n'
            'For example: If you weigh 70kg, 71kg, 70.5kg, 70.2kg, and 70.8kg in a week, '
            'the median is 70.5kg - a more stable number than any single day.',
        icon: 'trending_up',
        category: EducationCategory.tracking,
      ),
      const EducationContent(
        id: 'best_tracking_practices',
        title: 'Best Practices for Tracking',
        content: 'For the most accurate tracking:\n\n'
            '• Weigh at the same time each day (morning is best)\n'
            '• Use the same scale\n'
            '• Weigh before eating or drinking\n'
            '• Weigh after using the bathroom\n'
            '• Wear similar clothing (or none)\n\n'
            'Consistency is more important than perfection!',
        icon: 'check_circle',
        category: EducationCategory.bestPractices,
      ),
      const EducationContent(
        id: 'understanding_plateaus',
        title: 'Understanding Plateaus',
        content: 'Weight plateaus are completely normal and not a sign of failure!\n\n'
            'Your body may:\n'
            '• Retain water during muscle recovery\n'
            '• Adjust metabolism\n'
            '• Redistribute weight (fat loss, muscle gain)\n\n'
            'If you\'re following your plan, trust the process. '
            'Plateaus often break after a few weeks. Focus on consistency over speed.',
        icon: 'pause_circle',
        category: EducationCategory.understanding,
      ),
      const EducationContent(
        id: 'context_tracking',
        title: 'Why Track Context?',
        content: 'Tracking context (sleep, stress, exercise, meal timing) helps you understand patterns.\n\n'
            'You might discover:\n'
            '• Better sleep = better weight management\n'
            '• High stress affects your progress\n'
            '• Exercise timing matters\n'
            '• Meal timing impacts daily weight\n\n'
            'These insights help you make informed decisions about your journey.',
        icon: 'insights',
        category: EducationCategory.understanding,
      ),
      const EducationContent(
        id: 'staying_motivated',
        title: 'Staying Motivated',
        content: 'Weight tracking is a marathon, not a sprint.\n\n'
            'Remember:\n'
            '• Progress isn\'t always linear\n'
            '• Small daily actions compound over time\n'
            '• Setbacks are part of the journey\n'
            '• Celebrate non-scale victories too\n\n'
            'Focus on building sustainable habits. Every day you track is a win!',
        icon: 'favorite',
        category: EducationCategory.motivation,
      ),
    ];
  }

  static EducationContent? getById(String id) {
    try {
      return getAllContent().firstWhere(
        (content) => content.id == id,
      );
    } catch (e) {
      return null;
    }
  }

  static List<EducationContent> getByCategory(EducationCategory category) {
    return getAllContent().where((c) => c.category == category).toList();
  }
}
