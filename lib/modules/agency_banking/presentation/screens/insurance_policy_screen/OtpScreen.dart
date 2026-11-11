/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_utils.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../theme/colors/Appcolors.dart';
import 'LoanApplicationSubmittedPage.dart';

// OTP Verification Screen
class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _timer;
  int _remainingTime = 119; // 1 minute 59 seconds

  // For OTP input fields
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  String get _formattedTime {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  String get _enteredOtp {
    return _otpControllers.map((controller) => controller.text).join();
  }

  bool get _isOtpComplete {
    return _otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  void _verifyOtp() {
    if (!_isOtpComplete) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    hideKeyboard();

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Remove loading dialog

      // Check OTP (demo: 123456 is valid)
      if (_enteredOtp == '123456') {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification successful!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ApplicationSubmittedScreen(
              estimatedTime: '1 - 2 Business Days',
              referenceNumber: 'LN${DateTime.now().millisecondsSinceEpoch % 1000000}', // generate or pass real ref
              description: 'Your application has been received and is being processed. You will be notified once approved.',
            ),
          ),
        );
        // Navigate to next screen
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NextScreen()));
      } else {
        // Failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid verification code. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        // Clear OTP fields
        _clearOtpFields();
        _otpFocusNodes[0].requestFocus();
      }
    });
  }

  void _clearOtpFields() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
  }

  void _resendOtp() {
    if (_remainingTime > 0) return;

    setState(() {
      _remainingTime = 119; // Reset timer
      _clearOtpFields();
    });
    _startTimer();

    // Show message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New verification code sent to your number'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'OTP'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Icon
              Icon(
                Icons.verified_user_outlined,
                size: 80,
                color: Colors.blue[700],
              ),

              const SizedBox(height: 24),

              // Title
              const Text(
                'One Time Verification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              // Description
              const Text(
                'A verification code has been sent to your registered number',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 32),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 55,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _otpFocusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: _otpControllers[index].text.isEmpty
                                ? Colors.grey[300]!
                                : Colors.blue,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        _onOtpChanged(value, index);
                        setState(() {});
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: _remainingTime > 0 ? Colors.orange : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Code expires in $_formattedTime',
                    style: TextStyle(
                      fontSize: 16,
                      color: _remainingTime > 0 ? Colors.orange : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Resend Code Button
              TextButton(
                onPressed: _remainingTime > 0 ? null : _resendOtp,
                child: Text(
                  'Resend Code',
                  style: TextStyle(
                    fontSize: 16,
                    color: _remainingTime > 0 ? Colors.grey : AppColors.btnBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isOtpComplete ? _verifyOtp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.btnBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              //
              // // Phone number (optional - you can make it dynamic)
              // const Text(
              //   'Sent to: +1 (234) 567-8900',
              //   style: TextStyle(
              //     fontSize: 14,
              //     color: Colors.grey,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
