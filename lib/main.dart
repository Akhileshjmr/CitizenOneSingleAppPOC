import 'package:flutter/material.dart';
import 'package:citizenone_app/core/core.dart';
import 'app.dart';
import 'app_router.dart';
import 'generated/enabled_modules.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize runtime environment with fail-closed security
  final env = AppEnv.dev();
  final storage = InMemoryLocalStorage();
  final apiClient = ApiClient(env: env);
  final authApi = AuthApi(apiClient);
  final authRepository = AuthRepositoryImpl(authApi);

  // Await asynchronous initialization of all enabled business modules
  // and inject host-configured ApiClient instance
  for (final module in enabledModules) {
    await module.initialize(apiClient: apiClient);
  }

  final authCubit = AuthCubit(
    authRepository,
    modules: enabledModules,
    storage: storage,
  );

  // Create router with active modules and reactive auth guard
  final router = createAppRouter(enabledModules, authCubit: authCubit);

  runApp(
    CitizenOneApp(
      router: router,
      authCubit: authCubit,
    ),
  );
}
