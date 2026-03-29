import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/overflow_menu.dart';
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/ui/theme/theme.dart';

void main() {
  testWidgets('Advanced Options UI flow: open menu, verify defaults, toggle, and save', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ProviderScope(
        child: PaintroidTheme(
          lightTheme: LightPaintroidThemeData(),
          darkTheme: DarkPaintroidThemeData(),
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: OverflowMenu(),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(OverflowMenu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Advanced Options'));
    await tester.pumpAndSettle();

    expect(find.text('Advanced Options'), findsWidgets); // Menu item + Dialog title
    expect(find.text('Antialiasing'), findsOneWidget);
    expect(find.text('Smoothing'), findsOneWidget);

    final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
    expect(switches.length, 2);
    expect(switches[0].value, isFalse);
    expect(switches[1].value, isFalse);

    await tester.tap(find.text('Antialiasing'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('Antialiasing'), findsNothing);
  });
}