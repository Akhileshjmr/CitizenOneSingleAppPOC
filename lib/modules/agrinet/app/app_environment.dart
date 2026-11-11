class AppEnvironment {
  static bool isEmbeddedInHostApp = false;
  static const String flutterPackageName = 'agrinet';

  static void markAsEmbedded() {
    isEmbeddedInHostApp = true;
  }

  static String? get packageName =>
      isEmbeddedInHostApp ? flutterPackageName : null;
}
