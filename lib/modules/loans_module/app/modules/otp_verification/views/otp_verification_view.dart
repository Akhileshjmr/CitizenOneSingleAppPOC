import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/ag_button.dart';
import '../../../components/ui/base_screen.dart';
import '../../../theme/ag_text_styles.dart';
import '../../../utils/app_colors.dart';
import '../controllers/otp_verification_controller.dart';

/// OTP Verification View
class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: const AgAppbar(title: 'OTP Verification'),
      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: SafeArea(
            child: Column(
              children: [
                /// Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Description
                        Text(
                          'To help validate process, please enter the OTP by pressing on the below button.',
                          style: kw400Black14.copyWith(
                            color: AppColors.k727272,
                          ),

                          textAlign: TextAlign.center,
                        ),

                        32.verticalSpace,

                        /// Attempts remaining
                        Obx(
                          () => Center(
                            child: Text(
                              'Attempts Remaining: ${controller.attemptRemaining}',
                              style: kw500Black14.copyWith(
                                color:
                                    controller.attemptRemaining.value <= 1
                                        ? Colors.red
                                        : AppColors.k727272,
                              ),
                            ),
                          ),
                        ),

                        12.verticalSpace,

                        /// OTP sent destination
                        Obx(
                          () =>
                              (controller.channel.value.isNotEmpty &&
                                      controller.destination.value.isNotEmpty)
                                  ? Center(
                                    child: Text(
                                      'OTP sent via ${controller.channel.value} to ${controller.destination.value}',
                                      textAlign: TextAlign.center,
                                      style: kw400Black14.copyWith(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  )
                                  : const SizedBox.shrink(),
                        ),

                        12.verticalSpace,

                        /// Generated OTP (for debugging)
                        Obx(
                          () =>
                              controller.generatedOtp.value.isNotEmpty
                                  ? Center(
                                    child: Text(
                                      'OTP: ${controller.generatedOtp.value}',
                                      style: kw500Black14.copyWith(
                                        color: Colors.green,
                                      ),
                                    ),
                                  )
                                  : const SizedBox.shrink(),
                        ),

                        Obx(
                          () => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            child:
                                controller.isVerifiedSuccess.value
                                    ? Container(
                                      key: const ValueKey("success"),
                                      width: double.infinity,
                                      margin: EdgeInsets.only(top: 20.h),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 14.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        border: Border.all(
                                          color: Colors.green.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          TweenAnimationBuilder<double>(
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            curve: Curves.elasticOut,
                                            tween: Tween(begin: 0.0, end: 1.0),
                                            builder: (context, value, child) {
                                              return Opacity(
                                                opacity: value.clamp(0.0, 1.0),
                                                child: Transform.scale(
                                                  scale: value,
                                                  child: child,
                                                ),
                                              );
                                            },
                                            child: Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.green.shade700,
                                              size: 24.sp,
                                            ),
                                          ),
                                          12.horizontalSpace,
                                          Expanded(
                                            child: Text(
                                              controller.successMessage.value,
                                              style: kw500Black14.copyWith(
                                                color: Colors.green.shade800,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    : const SizedBox.shrink(),
                          ),
                        ),

                        32.verticalSpace,

                        /// OTP fields
                        _buildOtpInputFields(),

                        32.verticalSpace,

                        /// Resend OTP
                        Obx(
                          () => Center(
                            child:
                                controller.isTimerRunning
                                    ? Text(
                                      'Resend OTP in: ${controller.formattedTime}',
                                      style: kw400Black14.copyWith(
                                        color: AppColors.k727272,
                                      ),
                                    )
                                    : TextButton(
                                      onPressed:
                                          controller.isOtpLocked
                                              ? null
                                              : controller.resendOtp,
                                      child: Text(
                                        'Resend OTP',
                                        style: kw500Primary14,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Fixed Bottom Verify Button
                Obx(
                  () => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: EdgeInsets.fromLTRB(
                      16.w,
                      12.h,
                      16.w,
                      MediaQuery.of(context).viewInsets.bottom > 0
                          ? 12.h
                          : 24.h,
                    ),
                    decoration: const BoxDecoration(color: Color(0xFFF5F6F8)),
                    child: SafeArea(
                      top: false,
                      child: AgButton(
                        title: 'Verify',
                        onTap:
                            controller.canVerify
                                ? controller.verifyAndSubmit
                                : null,
                        isEnabled: controller.canVerify,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build 6-digit OTP input fields
  Widget _buildOtpInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48.w,
          height: 56.h,
          child: TextField(
            controller: controller.otpControllers[index],
            focusNode: controller.focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            maxLength: 1,
            style: kw600Black18,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            onChanged: (value) => controller.onOtpChanged(value, index),
          ),
        );
      }),
    );
  }
}
