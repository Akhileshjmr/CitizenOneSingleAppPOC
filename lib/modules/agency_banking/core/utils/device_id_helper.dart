import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceIdHelper {
  DeviceIdHelper._internal();
  static final DeviceIdHelper _instance = DeviceIdHelper._internal();
  factory DeviceIdHelper() => _instance;

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final AndroidId _androidIdPlugin = const AndroidId();

  String? _cachedDeviceId;

  Future<String> getDeviceId() async {
    if (_cachedDeviceId != null && _cachedDeviceId!.isNotEmpty) {
      return _cachedDeviceId!;
    }

    String id = 'unknown_device';

    try {
      /*if (Platform.isAndroid) {
        // Settings.Secure.ANDROID_ID — unique per app-signing-key +
        // device + user profile. Resets on factory reset.
        final androidId = await _androidIdPlugin.getId();
        if (androidId != null && androidId.isNotEmpty) {
          id = androidId;
        }*/
      if (Platform.isAndroid) {
        final androidId = await _androidIdPlugin.getId();
        print('DEBUG raw androidId: "$androidId"'); // TEMP
        if (androidId != null && androidId.isNotEmpty) {
          id = androidId;
        }
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        var vendorId = iosInfo.identifierForVendor;

        int attempts = 0;
        while ((vendorId == null || vendorId.isEmpty) && attempts < 3) {
          await Future.delayed(const Duration(milliseconds: 300));
          final retryInfo = await _deviceInfoPlugin.iosInfo;
          vendorId = retryInfo.identifierForVendor;
          attempts++;
        }

        if (vendorId != null && vendorId.isNotEmpty) {
          id = vendorId;
        }
      }
    } catch (e, stack) {
      print('DEBUG DeviceIdHelper EXCEPTION: $e'); // TEMP
      print('DEBUG STACK: $stack');
      id = 'unknown_device';
    }

    _cachedDeviceId = id;
    return id;
  }
}
