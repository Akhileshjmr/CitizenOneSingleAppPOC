import 'package:flutter/material.dart';
import 'package:citizenone_app/core/core.dart';
import 'app.dart';
import 'app_router.dart';
import 'generated/enabled_modules.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient();
  final authApi = AuthApi(apiClient);
  final authRepository = AuthRepositoryImpl(authApi);
  final authCubit = AuthCubit(authRepository);

  final router = createAppRouter(enabledModules);

  runApp(
    CitizenOneApp(
      router: router,
      authCubit: authCubit,
    ),
  );
}
