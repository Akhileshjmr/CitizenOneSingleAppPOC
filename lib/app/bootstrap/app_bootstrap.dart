import 'package:flutter/widgets.dart';
import '../../app.dart';
import '../../app_router.dart';
import '../../core/core.dart';
import '../../generated/enabled_modules.dart';
import '../env/app_env.dart' as env_flavor;

class AppBootstrap {
  static Future<void> bootstrap(env_flavor.Flavor flavor) async {
    WidgetsFlutterBinding.ensureInitialized();

    final env = AppEnv.dev();
    final storage = InMemoryLocalStorage();
    final apiClient = ApiClient(env: env);
    final authApi = AuthApi(apiClient);
    final authRepository = AuthRepositoryImpl(authApi);

    for (final module in enabledModules) {
      await module.initialize(apiClient: apiClient);
    }

    final authCubit = AuthCubit(
      authRepository,
      modules: enabledModules,
      storage: storage,
    );

    final router = createAppRouter(enabledModules, authCubit: authCubit);

    runApp(CitizenOneApp(router: router, authCubit: authCubit));
  }
}
