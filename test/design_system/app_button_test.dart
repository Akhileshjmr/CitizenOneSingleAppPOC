import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:citizenone_app/design_system/design_system.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('AppButton Variant & Spec Tests', () {
    testWidgets('AppButton primary renders correctly with label', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton(
            text: 'Primary Button',
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Primary Button'), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
    });

    testWidgets('AppButton outline renders with label', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton(
            text: 'Outlined Button',
            variant: AppButtonVariant.outline,
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Outlined Button'), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
    });

    testWidgets('AppButton secondary renders with label', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton(
            text: 'Secondary Button',
            variant: AppButtonVariant.secondary,
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Secondary Button'), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
    });

    testWidgets('AppButton ghost renders with label', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton(
            text: 'Ghost Button',
            variant: AppButtonVariant.ghost,
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Ghost Button'), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
    });

    testWidgets('AppButton renders icon correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton(
            text: 'With Icon',
            icon: Icons.add,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('With Icon'), findsOneWidget);
    });

    testWidgets('AppButton shows loader when isLoading is true', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton(
            text: 'Loading Button',
            isLoading: true,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('AppButton responds to tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton(
            text: 'Tap Me',
            onPressed: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });
}
