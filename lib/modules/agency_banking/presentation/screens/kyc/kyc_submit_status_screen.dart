import 'package:citizenone_app/modules/agency_banking/core/utils/repsonsive_helper.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/snack.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/breakpoints.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/app_bar/kyc_app_bar.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/kyc_search_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/button/kyc_custom_button.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_form_bits.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_scaffold.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KycSubmitStatusScreen extends StatefulWidget {
  const KycSubmitStatusScreen({super.key});

  @override
  State<KycSubmitStatusScreen> createState() => _KycSubmitStatusScreenState();
}

class _KycSubmitStatusScreenState extends State<KycSubmitStatusScreen> {
  void _backToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const KYCSearchScreen(),
      ),
      (Route<dynamic> route) => false,
    );
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

  Widget _buildDesktopScaffold(BuildContext context) {
    return KycDesktopScaffold(
      pageTitle: "KYC Submission Complete",
      showBackButton: false,
      maxContentWidth: 560,
      child: KycDesktopCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.kycSuccessBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.kycSuccessGreen,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Customer KYC Submitted Successfully",
              style: TextStyle(
                color: AppColors.kycTitleNavy,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              textAlign: TextAlign.center,
              "You have successfully submitted the customer's KYC documents. "
              "Our verification team will review the documents shortly.",
              style: TextStyle(color: AppColors.kycSubtitleGray, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.kF8FAFC,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.kycBorder),
              ),
              child: BlocSelector<KycBloc, KycState, String?>(
                selector: (state) => state.code,
                builder: (context, refCode) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Reference Number",
                        style: TextStyle(
                          color: AppColors.kycSubtitleGray,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        refCode ?? "nil",
                        style: const TextStyle(
                          color: AppColors.kycTitleNavy,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    title: "Print Receipt",
                    icon: Icons.print_outlined,
                    onTap: () =>
                        Snack.show(context, message: "Printing receipt..."),
                    backgroundColor: AppColors.white,
                    isOutlined: true,
                    outlineColor: AppColors.k613AF5,
                    borderRadius: 10,
                    height: 48,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    title: "Back to Home",
                    icon: Icons.home_outlined,
                    backgroundColor: AppColors.k613AF5,
                    borderRadius: 10,
                    height: 48,
                    onTap: () => _backToHome(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileTabletScaffold(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: const KycAppBar(
          title: 'KYC Submission',
          centerTitle: true,
          bgColor: AppColors.primaryBlue,
          textIconColor: AppColors.white,
          showBack: false,
        ),
        body: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
                vertical: 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.value(context,
                      mobile: double.infinity, tablet: 480.0, web: 560.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.applicationCardBackground,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      margin: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF3C9718),
                            size: 70,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Customer KYC Submitted Successfully",
                            style: TextStyle(color: AppColors.black),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          const Text("REFERENCE NUMBER",
                              style: TextStyle(color: AppColors.black)),
                          const SizedBox(height: 10),
                          BlocSelector<KycBloc, KycState, String?>(
                            selector: (state) {
                              return state.code;
                            },
                            builder: (context, refCode) {
                              return Text(refCode ?? "nil",
                                  style: const TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w400));
                            },
                          ),
                          const SizedBox(height: 30),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              textAlign: TextAlign.center,
                              "You have successfully submitted the customer's KYC documents. "
                              "Our verification team will review the documents shortly.",
                              style: TextStyle(color: AppColors.black),
                            ),
                          ),
                          30.verticalSpace,
                          AppButton(
                              title: "Back to Home",
                              backgroundColor: AppColors.teal1,
                              onTap: () => _backToHome(context)),
                          30.verticalSpace,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
