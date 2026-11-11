import 'package:citizenone_app/modules/agency_banking/core/Security/security_status.dart';

import 'Biometric_Service.dart';
import 'DeviceSecurityService.dart';
import 'RunTimeSecurityService.dart';

class SecurityManager {
  final DeviceSecurityService _deviceSecurity;
  final RuntimeSecurityService _runtimeSecurity;

  SecurityManager(this._deviceSecurity, this._runtimeSecurity);

  Future<SecurityStatus> checkSecurity() async {
    final result = await _deviceSecurity.checkDeviceSecurity();

    if (!result.isSecure) {
      await _handleViolation();
    }

    return result;
  }

  void startMonitoring() {
    // _runtimeSecurity.startMonitoring(onViolation: _handleViolation);
  }

  Future<void> _handleViolation() async {
    await BiometricService.wipeAll();

    // Navigate to suspicious screen
    // (Keep UI outside ideally)
  }
}