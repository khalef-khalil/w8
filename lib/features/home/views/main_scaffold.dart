import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'overview_screen.dart';
import '../../history/views/history_page.dart';
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
    _TabData(icon: Icons.dashboard_rounded, labelKey: 'navOverview'),
    _TabData(icon: Icons.history_rounded, labelKey: 'navHistory'),
    _TabData(icon: Icons.settings_rounded, labelKey: 'navSettings'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = [
      l10n.navOverview,
      l10n.navHistory,
      l10n.settingsTitle,
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          OverviewScreen(),
          HistoryPage(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) {
          // Haptic feedback for tab changes
          HapticFeedback.selectionClick();
          setState(() => _currentIndex = i);
        },
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
            Semantics(
              label: l10n.addWeight,
              button: true,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => context.go('/add-weight'),
                tooltip: l10n.addWeight,
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: _currentIndex == 1
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
        return l10n.overviewTitle;
      case 1:
        return l10n.historyTitle;
      case 2:
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
