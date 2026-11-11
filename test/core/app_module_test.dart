import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';

class MockModule extends AppModule {
  bool initialized = false;
  bool disposed = false;
  bool sessionActive = false;

  @override
  String get id => 'mock_module';

  @override
  String get title => 'Mock Module';

  @override
  String get initialRoute => '/mock-module';

  @override
  List<RouteBase> get routes => [];

  @override
  List<BlocProvider> get providers => [];

  @override
  ThemeData? get theme => null;

  @override
  FutureOr<void> initialize({ApiClient? apiClient}) {
    super.initialize(apiClient: apiClient);
    initialized = true;
  }

  @override
  FutureOr<void> dispose() {
    disposed = true;
  }

  @override
  void onSessionStateChanged(bool isAuthenticated, UserModel? user) {
    sessionActive = isAuthenticated;
  }
}

void main() {
  group('AppModule & ModuleEntry Contract Tests', () {
    test('AppModule contract getters should return valid values', () {
      final module = MockModule();
      expect(module.id, equals('mock_module'));
      expect(module.title, equals('Mock Module'));
      expect(module.routes, isEmpty);
      expect(module.providers, isEmpty);
      expect(module.theme, isNull);
    });

    test('ModuleEntry lifecycle hooks execute correctly', () async {
      final module = MockModule();
      expect(module.initialized, isFalse);
      expect(module.disposed, isFalse);
      expect(module.sessionActive, isFalse);

      await module.initialize();
      expect(module.initialized, isTrue);

      module.onSessionStateChanged(
        true,
        const UserModel(
          userId: 'U1',
          username: 'test_user',
          email: 'test@example.com',
          token: 'token123',
          roles: ['CITIZEN'],
        ),
      );
      expect(module.sessionActive, isTrue);

      await module.dispose();
      expect(module.disposed, isTrue);
    });

    test('DateFormatter helper formats values correctly', () {
      final dt = DateTime(2026, 9, 23);
      expect(DateFormatter.formatShortDate(dt), equals('2026-09-23'));
      expect(DateFormatter.formatCurrency(1234.5), equals('\$1234.50'));
    });

    test('SecurityUtils masks sensitive account numbers', () {
      expect(
        SecurityUtils.maskAccountNumber('1234567890'),
        equals('******7890'),
      );
      expect(SecurityUtils.maskAccountNumber('123'), equals('123'));
    });
  });
}
