import 'package:flutter_test/flutter_test.dart';
import 'package:citizenone_app/core/core.dart';

void main() {
  group('AuthCubit Tests in Core', () {
    late AuthCubit authCubit;

    setUp(() {
      final apiClient = ApiClient();
      final authApi = AuthApi(apiClient);
      final repo = AuthRepositoryImpl(authApi);
      authCubit = AuthCubit(repo);
    });

    tearDown(() {
      authCubit.close();
    });

    test('Initial state is AuthUnauthenticated', () {
      expect(authCubit.state, isA<AuthUnauthenticated>());
    });

    test('Successful login emits Loading then Authenticated', () async {
      final expectation = expectLater(
        authCubit.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthAuthenticated>(),
        ]),
      );

      await authCubit.login(username: 'john_doe', password: 'password123');
      await expectation;

      final state = authCubit.state as AuthAuthenticated;
      expect(state.user.username, equals('john_doe'));
    });

    test('Empty credentials emit AuthError', () async {
      final expectation = expectLater(
        authCubit.stream,
        emits(isA<AuthError>()),
      );

      await authCubit.login(username: '', password: '');
      await expectation;
    });

    test('Forgot password emits Loading then ForgotPasswordSuccess', () async {
      final expectation = expectLater(
        authCubit.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<ForgotPasswordSuccess>(),
        ]),
      );

      await authCubit.forgotPassword('user@example.com');
      await expectation;
    });
  });
}
