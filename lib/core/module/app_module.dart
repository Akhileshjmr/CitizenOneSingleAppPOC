import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../auth/user_model.dart';
import '../network/api_client.dart';

/// Abstract contract that every business module must implement.
/// Represents ModuleEntry in the CitizenOneApp Architectural Specification.
abstract class AppModule {
  /// The host-configured ApiClient instance, populated during [initialize].
  ApiClient? apiClient;

  /// Unique identifier for the module (e.g. 'agency_banking')
  String get id;

  /// Human-readable module title (e.g. 'Agency Banking')
  String get title;

  /// Main initial route path for entering the module (e.g. '/agency-banking')
  String get initialRoute;

  /// Module routes to be registered with the root GoRouter
  List<RouteBase> get routes;

  /// Module-level BlocProviders registered at module setup
  List<BlocProvider> get providers => const [];

  /// Module-level custom theme. When [AppTheme.useCentralTheme] is set to false,
  /// this module theme is used. If null or when [AppTheme.useCentralTheme] is true,
  /// the central Design System theme is used.
  ThemeData? get theme => null;

  /// Lifecycle hook called during host startup or module registration.
  /// Receives the host's environment-configured [ApiClient].
  FutureOr<void> initialize({ApiClient? apiClient}) {
    if (apiClient != null) {
      this.apiClient = apiClient;
    }
  }

  /// Lifecycle hook called during session logout or module teardown.
  /// Mandated to clear in-memory caches, cancel active streams, and wipe sensitive keys.
  FutureOr<void> dispose() {}

  /// Hook invoked whenever the global session state changes (login, logout, token refresh).
  void onSessionStateChanged(bool isAuthenticated, UserModel? user) {}
}

/// Façade type alias as defined in Section 4.1 (Rule 3) of the Architecture Decision Proposal.
typedef ModuleEntry = AppModule;
