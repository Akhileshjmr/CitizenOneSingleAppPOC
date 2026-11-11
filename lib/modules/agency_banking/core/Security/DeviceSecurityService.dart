import 'package:citizenone_app/modules/agency_banking/core/Security/security_status.dart';

import 'Biometric_Service.dart';

class DeviceSecurityService {
  Future<SecurityStatus> checkDeviceSecurity() async {
    final isFrida = await BiometricService.isFridaPresent();

    return SecurityStatus(
      isSecure: !isFrida,
      isRooted: false,
      isEmulator: false,
      isDebugged: false,
      isFridaDetected: isFrida,
    );
  }
}
