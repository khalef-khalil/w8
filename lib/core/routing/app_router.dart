import 'package:flutter/material.dart';
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

/// Custom page transitions
Page<T> _buildPageWithTransition<T extends Object?>(
  Widget child,
  GoRouterState state,
) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

/// Custom page class for transitions
class CustomTransitionPage<T> extends Page<T> {
  final Widget child;
  final Widget Function(BuildContext, Animation<double>, Animation<double>, Widget) transitionsBuilder;
  final Duration transitionDuration;

  const CustomTransitionPage({
    super.key,
    required this.child,
    required this.transitionsBuilder,
    this.transitionDuration = const Duration(milliseconds: 300),
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: transitionDuration,
      transitionsBuilder: transitionsBuilder,
    );
  }
}

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
      pageBuilder: (context, state) => _buildPageWithTransition(
        const MainScaffold(),
        state,
      ),
    ),
    GoRoute(
      path: '/add-weight',
      name: 'add-weight',
      pageBuilder: (context, state) => _buildPageWithTransition(
        AddWeightScreen(
          entryToEdit: state.extra as WeightEntry?,
        ),
        state,
      ),
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      pageBuilder: (context, state) => _buildPageWithTransition(
        const HistoryPage(),
        state,
      ),
    ),
    GoRoute(
      path: '/settings/edit-goal',
      name: 'edit-goal',
      pageBuilder: (context, state) => _buildPageWithTransition(
        const EditGoalScreen(),
        state,
      ),
    ),
  ],
);
