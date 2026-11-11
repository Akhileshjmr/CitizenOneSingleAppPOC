import 'package:get_storage/get_storage.dart';

import '../local/store/locale_provider.dart';
import '../local/store/theme_provider.dart';
import '../local/store/user_provider.dart';
import '../remote/api_service/init_api_service.dart';
import '../../session/session_bindings.dart';
import 'logger.dart';

/// Initialize all core functionalities
Future<void> initializeCoreApp({
  required String? developmentApiBaseUrl,
  required String? productionApiBaseUrl,
  required String? developmentImageUrl,
  required String? productionImageUrl,
  required String? livezyWebUrl,
  bool firebaseApp = true,
  bool setupLocalNotifications = false,
  bool encryption = false,
}) async {
  //Activate logger
  initLogger();

  // Initialize GetStorage before using it
  await GetStorage.init();
  
  final GetStorage box = GetStorage();
  await box.writeIfNull('currentIp', 'http://115.240.163.25:9091/credeze/');
  await box.writeIfNull('currentImgIp', 'http://115.240.163.25:4040/profitto/');
  await box.writeIfNull(
    'currentLivezyWebIp',
    'http://115.240.163.25:5070/credeze/',
  );

  UserProvider.loadUser();
  LocaleProvider.loadCurrentLocale();
  await ThemeProvider.loadThemeFromStore();

  if (productionApiBaseUrl != null &&
      developmentApiBaseUrl != null &&
      livezyWebUrl != null) {
    APIService.initializeAPIService(
      encryptData: encryption,
      devBaseUrl: developmentApiBaseUrl,
      prodBaseUrl: productionApiBaseUrl,
      devImageBaseUrl: developmentImageUrl ?? '',
      prodImageBaseUrl: productionImageUrl ?? '',
      livezyWebUrl: livezyWebUrl ?? '',
    );
  }

  SessionBindings.ensureInitialized();
}
