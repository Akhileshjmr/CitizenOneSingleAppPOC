import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/design_system/atoms/app_button.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../design_system/atoms/app_bar.dart';
import 'kyc_create_personal_screen.dart';

class NoRecordScreen extends StatelessWidget {
  final String? mobile;
  final String? nationalId;

  const NoRecordScreen({super.key, this.mobile, this.nationalId});
  @override
  Widget build(BuildContext context) {
    final bool isMobile = AdaptiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppStatusBar(
        title: 'KYC Search Result',
        showBack: true,
        bgColor: AppColors.primary,
        textIconColor: AppColors.surface,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AdaptiveLayout.horizontalPadding(context),
            vertical: 20,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AdaptiveLayout.contentMaxWidth(context),
            ),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  AdaptiveLayout.horizontalPadding(context),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: isMobile ? 30 : 24),

                    // Icon circle
                    Container(
                      width: isMobile ? 80 : 100,
                      height: isMobile ? 100.0 : 120.0,

                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF3E0),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_search,
                        size: isMobile ? 52.0 : 64.0,
                        color: AppColors.brandOrange,
                      ),
                    ),
                    SizedBox(height: isMobile ? 20 : 10),
                    AppText(
                      'No Existing KYC Record',
                      style: AppTextStyle.bodySmall,
                      color: AppColors.black,
                      textAlign: TextAlign.center,
                    ),
                    const VSpace(10),
                    AppText(
                      'The customer does not have an existing KYC record in the system. You may create a new record by clicking the button below',
                      style: AppTextStyle.bodySmall,
                      color: AppColors.textSecondary,
                      textAlign: TextAlign.center,
                    ),

                    const VSpace(28),

                    // Buttons — full width on mobile, fixed width on web
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: AdaptiveLayout.contentMaxWidth(context),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              text: "Create New KYC Record",
                              icon: Icons.person_add_alt_1,
                              onPressed: () {
                                context.read<KycBloc>().add(
                                  const ResetFormData(),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const KycCreatePersonalScreen(),
                                  ),
                                );
                              },
                              backgroundColor: AppColors.primary,
                            ),
                          ),
                          VSpace(20),
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              text: "Search again",
                              icon: Icons.arrow_back,
                              onPressed: () => Navigator.pop(context),
                              backgroundColor: AppColors.surface,
                              variant: AppButtonVariant.outline,
                              textColor: AppColors.black,
                              borderColor: AppColors.primary,
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
