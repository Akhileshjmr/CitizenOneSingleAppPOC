import 'dart:async';

class SessionExpiryMonitor {
  SessionExpiryMonitor({DateTime Function()? nowProvider})
    : _nowProvider = nowProvider ?? DateTime.now;

  final DateTime Function() _nowProvider;
  Timer? _timer;

  bool get isRunning => _timer?.isActive ?? false;

  void start({
    required DateTime expiresAt,
    required void Function(Duration remaining) onTick,
  }) {
    stop();

    void emitTick() {
      final remaining = expiresAt.difference(_nowProvider().toUtc());
      onTick(remaining);
    }

    emitTick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => emitTick());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
