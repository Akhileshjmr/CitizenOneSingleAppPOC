import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/application_status_bloc/application_status_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/labeled_textField.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/loans_module/app/loans_module.dart';

import '../../../../constants/AppStrings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../data/models/BannerContent.dart';
import '../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../theme/colors/Appcolors.dart';
import '../../../../utils/CommSuccessDialogues.dart';
import '../../../../utils/Loader.dart';
import '../../../../utils/ResponsiveLeftBanner.dart';
import '../../../blocs/lms_blocs/application_status_bloc/application_status_state.dart';
import '../../Dashboard/widgets/BankSelectionScreen.dart';

class ApplicationStatusScreen extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;

  const ApplicationStatusScreen(
      {super.key, required this.loginResponse, required this.selectedBank});

  @override
  _ApplicationStatusScreen createState() => _ApplicationStatusScreen();
}

class _ApplicationStatusScreen extends State<ApplicationStatusScreen> {
  final TextEditingController applicantIdController =
      TextEditingController(); // 🔹 Controller for input

  @override
  void initState() {
    super.initState();
  }

  void _handleSubmit() {
    if (applicantIdController.text.isEmpty) {
      showCustomBottomPopup(context, "Customer Phone number is required");
      return;
    }

    if (applicantIdController.text.length < 9) {
      showCustomBottomPopup(
        context,
        "Customer Phone Number must be 9 digits",
      );
      return;
    }
    /*GdbChAppStatusReqRes response = GdbChAppStatusReqRes();
    response.applicantId = applicantIdController.text;
    context
        .read<ApplicationStatusBloc>()
        .add(ApplicationStatusSubmitted(response));*/

    LoansModule.openPlHistoryByCustomerPhone(
        phoneNumber: applicantIdController.text);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final List<BannerContent> banners = [
      BannerContent(
        imagePath: "assets/images/home_loan.jpg",
        title: AppStrings.bannerTitle,
        headline: AppStrings.bannerHeading,
        subtitle: AppStrings.bannerSubtitle,
        ctaText: AppStrings.bannerCreateText,
        onCtaPressed: () {
          AppLogger.debug('Banner CTA pressed');
        },
      ),
    ];

    return BlocListener<ApplicationStatusBloc, ApplicationStatusState>(
      listener: (context, state) {
        if (state is ApplicationStatusLoading) {
          context.read<LoadingCubit>().show();
        } else {
          context.read<LoadingCubit>().hide();
        }

        if (state is ApplicationStatusSuccess) {
          final res = state.appStatusReqRes;
          showApplicationSuccess(
              context, res, widget.loginResponse, widget.selectedBank);
        } else if (state is ApplicationStatusFailure) {
          AppLogger.error('Application status check failed', state.error);
          showCustomBottomPopup(context, state.error);
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Application Status",
        ),
        body: Row(
          children: [
            if (!isMobile) ResponsiveLeftBanner(banners: banners),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Check Application Status",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        LabeledTextField(
                          controller: applicantIdController,
                          maxLength: 9,
                          label: 'Customer Phone Number',
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.btnBackground,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Submit"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
