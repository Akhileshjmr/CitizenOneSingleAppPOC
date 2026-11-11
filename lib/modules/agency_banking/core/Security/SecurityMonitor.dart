import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:citizenone_app/modules/agency_banking/core/Security/DetectSecurity.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/utils/SecurityGuard.dart';

class SecurityMonitor extends StatefulWidget {
  final Widget child;

  const SecurityMonitor({super.key, required this.child});

  @override
  State<SecurityMonitor> createState() => _SecurityMonitorState();
}

class _SecurityMonitorState extends State<SecurityMonitor> with WidgetsBindingObserver {
  Timer? _periodicTimer;
  bool _blocked = false;

  static const Duration _checkInterval = Duration(minutes: 2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startPeriodicCheck();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _periodicTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _runSecurityCheck(source: 'app_resumed');
    }
  }

  void _startPeriodicCheck() {
    if (!SecurityConfig.secOnn || kDebugMode) return;

    _periodicTimer = Timer.periodic(_checkInterval, (_) {
      _runSecurityCheck(source: 'periodic');
    });
  }

  Future<void> _runSecurityCheck({required String source}) async {
    if (!SecurityConfig.secOnn || kDebugMode || _blocked) return;

    try {
      final result = await SecurityGuard.performChecks();
      if (result.hasThreat && mounted) {
        AppLogger.warning('SecurityMonitor [$source]: ${result.threats}');
        setState(() => _blocked = true);
        _periodicTimer?.cancel();
        _showSecurityAlert(result.threats);
      }
    } catch (e) {
      AppLogger.error('SecurityMonitor check failed', e);
    }
  }

  void _showSecurityAlert(List<String> threats) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.security, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text('Security Alert', style: TextStyle(color: Colors.red)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Security threat detected on this device:'),
              const SizedBox(height: 12),
              ...threats.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(child: Text(t)),
                  ],
                ),
              )),
              const SizedBox(height: 12),
              const Text(
                'Please resolve the issue and restart the app.',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('Close App', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
