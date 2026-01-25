import 'package:go_router/go_router.dart';
import '../../models/weight_entry.dart';
import '../../features/home/views/main_scaffold.dart';
import '../../features/add_weight/views/add_weight_screen.dart';
import '../../features/history/views/history_page.dart';
import '../../features/onboarding/views/welcome_screen.dart';
import '../../features/onboarding/views/goal_configuration_screen.dart';
import '../../features/onboarding/views/preferences_screen.dart';
import '../../features/onboarding/views/first_entry_screen.dart';
import '../../features/onboarding/views/language_selection_screen.dart';
import '../../features/settings/views/edit_goal_screen.dart';
import '../../core/services/goal_storage_service.dart';

/// Configuration du routeur de l'application
final appRouter = GoRouter(
  redirect: (context, state) {
    final isOnboardingCompleted = GoalStorageService.isOnboardingCompleted();
    final currentPath = state.uri.path;

    // Si l'onboarding n'est pas terminé et qu'on n'est pas dans le flow d'onboarding
    if (!isOnboardingCompleted && 
        !currentPath.startsWith('/onboarding') &&
        currentPath != '/onboarding') {
      return '/onboarding';
    }

    // Si l'onboarding est terminé et qu'on est sur la page de bienvenue
    if (isOnboardingCompleted && currentPath == '/onboarding') {
      return '/';
    }

    return null;
  },
  routes: [
    // Onboarding flow
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/onboarding/language',
      name: 'onboarding-language',
      builder: (context, state) => const LanguageSelectionScreen(),
    ),
    GoRoute(
      path: '/onboarding/goal',
      name: 'onboarding-goal',
      builder: (context, state) => const GoalConfigurationScreen(),
    ),
    GoRoute(
      path: '/onboarding/preferences',
      name: 'onboarding-preferences',
      builder: (context, state) => const PreferencesScreen(),
    ),
    GoRoute(
      path: '/onboarding/first-entry',
      name: 'onboarding-first-entry',
      builder: (context, state) => const FirstEntryScreen(),
    ),
    // App routes
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const MainScaffold(),
    ),
    GoRoute(
      path: '/add-weight',
      name: 'add-weight',
      builder: (context, state) => AddWeightScreen(
        entryToEdit: state.extra as WeightEntry?,
      ),
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      builder: (context, state) => const HistoryPage(),
    ),
    GoRoute(
      path: '/settings/edit-goal',
      name: 'edit-goal',
      builder: (context, state) => const EditGoalScreen(),
    ),
  ],
);
