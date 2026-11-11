import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  /// Opens Google Maps externally with the given coordinates
  static Future<void> openMapLocation(double latitude, double longitude) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    try {
      final canLaunchMap = await canLaunchUrl(url);
      if (canLaunchMap) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        log('Could not launch Google Maps. URL: $url');
      }
    } catch (e) {
      log('Error opening Google Maps: $e');
    }
  }
}
