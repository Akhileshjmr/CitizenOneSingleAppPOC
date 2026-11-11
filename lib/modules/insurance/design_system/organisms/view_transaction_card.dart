import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/assets.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/atoms.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';

class ViewTransactionCard extends StatelessWidget {
  final String title;
  final String transactionId;
  final String policyNumber;
  final String filedDate;
  final String referenceNumber;
  final String hostRefNumber;
  final String customerName;
  final String mobileNumber;
  final String status;
  final bool isExpanded;
  final VoidCallback? onViewMore;
  final String policyId;
  final String policyGrossPremium;

  const ViewTransactionCard(
      {super.key,
      required this.title,
      required this.transactionId,
      required this.policyNumber,
      required this.filedDate,
      required this.referenceNumber,
      required this.hostRefNumber,
      required this.customerName,
      required this.mobileNumber,
      required this.status,
      required this.policyId,
      this.isExpanded = true,
      this.onViewMore,
      required this.policyGrossPremium});

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = status.toLowerCase() == 'failed' ||
        status.toLowerCase() == 'in progress';
    final formattedMobileNumber = mobileNumber.length >= 3
        ? '+${mobileNumber.substring(0, 3)}-${mobileNumber.substring(3)}'
        : mobileNumber;
    return Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: AppColors.surfaceBg,
                  blurRadius: 3,
                  spreadRadius: 1,
                  offset: Offset(0, 2))
            ],
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceBg)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  title,
                  style: AppTextStyle.bodyLarge,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                Row(
                  children: [
                    Container(
                      width: 78,
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(
                        color: status.toLowerCase().contains('failed')
                            ? AppColors.errorBgLight
                            : status.toLowerCase().contains('in progress')
                                ? AppColors.brandYellow
                                : AppColors.statusGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AppText(
                        status,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.labelSmall,
                        fontWeight: FontWeight.w500,
                        color: status.toLowerCase().contains('failed')
                            ? AppColors.error
                            : status.toLowerCase().contains('in progress')
                                ? AppColors.brandOrange
                                : AppColors.statusCardGreen,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return Padding(
                                padding: EdgeInsets.only(
                                  top: 96,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24),
                                      ),
                                    ),
                                    child: SafeArea(
                                        top: false,
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _buildHeader(context),
                                              selectionSection(
                                                context,
                                                onTap: () {
                                                  context
                                                      .read<
                                                          MotorInsuranceBloc>()
                                                      .add(DownloadInvoice(
                                                          policyId: policyId));
                                                },
                                                isDisabled: isDisabled,
                                                title: 'Download',
                                                icon: Icon(
                                                  Icons.download_outlined,
                                                  size: 18,
                                                  color: isDisabled
                                                      ? AppColors.primary
                                                          .withOpacity(0.38)
                                                      : AppColors.primary,
                                                ),
                                              ),
                                              const Divider(
                                                color: Color(0xffE6E6E6),
                                                thickness: 1,
                                                height: 1,
                                              ),
                                              selectionSection(context,
                                                  onTap: () {},
                                                  isDisabled: true,
                                                  title: 'Share',
                                                  svgIcon: AppAssets.iconShare),
                                              const Divider(
                                                color: Color(0xffE6E6E6),
                                                thickness: 1,
                                                height: 1,
                                              ),
                                              selectionSection(context,
                                                  isDisabled: isDisabled,
                                                  title: 'Print Receipt',
                                                  onTap: () {
                                                context
                                                    .read<MotorInsuranceBloc>()
                                                    .add(PrintReceipt(
                                                        policyId: policyId));
                                              }, svgIcon: AppAssets.doc),
                                              const SizedBox(height: 30)
                                            ]))));
                          },
                        );
                      },
                      child: SvgPicture.asset(
                        package: AppConfig.packageName,
                        AppAssets.moreIconFrame,
                      ),
                    )
                  ],
                ),
              ],
            ),
            AppText(
              filedDate,
              style: AppTextStyle.labelSmall,
              fontWeight: FontWeight.w500,
              color: AppColors.labelGrey,
              fontSize: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    'Ref No : $referenceNumber',
                    style: AppTextStyle.labelSmall,
                    fontWeight: FontWeight.w500,
                    color: AppColors.labelGrey,
                    fontSize: 12,
                  ),
                  AppText(
                    'ZMW $policyGrossPremium',
                    style: AppTextStyle.bodyMedium,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
            if (isExpanded) ...[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      customerName,
                      style: AppTextStyle.labelSmall,
                      fontWeight: FontWeight.w500,
                      color: AppColors.labelGrey,
                      fontSize: 12,
                    ),
                    AppText(
                      formattedMobileNumber,
                      style: AppTextStyle.labelSmall,
                      fontWeight: FontWeight.w500,
                      color: AppColors.labelGrey,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText(
                        'Host Ref No : $hostRefNumber',
                        style: AppTextStyle.labelSmall,
                        fontWeight: FontWeight.w500,
                        color: AppColors.labelGrey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppText(
                        'Policy No: $policyNumber',
                        style: AppTextStyle.labelSmall,
                        textAlign: TextAlign.right,
                        fontWeight: FontWeight.w500,
                        color: AppColors.labelGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: 16, bottom: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Expanded(
              //         child: SizedBox(
              //           width: 152,
              //           height: 34,
              //           child: AppButton(
              //             disable: true,
              //             variant: AppButtonVariant.outlined,
              //             textColor: AppColors.primary,
              //             label: 'Share',
              //             icon: Icons.share,
              //             foregroundColor: AppColors.primary,
              //           ),
              //         ),
              //       ),
              //       const HSpace(24),
              //       Expanded(
              //         child: SizedBox(
              //           width: 152,
              //           height: 34,
              //           child: AppButton(
              //             disable: status.toLowerCase() == 'in progress' ||
              //                 status.toLowerCase() == 'failed',
              //             onPressed: () {
              //               context
              //                   .read<MotorInsuranceBloc>()
              //                   .add(DownloadInvoice(policyId: policyId));
              //             },
              //             variant: AppButtonVariant.outlined,
              //             textColor: AppColors.primary,
              //             label: 'Download',
              //             icon: Icons.download,
              //             foregroundColor: AppColors.primary,
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
            ],
            const SizedBox(height: 10),
            InkWell(
              onTap: onViewMore,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    isExpanded ? 'View Less' : 'View More',
                    style: AppTextStyle.labelSmall,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget selectionSection(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
    Icon? icon,
    String? svgIcon,
    bool isDisabled = false,
  }) {
    final iconColor =
        isDisabled ? AppColors.primary.withOpacity(0.38) : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: InkWell(
        onTap: () {
          if (isDisabled == true) {
            return;
          } else {
            Navigator.pop(context);
            onTap();
          }
        },
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon.icon,
                color: iconColor,
              ),
            if (svgIcon != null)
              SvgPicture.asset(
                svgIcon,
                package: AppConfig.packageName,
                colorFilter: ColorFilter.mode(
                  iconColor,
                  BlendMode.srcIn,
                ),
              ),
            const SizedBox(width: 20),
            AppText(
              title,
              color: isDisabled
                  ? AppColors.black.withOpacity(0.5)
                  : AppColors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.deactivateBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
              iconSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
