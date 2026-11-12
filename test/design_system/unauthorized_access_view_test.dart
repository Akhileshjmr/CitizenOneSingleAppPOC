import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/design_system/design_system.dart';

void main() {
  group('UnauthorizedAccessView Tests', () {
    testWidgets('Renders restricted message with user info and denied path', (tester) async {
      final user = UserModel(
        userId: 'USR-CITIZEN-01',
        username: 'chileshe_citizen',
        email: 'chileshe@example.com',
        token: 'mock-token',
        roles: const ['CITIZEN'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnauthorizedAccessView(
              user: user,
              deniedPath: '/agency-banking',
            ),
          ),
        ),
      );

      expect(find.text('Access Restricted: Agent Role Required'), findsOneWidget);
      expect(find.byIcon(Icons.gpp_bad_outlined), findsOneWidget);
      expect(find.textContaining('chileshe_citizen'), findsOneWidget);
      expect(find.textContaining('/agency-banking'), findsOneWidget);
      expect(find.text('Go to Citizen Services'), findsOneWidget);
      expect(find.text('Sign In as Authorized Agent'), findsOneWidget);
    });
  });
}

