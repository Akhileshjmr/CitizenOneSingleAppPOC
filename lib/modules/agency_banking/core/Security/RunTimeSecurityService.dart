import 'dart:async';

import 'package:citizenone_app/modules/agency_banking/utils/SecurityGuard.dart';
import 'package:flutter/foundation.dart';

class RuntimeSecurityService {
  Timer? _timer;

  void startMonitoring({required void Function(List<String>) onViolation}) {
    if (kDebugMode) return;
    _timer = Timer.periodic(const Duration(seconds: 30), (_) async {
      final result = await SecurityGuard.performChecks();
      if (result.hasThreat) {
        onViolation(result.threats);
      }
    });
  }

  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
  }
}
