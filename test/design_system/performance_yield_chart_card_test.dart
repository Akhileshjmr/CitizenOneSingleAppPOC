import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:citizenone_app/design_system/design_system.dart';

void main() {
  group('PerformanceYieldChartCard Tests', () {
    testWidgets('renders all visual elements and texts faithfully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: PerformanceYieldChartCard(),
            ),
          ),
        ),
      );

      // Verify Header Elements
      expect(find.text('30-Day Performance'), findsOneWidget);
      expect(find.text('Last 30 days'), findsOneWidget);

      // Verify Metrics Elements
      expect(find.text('Current Daily Yield'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
      expect(find.text('5.5%'), findsOneWidget);
      expect(find.text('EGP · Sample data'), findsOneWidget);

      // Verify Change Badge Elements
      expect(find.text('+0.2%'), findsOneWidget);
      expect(find.text('vs previous day'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);

      // Verify Footer Text
      expect(find.text('30-day performance · Updated daily'), findsOneWidget);

      // Verify CustomPaint is present for the chart
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('tapping info icon displays info explanation dialog',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PerformanceYieldChartCard(),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.info_outline_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Current Daily Yield'), findsNWidgets(2)); // Title & Header
      expect(find.text('Got it'), findsOneWidget);

      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();
    });

    testWidgets('supports custom data points and interactive callback',
        (WidgetTester tester) async {
      YieldChartDataPoint? selected;

      final customPoints = [
        YieldChartDataPoint(
          date: DateTime(2024, 10, 1),
          value: 4.0,
          customFormattedValue: 'EGP 4.0000',
        ),
        YieldChartDataPoint(
          date: DateTime(2024, 10, 2),
          value: 4.5,
          customFormattedValue: 'EGP 4.5000',
        ),
        YieldChartDataPoint(
          date: DateTime(2024, 10, 3),
          value: 5.0,
          customFormattedValue: 'EGP 5.0000',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PerformanceYieldChartCard(
              title: 'Custom Performance',
              dataPoints: customPoints,
              onPointSelected: (pt) {
                selected = pt;
              },
            ),
          ),
        ),
      );

      // Trigger drag gesture on the chart
      final customPaintFinder = find.byType(CustomPaint).first;
      await tester.drag(customPaintFinder, const Offset(-50, 0));
      await tester.pumpAndSettle();

      // Verify callback or sample30Days length and values
      expect(selected, isNotNull);
      final sample = YieldChartDataPoint.sample30Days;
      expect(sample.length, equals(30));
      expect(sample[21].displayDate, equals('21 Oct 2024'));
      expect(sample[21].displayValue, equals('EGP 5.1152'));
      expect(sample.last.value, equals(5.50));
    });
  });
}
