import 'package:citizenone_app/modules/agency_banking/core/Security/DetectSecurity.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:vpn_connection_detector/vpn_connection_detector.dart';

class VPNDetectionService {
  static Future<bool> isVPNActive() async {
    if (!SecurityConfig.secOnn) return false;

    try {
      final isConnected = await VpnConnectionDetector.isVpnActive();
      if (isConnected) {
        AppLogger.warning('VPN connection detected');
      }
      return isConnected;
    } catch (e) {
      AppLogger.error('VPN detection failed', e);
      return false;
    }
  }
}
