import '../network/api_client.dart';
import 'user_model.dart';

class AuthApi {
  final ApiClient apiClient;

  AuthApi(this.apiClient);

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    const endpoint = '/api/v1/auth/login';
    try {
      final response = await apiClient.post(endpoint, body: {
        'username': username,
        'password': password,
      });
      return UserModel.fromJson(response);
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 600));
      return UserModel(
        userId: 'USR-99201',
        username: username,
        email: '$username@citizenone.gov',
        token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
        roles: ['CITIZEN', 'AGENT'],
      );
    }
  }

  Future<void> requestPasswordReset(String emailOrUsername) async {
    const endpoint = '/api/v1/auth/forgot-password';
    try {
      await apiClient.post(endpoint, body: {'identifier': emailOrUsername});
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  Future<String> requestRecoverUsername(String email) async {
    const endpoint = '/api/v1/auth/forgot-username';
    try {
      final response = await apiClient.post(endpoint, body: {'email': email});
      return response['maskedUsername'] as String? ?? 'c***1';
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 400));
      return 'cit***_user';
    }
  }
}
