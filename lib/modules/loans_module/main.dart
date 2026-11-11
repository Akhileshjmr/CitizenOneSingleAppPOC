import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app/data/config/initialize_app.dart';
import 'app/data/local/store/user_provider.dart';
import 'app/loans_module.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  /// Dev env
  await initializeCoreApp(
    developmentApiBaseUrl: 'http://192.168.3.69:9098/credeze/',
    productionApiBaseUrl: 'http://192.168.3.69:9098/credeze/',
    developmentImageUrl: 'http://192.168.1.81:2048/profitto',
    productionImageUrl: 'http://192.168.1.81:2048/profitto',
    livezyWebUrl: '',
  );

  /// SIT env
  /*  await initializeCoreApp(
    developmentApiBaseUrl: 'http://192.168.1.5:9099/credeze/',
    productionApiBaseUrl: 'http://192.168.1.5:9099/credeze/',
    developmentImageUrl: 'http://192.168.1.5:2048/profitto',
    productionImageUrl: 'http://192.168.1.5:2048/profitto',
    livezyWebUrl: '',
  );*/

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "Application",
          debugShowCheckedModeBanner: false,
          initialRoute: UserProvider.initialRoute,
          getPages: AppPages.routes,
          navigatorObservers: LoansModule.navigatorObservers,
          builder: (context, widget) {
            return widget!;
          },
        );
      },
    ),
  );
}
