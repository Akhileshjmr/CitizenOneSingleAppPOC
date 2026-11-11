import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/design_system/atoms/app_button.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_search_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/design_system/atoms/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KycSubmitStatusScreen extends StatefulWidget {
  const KycSubmitStatusScreen({super.key});

  @override
  State<KycSubmitStatusScreen> createState() => _KycSubmitStatusScreenState();
}

class _KycSubmitStatusScreenState extends State<KycSubmitStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const AppStatusBar(
        title: 'KYC Submission',
        centerTitle: true,
        bgColor: AppColors.primary,
        textIconColor: AppColors.surface,
        showBack: false,
      ),
      body: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AdaptiveLayout.horizontalPadding(context),
              vertical: 10,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: AdaptiveLayout.contentMaxWidth(
                  context,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF3C9718),
                          size: 70,
                        ),
                        const SizedBox(height: 20),
                        const AppText(
                          "Customer KYC Submitted Successfully",
                          style: AppTextStyle.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        const AppText(
                          "REFERENCE NUMBER",
                          style: AppTextStyle.bodyMedium,
                          textAlign: TextAlign.center,
                        ),

                        BlocSelector<KycBloc, KycState, String?>(
                          selector: (state) {
                            return state.code;
                          },
                          builder: (context, refCode) {
                            return AppText(
                              refCode ?? "nil",
                              style: AppTextStyle.bodyMedium,
                              textAlign: TextAlign.center,
                              color: AppColors.black,
                            );
                          },
                        ),

                        const SizedBox(height: 30),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child:  AppText(
                            textAlign: TextAlign.center,
                            "You have successfully submitted the customer's KYC documents. "
                            "Our verification team will review the documents shortly.",
                            style: AppTextStyle.bodySmall, color: AppColors.black),
                          
                        ),
                        VSpace(30),
                        AppButton(
                          text: "Back to Home",
                          backgroundColor: AppColors.primary,
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const KycSearchScreen(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                        VSpace(30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
