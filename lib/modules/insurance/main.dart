// =============================================================================
// main.dart  —  Entry point
// -----------------------------------------------------------------------------
// Initializes the DI container, then hands off to App (MaterialApp).
// Keep this file tiny on purpose — every concern has its own home.
// =============================================================================

import 'package:flutter/material.dart';

import 'app.dart';
//import 'injection_container.dart' as di;
import 'core/di/di_setup.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await di.initDependencies();
  await di.setupDI(); 
  runApp(const App());
}
