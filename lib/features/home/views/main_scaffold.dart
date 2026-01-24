import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'home_screen.dart';
import '../../progress/views/progress_screen.dart';
import '../../insights/views/insights_screen.dart';
import '../../settings/views/settings_screen.dart';
import '../../../core/extensions/l10n_context.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  static const _tabs = [
    _TabData(icon: Icons.home_rounded, labelKey: 'navHome'),
    _TabData(icon: Icons.show_chart_rounded, labelKey: 'navProgress'),
    _TabData(icon: Icons.insights_rounded, labelKey: 'navInsights'),
    _TabData(icon: Icons.settings_rounded, labelKey: 'navSettings'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = [
      l10n.navHome,
      l10n.navProgress,
      l10n.navInsights,
      l10n.settingsTitle,
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          ProgressScreen(),
          InsightsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          for (var i = 0; i < _tabs.length; i++)
            NavigationDestination(
              icon: Icon(_tabs[i].icon),
              label: labels[i],
            ),
        ],
      ),
      appBar: AppBar(
        title: Text(_appBarTitle(context)),
        actions: [
          if (_currentIndex == 0) ...[
            IconButton(
              icon: const Icon(Icons.history_rounded),
              onPressed: () => context.go('/history'),
              tooltip: l10n.historyTitle,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.go('/add-weight'),
            ),
          ],
        ],
      ),
      floatingActionButton: _currentIndex != 0 && _currentIndex != 3
          ? FloatingActionButton(
              onPressed: () => context.go('/add-weight'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  String _appBarTitle(BuildContext context) {
    final l10n = context.l10n;
    switch (_currentIndex) {
      case 0:
        return l10n.weightTracking;
      case 1:
        return l10n.progressTitle;
      case 2:
        return l10n.insightsTitle;
      case 3:
        return l10n.settingsTitle;
      default:
        return l10n.appTitle;
    }
  }
}

class _TabData {
  const _TabData({required this.icon, required this.labelKey});
  final IconData icon;
  final String labelKey;
}
