import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ethiopian_calendar/app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Home screen renders app title and quick actions', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: EthiopianCalendarApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ethiopian Calendar'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
  });

  testWidgets('Bottom nav navigates to calendar screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: EthiopianCalendarApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(NavigationDestination, 'Calendar'));
    await tester.pumpAndSettle();

    expect(find.text('Swipe left or right to change month'), findsOneWidget);
  });

  testWidgets('Bottom nav navigates to age calculator screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: EthiopianCalendarApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(NavigationDestination, 'Age'));
    await tester.pumpAndSettle();

    expect(find.text('Age Calculator'), findsOneWidget);
  });

  testWidgets('Bottom nav navigates to settings screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: EthiopianCalendarApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(NavigationDestination, 'Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Support'), findsOneWidget);
    expect(find.text('Rate this app'), findsOneWidget);
    expect(find.text('Share this app'), findsOneWidget);
  });
}
