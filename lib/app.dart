import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root widget wiring theme and navigation.
///
/// Separating [EthiopianCalendarApp] from [main] keeps bootstrap logic
/// minimal and makes widget tests easier to set up.
class EthiopianCalendarApp extends ConsumerWidget {
  const EthiopianCalendarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Ethiopian Calendar & Date Converter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
