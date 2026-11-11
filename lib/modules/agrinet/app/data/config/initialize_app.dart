import 'package:get_storage/get_storage.dart';
import '../remote/api_service/init_api_service.dart';

/*late String kDevelopmentApiBaseUrl;
late String kProductionApiBaseUrl;*/

/// Initialize all core functionalities
Future<void> initializeCoreApp({
  required String? developmentApiBaseUrl,
  required String? productionApiBaseUrl,
  required String? developmentImageUrl,
  required String? productionImageUrl,
  // bool firebaseApp = true,
  // bool setupLocalNotifications = false,
  // bool encryption = false,
}) async {
  //Activate logger
  // initLogger();

  //Firebase products initializations
  // if (firebaseApp) {
  //   await Firebase.initializeApp();
  //   notificationActions(
  //     action: notificationAction,
  //     localNotification: setupLocalNotifications,
  //     localNotificationAction: localNotificationAction,
  //   );
  // }
  /*if (developmentApiBaseUrl != null) {
    kDevelopmentApiBaseUrl = developmentApiBaseUrl;
  }
  if (productionApiBaseUrl != null) {
    kProductionApiBaseUrl = productionApiBaseUrl;
  }*/
  final GetStorage box = GetStorage();
  await box.writeIfNull('currentIp', 'http://192.168.1.81:2048/profitto/agrinet/');
  await box.writeIfNull('currentImgIp', 'http://192.168.1.81:2048/profitto/agrinet/');

  // UserProvider.loadUser();
  // LocaleProvider.loadCurrentLocale();
  // await ThemeProvider.getThemeModeFromStore();

  if (productionApiBaseUrl != null && developmentApiBaseUrl != null ) {
    APIService.initializeAPIService(
      // encryptData: encryption,
      devBaseUrl: developmentApiBaseUrl,
      prodBaseUrl: productionApiBaseUrl,
      devImageBaseUrl: developmentImageUrl ?? '',
      prodImageBaseUrl: productionImageUrl ?? '',
    );
  }
}
