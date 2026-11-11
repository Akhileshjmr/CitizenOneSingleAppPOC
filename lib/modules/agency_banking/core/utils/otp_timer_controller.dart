import 'dart:async';

import 'package:flutter/material.dart';

/// =========================================================
/// GLOBAL OTP RESEND TIMER CONTROLLER
/// Use ONE instance per OTP screen (create it once, reuse it,
/// dispose it when the screen closes).
/// =========================================================
class OtpTimerController {
  final int totalSeconds;
  final int maxAttempts;

  OtpTimerController({
    this.totalSeconds = 30,
    this.maxAttempts = 3,
  }) {
    displayText.value = 'Resend OTP';
  }

  // Listenable state - your UI reacts to these automatically
  final ValueNotifier<int> secondsLeft = ValueNotifier<int>(0);
  final ValueNotifier<String> displayText = ValueNotifier<String>('Resend OTP');
  final ValueNotifier<bool> isEnabled = ValueNotifier<bool>(true);
  final ValueNotifier<Color> textColor = ValueNotifier<Color>(Colors.blue);

  Timer? _timer;
  int _attempts = 0;

  int get attemptsLeft => maxAttempts - _attempts;

  bool get hasReachedMaxAttempts => _attempts >= maxAttempts;

  /// Call this to START the timer.
  /// [countAttempt] = true  -> use this for actual RESEND taps (consumes an attempt)
  /// [countAttempt] = false -> use this for the very first auto-start on screen load
  ///                           (e.g. right after the initial OTP is sent) so it
  ///                           does NOT eat into the 3 resend attempts.
  void startTimer({bool countAttempt = true}) {
    if (countAttempt) {
      if (hasReachedMaxAttempts) {
        _setMaxAttemptsReached();
        return;
      }
      _attempts++;
    }

    secondsLeft.value = totalSeconds;
    isEnabled.value = false;
    textColor.value = Colors.grey;
    _updateText();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value > 0) {
        secondsLeft.value--;
        _updateText();
      } else {
        timer.cancel();
        if (hasReachedMaxAttempts) {
          _setMaxAttemptsReached();
        } else {
          isEnabled.value = true;
          textColor.value = Colors.blue;
          displayText.value = 'Resend OTP';
        }
      }
    });
  }

  /// Call this to CANCEL the timer immediately (resets to 0 sec, re-enables text)
  void cancelTimer() {
    _timer?.cancel();
    secondsLeft.value = 0;
    if (!hasReachedMaxAttempts) {
      isEnabled.value = true;
      textColor.value = Colors.blue;
      displayText.value = 'Resend OTP';
    }
  }

  /// Call this to fully reset attempts (e.g. new phone number entered)
  void reset() {
    _timer?.cancel();
    _attempts = 0;
    secondsLeft.value = 0;
    isEnabled.value = true;
    textColor.value = Colors.blue;
    displayText.value = 'Resend OTP';
  }

  void _updateText() {
    displayText.value = 'Resend OTP in ${secondsLeft.value}s';
  }

  void _setMaxAttemptsReached() {
    _timer?.cancel();
    isEnabled.value = false;
    textColor.value = Colors.red;
    displayText.value = 'You have reached max attempts';
  }

  /// Call this in your screen's dispose()
  void dispose() {
    _timer?.cancel();
    secondsLeft.dispose();
    displayText.dispose();
    isEnabled.dispose();
    textColor.dispose();
  }
}

/// =========================================================
/// READY-MADE WIDGET
/// Drop this anywhere you need the "Resend OTP" text/button.
/// =========================================================
class OtpResendText extends StatelessWidget {
  final OtpTimerController controller;
  final VoidCallback onResend;
  final TextStyle? style;

  const OtpResendText({
    super.key,
    required this.controller,
    required this.onResend,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isEnabled,
      builder: (context, enabled, _) {
        return ValueListenableBuilder<String>(
          valueListenable: controller.displayText,
          builder: (context, text, __) {
            return ValueListenableBuilder<Color>(
              valueListenable: controller.textColor,
              builder: (context, color, ___) {
                return GestureDetector(
                  onTap: enabled
                      ? () {
                          controller.startTimer();
                          onResend();
                        }
                      : null,
                  child: Text(
                    text,
                    style: (style ??
                            const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600))
                        .copyWith(
                      color: color,
                      decoration: enabled
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

/// =========================================================
/// USAGE EXAMPLE (in any OTP screen in your project)
/// =========================================================
///
/// class OtpScreen extends StatefulWidget {
///   const OtpScreen({super.key});
///   @override
///   State<OtpScreen> createState() => _OtpScreenState();
/// }
///
/// class _OtpScreenState extends State<OtpScreen> {
///   final OtpTimerController _otpTimerController = OtpTimerController(
///     totalSeconds: 30,
///     maxAttempts: 3,
///   );
///
///   @override
///   void initState() {
///     super.initState();
///     _otpTimerController.startTimer(); // auto-start when screen opens
///   }
///
///   @override
///   void dispose() {
///     _otpTimerController.dispose(); // always dispose
///     super.dispose();
///   }
///
///   void _callResendOtpApi() {
///     // your resend OTP API call here
///   }
///
///   void _onUserCancelsScreen() {
///     _otpTimerController.cancelTimer(); // resets timer to 0 sec
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Center(
///         child: OtpResendText(
///           controller: _otpTimerController,
///           onResend: _callResendOtpApi,
///         ),
///       ),
///     );
///   }
/// }
