import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/utils/snack.dart';
import 'package:citizenone_app/design_system/atoms/app_button.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_submit_status_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/design_system/atoms/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final bool isMobile = AdaptiveLayout.isMobile(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BlocBuilder<KycBloc, KycState>(
        builder: (context, state) {
          return bottomButton(context, state);
        },
      ),
      appBar: AppStatusBar(title: "Verify OTP"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocListener<KycBloc, KycState>(
          listenWhen: (previous, current) =>
              (!previous.kycOtpVerified && current.kycOtpVerified) ||
              (!previous.submitKyc && current.submitKyc) ||
              (previous.errorMessage != current.errorMessage &&
                  current.errorMessage != null),
          listener: (context, state) {
            if (state.kycOtpVerified) {
              context.read<KycBloc>().add(const SubmitKycEvent());
            }
            if (state.errorMessage != null &&
                state.otpStatus == OtpStatus.otpInvalid) {
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
          },
          child: Column(
            children: [
              VSpace(20),
              BlocSelector<KycBloc, KycState, String>(
                selector: (state) {
                  return state.otpDisplayMessage!;
                },
                builder: (context, otpMessage) {
                  return AppText(
                    otpMessage,
                    style: AppTextStyle.bodyMedium,
                    color: AppColors.black,
                  );
                },
              ),
              VSpace(20),
              Form(
                key: _formKey,
                child: Pinput(
                  controller: _otpController,
                  errorTextStyle: TextStyle(
                    color: AppColors.primary,
                    fontSize: isMobile? 12: 8,
                  ),
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
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              VSpace(20),
              BlocSelector<KycBloc, KycState, int>(
                selector: (state) => state.otpTimer,
                builder: (context, timer) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        "Didn't receive OTP?",
                        style: AppTextStyle.bodySmall,
                        color: AppColors.black,
                      ),
                      HSpace(4),
                      (timer > 0)
                          ? AppText(
                              "You can resend in ${timer}s",
                              style: AppTextStyle.bodySmall,
                              color: AppColors.black,
                            )
                          : AppButton(
                              height: 25,
                              width: 120,
                              variant: AppButtonVariant.outline,
                              borderColor: AppColors.primary,
                              onPressed: () =>
                                  bloc.add(ResendOtpEvent(widget.mobile)),
                              text: "Resend OTP",
                              backgroundColor: AppColors.surface,
                              textColor: AppColors.black,
                            ),
                    ],
                  );
                },
              ),
              VSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomButton(BuildContext context, KycState state) {
    return Container(
      height: 100,
      color: AppColors.surface,
      padding: EdgeInsets.only(
        bottom: 30,
        right: 20,
        left: 20,
        top: 30,
      ),
      child: (state.otpStatus == OtpStatus.verifyingOtp)
          ? AppButton(
              text: "",
              backgroundColor: AppColors.primary,
              isLoading: true,
              onPressed: () {},
            )
          : AppButton(
              text: "Verify",
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                final otp = _otpController.text.trim();
                bloc.add(VerifyOtpEvent(widget.mobile, otp));
              },
              backgroundColor: AppColors.primary,
              height: 40,
              width: 150,
            ),
    );
  }
}
