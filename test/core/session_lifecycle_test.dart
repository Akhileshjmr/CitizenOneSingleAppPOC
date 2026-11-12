import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';

class LifecycleTrackingModule extends AppModule {
  final String moduleId;
  bool isInitialized = false;
  bool isDisposed = false;
  bool isSessionActive = false;

  LifecycleTrackingModule(this.moduleId);

  @override
  String get id => moduleId;

  @override
  String get title => 'Lifecycle Module $moduleId';

  @override
  String get initialRoute => '/$moduleId';

  @override
  List<RouteBase> get routes => [];

  @override
  List<BlocProvider> get providers => [];

  @override
  ThemeData? get theme => null;

  @override
  FutureOr<void> initialize({ApiClient? apiClient}) {
    super.initialize(apiClient: apiClient);
    isInitialized = true;
  }

  @override
  FutureOr<void> dispose() {
    isDisposed = true;
  }

  @override
  void onSessionStateChanged(bool isAuthenticated, UserModel? user) {
    isSessionActive = isAuthenticated;
  }
}

class FakeAuthRepository implements AuthRepository {
  @override
  Future<UserModel> login({
    required String username,
    required String password,
    String? role,
  }) async {
    return UserModel(
      userId: 'U-TEST',
      username: username,
      email: '$username@test.com',
      token: 'test-token',
      roles: [role ?? 'CITIZEN'],
    );
  }

  @override
  Future<void> requestPasswordReset(String emailOrUsername) async {}

  @override
  Future<String> requestRecoverUsername(String email) async => 'u***';

  @override
  Future<ScopedToken> getScopedToken(String targetModule, {String? userToken}) async {
    return ScopedToken(
      token: 'token-$targetModule',
      targetModule: targetModule,
      issuedAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(minutes: 15)),
    );
  }
}

void main() {
  group('Symmetrical Session Lifecycle Governance Tests', () {
    test('Login propagates session activation to all registered modules', () async {
      final module1 = LifecycleTrackingModule('mod1');
      final module2 = LifecycleTrackingModule('mod2');
      final storage = InMemoryLocalStorage();
      final repository = FakeAuthRepository();

      final authCubit = AuthCubit(
        repository,
        modules: [module1, module2],
        storage: storage,
      );

      await authCubit.login(username: 'test_user', password: 'secret_password');

      expect(authCubit.state, isA<AuthAuthenticated>());
      expect(module1.isSessionActive, isTrue);
      expect(module2.isSessionActive, isTrue);
      expect(storage.getString('auth_token'), equals('test-token'));
    });

    test('Logout clears storage, resets module session, and calls dispose()', () async {
      final module1 = LifecycleTrackingModule('mod1');
      final module2 = LifecycleTrackingModule('mod2');
      final storage = InMemoryLocalStorage();
      final repository = FakeAuthRepository();

      final authCubit = AuthCubit(
        repository,
        modules: [module1, module2],
        storage: storage,
      );

      // First login
      await authCubit.login(username: 'test_user', password: 'secret_password');
      expect(storage.getString('auth_token'), isNotNull);

      // Now logout
      await authCubit.logout();

      expect(authCubit.state, isA<AuthUnauthenticated>());
      expect(storage.getString('auth_token'), isNull);
      expect(module1.isSessionActive, isFalse);
      expect(module2.isSessionActive, isFalse);
      expect(module1.isDisposed, isTrue);
      expect(module2.isDisposed, isTrue);
    });
  });
}
