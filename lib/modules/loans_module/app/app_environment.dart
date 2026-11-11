class AppEnvironment {
  static bool isEmbeddedInHostApp = false;
  static const String flutterPackageName = 'loans_module';

  static void markAsEmbedded() {
    isEmbeddedInHostApp = true;
  }

  static String? get packageName =>
      isEmbeddedInHostApp ? flutterPackageName : null;
}
