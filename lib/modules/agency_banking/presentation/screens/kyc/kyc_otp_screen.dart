import 'package:citizenone_app/modules/agency_banking/core/utils/repsonsive_helper.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/snack.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/breakpoints.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/kyc_submit_status_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/app_bar/kyc_app_bar.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/button/kyc_custom_button.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_form_bits.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_scaffold.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class KycOtpScreen extends StatefulWidget {
  final String mobile;

  const KycOtpScreen({super.key, required this.mobile});

  @override
  State<KycOtpScreen> createState() => _KycOtpScreenState();
}

class _KycOtpScreenState extends State<KycOtpScreen> {
  late final KycBloc bloc;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = context.read<KycBloc>();
  }

  @override
  void dispose() {
    bloc.add(const ResetOtpStateEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (Breakpoints.isDesktop(constraints.maxWidth)) {
          return _buildDesktopScaffold(context);
        }
        return _buildMobileTabletScaffold(context);
      },
    );
  }

  bool _otpListenWhen(KycState previous, KycState current) =>
      (!previous.kycOtpVerified && current.kycOtpVerified) ||
      (!previous.submitKyc && current.submitKyc) ||
      (previous.errorMessage != current.errorMessage &&
          current.errorMessage != null);

  void _otpListener(BuildContext context, KycState state) {
    if (state.kycOtpVerified) {
      context.read<KycBloc>().add(const SubmitKycEvent());
    }
    if (state.errorMessage != null && state.otpStatus == OtpStatus.otpInvalid) {
      Snack.show(context, message: state.errorMessage.toString());
      context.read<KycBloc>().add(ClearErrorEvent());
      return;
    }
    if (state.errorMessage != null &&
        state.otpStatus == OtpStatus.resendingOtp) {
      Snack.show(context, message: "Resending OTP...");
      context.read<KycBloc>().add(ClearErrorEvent());
      return;
    }
    if (state.submitKyc) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const KycSubmitStatusScreen(),
        ),
        (Route<dynamic> route) => false,
      );
      return;
    }
    if (state.errorMessage != null &&
        !state.isSubmittingKyc &&
        state.otpStatus != OtpStatus.otpInvalid &&
        state.otpStatus != OtpStatus.resendingOtp) {
      Snack.show(context, message: state.errorMessage!);
      context.read<KycBloc>().add(ClearErrorEvent());
      return;
    }
  }

  void _verifyOtp(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final otp = _otpController.text.trim();
    bloc.add(VerifyOtpEvent(widget.mobile, otp));
  }

  Widget _buildMobileTabletScaffold(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        bottomNavigationBar: BlocBuilder<KycBloc, KycState>(
          builder: (context, state) {
            return bottomButton(context, state);
          },
        ),
        appBar: const KycAppBar(title: "Verify OTP"),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocListener<KycBloc, KycState>(
              listenWhen: _otpListenWhen,
              listener: _otpListener,
              child: Column(children: [
                20.verticalSpace,
                BlocSelector<KycBloc, KycState, String>(
                  selector: (state) {
                    return state.otpDisplayMessage!;
                  },
                  builder: (context, otpMessage) {
                    return Text(otpMessage,
                        style: TextStyle(
                          fontSize:
                              Responsive.fontSize(context, mobile: 14, web: 8),
                        ));
                  },
                ),
                20.verticalSpace,
                Form(
                  key: _formKey,
                  child: Pinput(
                    autofocus: false,
                    controller: _otpController,
                    errorTextStyle: TextStyle(
                        color: AppColors.buttonRelatedTextColor,
                        fontSize:
                            Responsive.fontSize(context, mobile: 12, web: 8)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'OTP is required';
                      }
                      if (value.length != 6) {
                        return 'Please enter a valid OTP';
                      }
                      return null;
                    },
                    length: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(r'[^0-9]'),
                      ),
                    ],
                    defaultPinTheme: PinTheme(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.teal1),
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8.sp)),
                    ),
                  ),
                ),
                20.verticalSpace,
                BlocSelector<KycBloc, KycState, int>(
                  selector: (state) => state.otpTimer,
                  builder: (context, timer) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Didn't receive OTP?",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Responsive.fontSize(context,
                                    mobile: 14, web: 8),
                              )),
                          4.horizontalSpace,
                          (timer > 0)
                              ? Text("You can resend in ${timer}s",
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context,
                                        mobile: 14, web: 8),
                                  ))
                              : AppButton(
                                  isTextButton: true,
                                  width: 120.w,
                                  onTap: () =>
                                      bloc.add(ResendOtpEvent(widget.mobile)),
                                  title: "Resend OTP",
                                  backgroundColor: AppColors.teal1,
                                  textStyle: TextStyle(
                                    color: AppColors.teal1,
                                    fontSize: Responsive.fontSize(context,
                                        mobile: 14, web: 8),
                                  ),
                                )
                        ]);
                  },
                ),
                20.verticalSpace,
              ])),
        ));
  }

  Widget _buildDesktopScaffold(BuildContext context) {
    return KycDesktopScaffold(
      pageTitle: "OTP Verification",
      pageSubtitle:
          "Enter the 6-digit code sent to the customer's registered mobile number.",
      maxContentWidth: 460,
      child: BlocListener<KycBloc, KycState>(
        listenWhen: _otpListenWhen,
        listener: _otpListener,
        child: KycDesktopCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.k613AF5.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.gpp_good_outlined,
                    color: AppColors.k613AF5, size: 30),
              ),
              const SizedBox(height: 16),
              const Text(
                "One Time Verification",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              BlocSelector<KycBloc, KycState, String>(
                selector: (state) => state.otpDisplayMessage!,
                builder: (context, otpMessage) {
                  return Text(
                    otpMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.darkGray),
                  );
                },
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Pinput(
                  autofocus: false,
                  controller: _otpController,
                  errorTextStyle: const TextStyle(
                      color: AppColors.buttonRelatedTextColor, fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'OTP is required';
                    }
                    if (value.length != 6) {
                      return 'Please enter a valid OTP';
                    }
                    return null;
                  },
                  length: 6,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[^0-9]')),
                  ],
                  defaultPinTheme: PinTheme(
                    height: 50,
                    width: 50,
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.kycBorder),
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  focusedPinTheme: PinTheme(
                    height: 50,
                    width: 50,
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.k613AF5, width: 1.5),
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  submittedPinTheme: PinTheme(
                    height: 50,
                    width: 50,
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.k613AF5),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.k613AF5),
                        color: AppColors.k613AF5.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BlocSelector<KycBloc, KycState, int>(
                selector: (state) => state.otpTimer,
                builder: (context, timer) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Didn't receive OTP?",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      4.horizontalSpace,
                      (timer > 0)
                          ? Text("You can resend in ${timer}s")
                          : AppButton(
                              isTextButton: true,
                              width: 120,
                              onTap: () =>
                                  bloc.add(ResendOtpEvent(widget.mobile)),
                              title: "Resend OTP",
                              backgroundColor: AppColors.k613AF5,
                              textStyle:
                                  const TextStyle(color: AppColors.k613AF5),
                            ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _otpController,
                builder: (context, value, _) {
                  final isOtpComplete = value.text.trim().length == 6;
                  return BlocBuilder<KycBloc, KycState>(
                    builder: (context, state) {
                      return AppButton(
                        title: "Verify OTP",
                        isLoading: state.otpStatus == OtpStatus.verifyingOtp,
                        onTap: isOtpComplete ? () => _verifyOtp(context) : null,
                        backgroundColor: AppColors.k613AF5,
                        borderRadius: 10,
                        height: 48,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomButton(BuildContext context, KycState state) {
    return Container(
      height: 100.h,
      color: AppColors.white,
      padding:
          EdgeInsets.only(bottom: 30.sp, right: 20.sp, left: 20.sp, top: 30.sp),
      child: (state.otpStatus == OtpStatus.verifyingOtp)
          ? AppButton(
              title: "",
              backgroundColor: AppColors.teal1,
              isLoading: true,
              onTap: () {})
          : ValueListenableBuilder<TextEditingValue>(
              valueListenable: _otpController,
              builder: (context, value, _) {
                final isOtpComplete = value.text.trim().length == 6;
                return AppButton(
                  title: "Verify",
                  onTap: isOtpComplete ? () => _verifyOtp(context) : null,
                  backgroundColor: AppColors.teal1,
                  height: 40.h,
                  width: 150.w,
                );
              },
            ),
    );
  }
}
