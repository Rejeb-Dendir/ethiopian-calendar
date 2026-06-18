import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../l10n/l10n.dart';
import 'app_routes.dart';

/// Root shell with bottom navigation for the main tabs.
class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static int _indexForLocation(String location) {
    if (location.startsWith(AppRoutes.calendar)) return 1;
    if (location.startsWith(AppRoutes.converter)) return 2;
    if (location.startsWith(AppRoutes.age)) return 3;
    if (location.startsWith(AppRoutes.settings)) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _indexForLocation(location);
    final l10n = ref.watch(appLocalizationsProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: AppColors.background,
        indicatorColor: AppColors.primaryGreen.withValues(alpha: 0.15),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
            case 1:
              context.go(AppRoutes.calendar);
            case 2:
              context.go(AppRoutes.converter);
            case 3:
              context.go(AppRoutes.age);
            case 4:
              context.go(AppRoutes.settings);
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month_rounded),
            label: l10n.navCalendar,
          ),
          NavigationDestination(
            icon: const Icon(Icons.swap_horiz_outlined),
            selectedIcon: const Icon(Icons.swap_horiz_rounded),
            label: l10n.navConverter,
          ),
          NavigationDestination(
            icon: const Icon(Icons.cake_outlined),
            selectedIcon: const Icon(Icons.cake_rounded),
            label: l10n.navAge,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}

/// App bar used on secondary tabs.
class TabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TabAppBar({
    super.key,
    required this.title,
    this.actions = const [],
  });

  final String title;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
      actions: actions,
    );
  }
}
