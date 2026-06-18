import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/age/screens/age_calculator_screen.dart';
import '../../features/calendar/screens/calendar_screen.dart';
import '../../features/converter/screens/converter_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import 'app_routes.dart';
import 'main_shell.dart';

/// Global navigator key for imperative navigation when needed.
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// [go_router] configuration with a bottom-navigation [ShellRoute].
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.calendar,
            name: 'calendar',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CalendarScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.converter,
            name: 'converter',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ConverterScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.age,
            name: 'age',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AgeCalculatorScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});
