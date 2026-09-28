import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:citizenone_app/design_system/design_system.dart';

void main() {
  group('AppLayoutGrid & AppLayoutContainer Tests', () {
    test('AppLayoutGrid container widths match specifications', () {
      expect(AppLayoutGrid.getContainerWidth(AppContainerSize.desktop1320), 1320.0);
      expect(AppLayoutGrid.getContainerWidth(AppContainerSize.desktop1140), 1140.0);
      expect(AppLayoutGrid.getContainerWidth(AppContainerSize.tablet960), 960.0);
      expect(AppLayoutGrid.getContainerWidth(AppContainerSize.tablet720), 720.0);
      expect(AppLayoutGrid.getContainerWidth(AppContainerSize.mobile540), 540.0);
      expect(AppLayoutGrid.getContainerWidth(AppContainerSize.fluid), double.infinity);
    });

    testWidgets('AppLayoutContainer.desktop1140 constrains max width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppLayoutContainer.desktop1140(
              child: Text('Desktop Content'),
            ),
          ),
        ),
      );

      expect(find.text('Desktop Content'), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container).last);
      expect(container.constraints?.maxWidth, 1140.0);
    });

    testWidgets('AppResponsiveLayout renders correct layout for device width', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppResponsiveLayout(
              mobile: Text('Mobile View'),
              tablet: Text('Tablet View'),
              desktop: Text('Desktop View'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile View'), findsOneWidget);
      expect(find.text('Desktop View'), findsNothing);

      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
