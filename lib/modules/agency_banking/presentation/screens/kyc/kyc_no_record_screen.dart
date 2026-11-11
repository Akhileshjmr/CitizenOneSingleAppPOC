import 'package:citizenone_app/modules/agency_banking/core/utils/repsonsive_helper.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/breakpoints.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/button/kyc_custom_button.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_form_bits.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/colors/Appcolors.dart';
import '../../blocs/kyc_bloc/kyc_bloc.dart';
import '../../blocs/kyc_bloc/kyc_event.dart';
import 'widgets/app_bar/kyc_app_bar.dart';
import 'kyc_create_personal_screen.dart';

class NoRecordScreen extends StatelessWidget {
  final String? mobile;
  final String? nationalId;

  const NoRecordScreen({super.key, this.mobile, this.nationalId});

  void _createNewRecord(BuildContext context) {
    context.read<KycBloc>().add(const ResetFormData());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const KycCreatePersonalScreen(),
      ),
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
    final searched = (mobile?.isNotEmpty == true) ? mobile! : (nationalId ?? '');
    return KycDesktopScaffold(
      pageTitle: "Customer Record Not Found",
      pageSubtitle: "No existing KYC record was found for the provided details.",
      maxContentWidth: 780,
      child: KycDesktopCard(
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.kF8FAFC,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(
                              color: AppColors.kF59E0B,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_add_alt_1,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: AppColors.kycErrorRed,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.kF8FAFC, width: 2),
                              ),
                              child: const Icon(Icons.priority_high,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Existing KYC Record',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kycTitleNavy,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'The customer does not have an existing KYC record in the system. You may create a new record by clicking the button below.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.kycSubtitleGray,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                      if (searched.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.phone_outlined,
                                  size: 14, color: AppColors.kycSubtitleGray),
                              const SizedBox(width: 6),
                              Text(
                                'Searched: $searched',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.kycSubtitleGray),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.k613AF5.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.k613AF5.withValues(alpha: 0.18)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'New Customer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.k613AF5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Begin a fresh KYC verification process for this customer.',
                            style: TextStyle(
                                fontSize: 13, color: AppColors.kycSubtitleGray),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              title: "Create New KYC Record",
                              icon: Icons.person_add_alt_1,
                              onTap: () => _createNewRecord(context),
                              backgroundColor: AppColors.k613AF5,
                              borderRadius: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Try Again',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.kycTitleNavy,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Search with different mobile number or national ID.',
                            style: TextStyle(
                                fontSize: 13, color: AppColors.kycSubtitleGray),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              title: "Search Again",
                              icon: Icons.arrow_back,
                              onTap: () => Navigator.pop(context),
                              backgroundColor: AppColors.white,
                              isOutlined: true,
                              outlineColor: AppColors.k613AF5,
                              borderRadius: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileTabletScaffold(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: const KycAppBar(
        title: 'KYC Search Result',
        showBack: true,
        bgColor: AppColors.primaryBlue,
        textIconColor: AppColors.white,
        centerTitle: false,
      ),
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
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  Responsive.value(context,
                      mobile: 15.0, tablet: 28.0, web: 28.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: isMobile ? 30 : 24),

                    // Icon circle
                    Container(
                      width: Responsive.value(context, mobile: 80, web: 100),
                      height:
                          Responsive.value(context, mobile: 100.0, web: 120.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF3E0),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_search,
                        size:
                            Responsive.value(context, mobile: 52.0, web: 64.0),
                        color: AppColors.orange,
                      ),
                    ),
                    SizedBox(height: isMobile ? 20 : 10),

                    Text(
                      'No Existing KYC Record',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:
                            Responsive.fontSize(context, mobile: 14, web: 8),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      'The customer does not have an existing KYC record in the system. You may create a new record by clicking the button below.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.darkGray,
                        fontSize:
                            Responsive.fontSize(context, mobile: 14, web: 8),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Buttons — full width on mobile, fixed width on web
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: Responsive.value(context,
                            mobile: double.infinity, web: 360.0),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              title: "Create New KYC Record",
                              icon: Icons.person_add_alt_1,
                              onTap: () => _createNewRecord(context),
                              backgroundColor: AppColors.primaryBlue,
                            ),
                          ),
                          20.verticalSpace,
                           SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              title: "Search again",
                              icon: Icons.arrow_back,
                              onTap:() => Navigator.pop(context),
                              backgroundColor: AppColors.white,
                              isOutlined: true,
                              outlineColor: AppColors.black,
                            ),
                          ),
                         
                        ],
                      ),
                    ),

                    SizedBox(height: isMobile ? 12 : 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
