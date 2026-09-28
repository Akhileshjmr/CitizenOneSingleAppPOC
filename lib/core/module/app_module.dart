import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Abstract contract that every business module must implement.
abstract class AppModule {
  /// Unique identifier for the module (e.g. 'agency_banking')
  String get id;

  /// Human-readable module title (e.g. 'Agency Banking')
  String get title;

  /// Main initial route path for entering the module (e.g. '/agency-banking')
  String get initialRoute;

  /// Module routes to be registered with the root GoRouter
  List<RouteBase> get routes;

  /// Module-level BlocProviders registered at module setup
  List<BlocProvider> get providers;
}
