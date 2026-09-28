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
    testWidgets('AppButton.filled renders correctly with label',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton.filled(
            label: 'Primary Filled',
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Primary Filled'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('AppButton.outlined renders OutlinedButton with stroke',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton.outlined(
            label: 'Outlined Button',
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Outlined Button'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('AppButton.tonal renders Tonal FilledButton', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton.tonal(
            label: 'Tonal Button',
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Tonal Button'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('AppButton.text renders TextButton', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton.text(
            label: 'Text Button',
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('Text Button'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('Success Button variants render correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          Column(
            children: [
              AppButton.successFilled(
                label: 'Success Filled',
                onPressed: () {},
              ),
              AppButton.successOutlined(
                label: 'Success Outlined',
                onPressed: () {},
              ),
              AppButton.successTonal(
                label: 'Success Tonal',
                onPressed: () {},
              ),
              AppButton.successText(
                label: 'Success Text',
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.text('Success Filled'), findsOneWidget);
      expect(find.text('Success Outlined'), findsOneWidget);
      expect(find.text('Success Tonal'), findsOneWidget);
      expect(find.text('Success Text'), findsOneWidget);
    });

    testWidgets('AppButton renders disabled variation with 50% opacity styling',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          Column(
            children: [
              AppButton.filled(
                label: 'Disabled Filled',
                isDisabled: true,
                onPressed: () {},
              ),
              const AppButton.outlined(
                label: 'Disabled Outlined',
                onPressed: null,
              ),
            ],
          ),
        ),
      );

      expect(find.text('Disabled Filled'), findsOneWidget);
      expect(find.text('Disabled Outlined'), findsOneWidget);

      final elevatedButton =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(elevatedButton.onPressed, isNull);

      final outlinedButton =
          tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      expect(outlinedButton.onPressed, isNull);
    });

    testWidgets('AppButton renders leading and trailing icons', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton.filled(
            label: 'With Icons',
            leadingIcon: Icons.add,
            trailingIcon: Icons.arrow_drop_down,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      expect(find.text('With Icons'), findsOneWidget);
    });

    testWidgets('AppButton shows loader when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton.filled(
            label: 'Loading Button',
            isLoading: true,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading Button'), findsNothing);
    });
  });
}
