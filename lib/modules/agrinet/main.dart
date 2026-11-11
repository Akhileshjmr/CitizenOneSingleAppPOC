import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/data/config/initialize_app.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeCoreApp(
    developmentApiBaseUrl: 'http://192.168.1.81:2048/profitto/',
    productionApiBaseUrl: 'http://192.168.1.81:2048/profitto/',
    developmentImageUrl: 'http://192.168.1.81:2048/profitto/',
    productionImageUrl: 'http://192.168.1.81:2048/profitto/',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Application',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
