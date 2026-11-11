import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/responsive_widgets.dart';
import 'package:citizenone_app/modules/insurance/core/extensions/build_context_x.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_spacing.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/assets.dart';
import 'package:citizenone_app/modules/insurance/core/utils/snack.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/vehicle_details_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/process_step_status.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/result_hero.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/summary_card.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/transaction_detail_widgets.dart';

class MotorPolicyConfirmedPage extends StatelessWidget {
  const MotorPolicyConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!context.isMobile) {
      return _buildDesktop(context);
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        context.go('/');
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const AppStatusBar(
          title: 'Policy Confirmed',
          showBack: false,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: AppButton(
            height: 48,
            label: 'Back to Home',
            onPressed: () => context.go('/'),
            variant: AppButtonVariant.primary,
            size: AppButtonSize.lg,
            backgroundColor: context.colors.primary,
          ),
        ),
        body: BlocConsumer<MotorInsuranceBloc, MotorInsuranceState>(
            listenWhen: (previous, current) =>
                previous.printReceiptStatus != current.printReceiptStatus ||
                previous.downloadInvoiceStatus != current.downloadInvoiceStatus,
            listener: _statusListener,
            buildWhen: (previous, current) => false,
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                child: Column(
                  children: [
                    const ResultHero(
                      tone: ResultTone.success,
                      icon: LucideIcons.check,
                      heading: "You're Covered",
                      subtitle:
                          'Your policy is now active. A confirmation email has been sent to your inbox.',
                    ),
                    const SizedBox(height: 24),
                    _mobileReceiptCard(context, state),
                  ],
                ),
              );
            }),
      ),
    );
  }

  // ── Desktop / tablet: Success ────────────────────────────────────────
  Widget _buildDesktop(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
        child: ResponsiveContainer(
          maxWidth: 760,
          child: BlocConsumer<MotorInsuranceBloc, MotorInsuranceState>(
            listenWhen: (previous, current) =>
                previous.printReceiptStatus != current.printReceiptStatus ||
                previous.downloadInvoiceStatus != current.downloadInvoiceStatus,
            listener: _statusListener,
            buildWhen: (previous, current) => false,
            builder: (context, state) {
              return Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const ResultHero(
                      tone: ResultTone.success,
                      icon: LucideIcons.check,
                      heading: "You're Covered",
                      subtitle:
                          'Your policy is now active. A confirmation email has been sent to your inbox.',
                      banner: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
                      child: Column(
                        children: [
                          SummaryCard(
                            title: 'Insurance Company Policy Receipt',
                            rows: _summaryRows(state),
                            totalValue:
                                _PolicySuccessDetails.from(state).totalAmount,
                            decorated: false,
                          ),
                          const SizedBox(height: 24),
                          _desktopActionButtons(context, state),
                          const SizedBox(height: 16),
                          AppButton(
                            text: 'Back to Home',
                            onPressed: () => context.go('/'),
                            variant: AppButtonVariant.primary,
                            size: AppButtonSize.lg,
                            backgroundColor: context.colors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static void _statusListener(BuildContext context, MotorInsuranceState state) {
    if (state.printReceiptStatus == PrintReceiptStatus.loading) {
      Snack.show(context, message: 'Printing...');
    }
    if (state.printReceiptStatus == PrintReceiptStatus.success) {
      Snack.show(context, message: 'Printed Successfully');
    }
    if (state.printReceiptStatus == PrintReceiptStatus.failure) {
      Snack.show(context, message: state.errorMessage.toString());
    }
    if (state.downloadInvoiceStatus == DownloadInvoiceStatus.loading) {
      Snack.show(context, message: 'Downloading...');
    }
    if (state.downloadInvoiceStatus == DownloadInvoiceStatus.success) {
      Snack.show(context, message: 'Downloaded Successfully');
    }
    if (state.downloadInvoiceStatus == DownloadInvoiceStatus.failure) {
      Snack.show(context, message: 'Download Failed');
    }
  }

  Widget _mobileReceiptCard(BuildContext context, MotorInsuranceState state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: SummaryCard(
              rows: _summaryRows(state),
              totalValue: _PolicySuccessDetails.from(state).totalAmount,
              decorated: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: transactionActionButton(
                    iconPath: AppAssets.iconDownloadOutline,
                    label: 'Download Policy',
                    onTap: () {
                      context.read<MotorInsuranceBloc>().add(DownloadInvoice(
                          policyId:
                              state.issuePolicyByQuoteIdResponse?.data?.id ??
                                  ''));
                    },
                  ),
                ),
                Expanded(
                  child: transactionActionButton(
                    iconPath: AppAssets.iconFileCopy,
                    label: 'Print Receipt',
                    onTap: () {
                      context.read<MotorInsuranceBloc>().add(PrintReceipt(
                          policyId:
                              state.issuePolicyByQuoteIdResponse?.data?.id ??
                                  ''));
                    },
                  ),
                ),
                Expanded(
                  child: transactionActionButton(
                    iconPath: AppAssets.iconShare,
                    label: 'Share Policy Documents',
                    enabled: false,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopActionButtons(
      BuildContext context, MotorInsuranceState state) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: 'Download Policy',
            isFullWidth: true,
            height: 44,
            radius: 24,
            variant: AppButtonVariant.outline,
            textColor: AppColors.primary,
            borderColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            onPressed: () {
              context.read<MotorInsuranceBloc>().add(DownloadInvoice(
                  policyId:
                      state.issuePolicyByQuoteIdResponse?.data?.id ?? ''));
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            text: 'Print Receipt',
            isFullWidth: true,
            height: 44,
            radius: 24,
            variant: AppButtonVariant.outline,
            textColor: AppColors.primary,
            borderColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            onPressed: () {
              context.read<MotorInsuranceBloc>().add(PrintReceipt(
                  policyId:
                      state.issuePolicyByQuoteIdResponse?.data?.id ?? ''));
            },
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: AppButton(
            text: 'Share Policy',
            isFullWidth: true,
            height: 44,
            radius: 24,
            variant: AppButtonVariant.primary,
            backgroundColor: AppColors.textMuted,
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24),
            onPressed: null,
          ),
        ),
      ],
    );
  }
}

/// Builds the receipt rows for the success screen: a row is only added when
/// its value is available, so a partial API response never leaves empty
/// gaps or placeholder text.
List<SummaryRow> _summaryRows(MotorInsuranceState state) {
  final details = _PolicySuccessDetails.from(state);
  final rows = <SummaryRow>[];
  void addRow(String label, String? value) {
    if (value == null) return;
    rows.add(SummaryRow(label, value));
  }

  addRow('Reference Number', details.referenceNumber);
  addRow('Host Reference Number', details.hostReferenceNumber);
  addRow('Policy Number', details.policyNumber);
  addRow('Coverage Period', details.coveragePeriod);
  addRow('Vehicle', details.vehicle);
  addRow('Premium Amount', details.premiumAmount);
  addRow('Transaction Fee', details.convenienceSurcharge);
  return rows;
}

/// Formats [MotorInsuranceState] into the values the success receipt needs,
/// hiding (returning null for) anything unavailable rather than showing
/// "NA"/placeholder text.
class _PolicySuccessDetails {
  const _PolicySuccessDetails({
    required this.referenceNumber,
    required this.hostReferenceNumber,
    required this.policyNumber,
    required this.coveragePeriod,
    required this.vehicle,
    required this.premiumAmount,
    required this.convenienceSurcharge,
    required this.totalAmount,
  });

  final String? referenceNumber;
  final String? hostReferenceNumber;
  final String? policyNumber;
  final String? coveragePeriod;
  final String? vehicle;
  final String? premiumAmount;
  final String? convenienceSurcharge;
  final String? totalAmount;

  factory _PolicySuccessDetails.from(MotorInsuranceState state) {
    final data = state.issuePolicyByQuoteIdResponse?.data;
    final vehicleData = state.vehicleData;
    final currency = data?.currency;

    String? money(double? amount) => amount == null
        ? null
        : '${currency ?? ''} ${amount.toStringAsFixed(2)}'.trim();

    final surcharge = (data?.gatewayCharge ?? 0) + (data?.platformCharge ?? 0);

    return _PolicySuccessDetails(
      referenceNumber: _orNull(data?.referenceNumber),
      hostReferenceNumber: _orNull(data?.hostReferenceNumber),
      policyNumber: _orNull(data?.policyNumber),
      coveragePeriod: _formatPeriod(data?.startDate, data?.endDate),
      vehicle: _formatVehicle(state.vehicleRegNo, vehicleData),
      premiumAmount: money(data?.grossPremium),
      convenienceSurcharge: surcharge > 0 ? money(surcharge) : null,
      totalAmount: money(data?.totalPayable),
    );
  }

  static String? _orNull(String? value) =>
      (value == null || value.isEmpty) ? null : value;

  static String? _formatPeriod(String? start, String? end) {
    final startDate = start == null ? null : DateTime.tryParse(start);
    final endDate = end == null ? null : DateTime.tryParse(end);
    if (startDate == null || endDate == null) return null;
    return '${_fmtDate(startDate)} - ${_fmtDate(endDate)}';
  }

  static String? _formatVehicle(String regNo, VehicleData? vehicleData) {
    final makeModel =
        '${vehicleData?.make ?? ''} ${vehicleData?.model ?? ''}'.trim();
    final parts = <String>[
      if (regNo.trim().isNotEmpty) regNo.trim(),
      if (makeModel.isNotEmpty) makeModel,
    ];
    if (parts.isEmpty) return null;
    final color = vehicleData?.color;
    final base = parts.join(' | ');
    return (color != null && color.isNotEmpty) ? '$base ($color)' : base;
  }
}

String _fmtDate(DateTime d) {
  const months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${d.day} ${months[d.month]} ${d.year}';
}
