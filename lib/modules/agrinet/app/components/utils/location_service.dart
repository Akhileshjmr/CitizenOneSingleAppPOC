import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Check & Request Location Permission
  static Future<bool> _handlePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }

    return true;
  }

  /// Get Current Address
  static Future<String> getUserAddress() async {
    try {
      final hasPermission = await _handlePermission();
      if (!hasPermission) return "Permission denied";

      Position? position;

      // 1️⃣ Try last known position (fast & prevents timeout issue)
      position = await Geolocator.getLastKnownPosition();

      // 2️⃣ If null, get fresh current position
      position ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException("Location timeout");
        },
      );

      // 3️⃣ Convert coordinates to address
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return "Address not found";

      final place = placemarks.first;

      final addressParts = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ];

      final filteredParts =
          addressParts
              .where((part) => part != null && part.trim().isNotEmpty)
              .toList();

      return filteredParts.isEmpty
          ? "Address not found"
          : filteredParts.join(", ");
    } catch (e) {
      return "Address not found";
    }
  }
}
