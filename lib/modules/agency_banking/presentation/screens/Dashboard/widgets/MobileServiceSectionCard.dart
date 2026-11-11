import 'package:citizenone_app/modules/agency_banking/constants/ModuleCode.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/get_lov_bloc/get_lov_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/dashboard_navigation.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/models/AbTransactionName.dart';
import '../../../blocs/transaction_method_bloc/transaction_method_bloc.dart';
import '../../../blocs/transaction_method_bloc/transaction_method_event.dart';
import '../../../blocs/transaction_method_bloc/transaction_method_state.dart';
import 'BankSelectionScreen.dart';

/// A single permission-driven service item, carrying along whether its
/// *original* section was a "money" section — that flag governs whether
/// tapping it goes through TransactionMethodBloc first. Flattening multiple
/// sections into one grid must not lose this per-item routing information.
typedef ServiceItem = ({String key, String label, bool isMoneySection});

/// The 8 canonical service tiles from the mockup, each backed by a real
/// SVG/PNG in assets/web. Matched primarily by the item's permission KEY
/// (a stable ModuleCode constant) since backend display labels are
/// freeform text and can't be relied on to match exactly.
enum _TileCategory {
  openAccount,
  miniStatement,
  selfTransfer,
  thirdPartyTransfer,
  cashDeposit,
  cashWithdraw,
  loans,
  loanRepayment,
}

class _TileStyle {
  final Color background;
  final Widget Function(Color themeColor) iconBuilder;
  const _TileStyle(this.background, this.iconBuilder);
}

Widget _svgIcon(String asset, Color color) => SvgPicture.asset(
      asset,
      width: 26,
      height: 26,
      color: color,
    );

Widget _pngIcon(String asset, Color color) => Image.asset(
      asset,
      width: 26,
      height: 26,
      color: color,
    );

final Map<_TileCategory, _TileStyle> _categoryStyles = {
  _TileCategory.openAccount: _TileStyle(
    const Color(0xFFFFE0CC),
    (theme) => _svgIcon('assets/web/building.svg', Colors.black87),
  ),
  _TileCategory.miniStatement: _TileStyle(
    const Color(0xFFE3E8FA),
    (theme) => _svgIcon('assets/web/wallet.svg', AppColors.k0D1F4D),
  ),
  _TileCategory.selfTransfer: _TileStyle(
    const Color(0xFFE9E9EC),
    (theme) => _svgIcon('assets/web/refresh-cw.svg', AppColors.k0D1F4D),
  ),
  _TileCategory.thirdPartyTransfer: _TileStyle(
    const Color(0xFF2563EB),
    (theme) => _pngIcon('assets/web/arrow-left-right.png', Colors.white),
  ),
  _TileCategory.cashDeposit: _TileStyle(
    const Color(0xFFEDE9FE),
    (theme) => _svgIcon('assets/web/lock.svg', AppColors.k613AF5),
  ),
  _TileCategory.cashWithdraw: _TileStyle(
    const Color(0xFF10B981),
    (theme) => _svgIcon('assets/web/building-2.svg', Colors.white),
  ),
  _TileCategory.loans: _TileStyle(
    const Color(0xFFFDE047),
    (theme) => _pngIcon('assets/web/file.png', Colors.black87),
  ),
  _TileCategory.loanRepayment: _TileStyle(
    const Color(0xFFF59E0B),
    (theme) => _svgIcon('assets/web/credit-card.svg', Colors.white),
  ),
};

/// Backend permission KEYS are stable ModuleCode constants (e.g. 'DEP',
/// 'WDL', 'FT') — match on these first, before ever falling back to label
/// text guessing.
final Map<String, _TileCategory> _keyToCategory = {
  ModuleCode.customerCreation: _TileCategory.openAccount,
  ModuleCode.accountCreation: _TileCategory.openAccount,
  ModuleCode.balanceEnquiry: _TileCategory.miniStatement,
  ModuleCode.walletToCbs: _TileCategory.selfTransfer,
  ModuleCode.cbsToWallet: _TileCategory.selfTransfer,
  ModuleCode.fundTransfer: _TileCategory.thirdPartyTransfer,
  ModuleCode.sendMoney: _TileCategory.thirdPartyTransfer,
  ModuleCode.requestMoney: _TileCategory.thirdPartyTransfer,
  ModuleCode.receiveMoney: _TileCategory.thirdPartyTransfer,
  ModuleCode.receiveRequest: _TileCategory.thirdPartyTransfer,
  ModuleCode.domesticFt: _TileCategory.thirdPartyTransfer,
  ModuleCode.internationalFt: _TileCategory.thirdPartyTransfer,
  ModuleCode.deposit: _TileCategory.cashDeposit,
  ModuleCode.withdrawal: _TileCategory.cashWithdraw,
  ModuleCode.retailLoanApplication: _TileCategory.loans,
  ModuleCode.loanRepayment: _TileCategory.loanRepayment,
  ModuleCode.accountRepayment: _TileCategory.loanRepayment,
  ModuleCode.customerRepayment: _TileCategory.loanRepayment,
};

/// Secondary, more forgiving pass over the display label — order matters,
/// most-specific checks first, so e.g. "Loan Repayment" doesn't get caught
/// by the generic "loan" check meant for plain "Loans".
_TileCategory? _categoryFromLabel(String rawLabel) {
  final label = rawLabel.trim().toLowerCase();
  if (label.contains('open') && label.contains('account')) {
    return _TileCategory.openAccount;
  }
  if (label.contains('mini') ||
      label.contains('statement') ||
      label.contains('balance enquiry')) {
    return _TileCategory.miniStatement;
  }
  if (label.contains('self')) return _TileCategory.selfTransfer;
  if (label.contains('repayment') || label.contains('repay')) {
    return _TileCategory.loanRepayment;
  }
  if (label.contains('loan')) return _TileCategory.loans;
  if (label.contains('third') ||
      label.contains('party') ||
      label.contains('send') ||
      label.contains('transfer')) {
    return _TileCategory.thirdPartyTransfer;
  }
  if (label.contains('deposit')) return _TileCategory.cashDeposit;
  if (label.contains('withdraw')) return _TileCategory.cashWithdraw;
  return null;
}

/// Any permission item that matches neither a known key nor a keyword still
/// gets a real assets/web icon (never a legacy assets/icons fallback) so no
/// tile ever renders without an image.
final List<_TileStyle> _genericFallbackStyles = [
  _TileStyle(
    const Color(0xFFE2EFFF),
    (theme) => _svgIcon('assets/web/wallet.svg', AppColors.k0D1F4D),
  ),
  _TileStyle(
    const Color(0xFFFAEFFF),
    (theme) => _svgIcon('assets/web/refresh-cw.svg', AppColors.k0D1F4D),
  ),
  _TileStyle(
    const Color(0xFFE8F3FE),
    (theme) => _svgIcon('assets/web/building.svg', Colors.black87),
  ),
  _TileStyle(
    const Color(0xFFFEF1E7),
    (theme) => _svgIcon('assets/web/lock.svg', AppColors.k613AF5),
  ),
];

_TileStyle _resolveTileStyle(ServiceItem item, int index) {
  final category =
      _keyToCategory[item.key] ?? _categoryFromLabel(item.label);
  if (category != null) return _categoryStyles[category]!;
  return _genericFallbackStyles[index % _genericFallbackStyles.length];
}

class MobileServiceSectionCard extends StatefulWidget {
  final String sectionTitle;
  final List<ServiceItem> items;
  final LoginUserReqResInfo loginResponse;
  final CommAccountRequest commAccountRequest;
  final GetLovBloc lovBloc;
  final AuthService authService;
  final Color themeColor;
  final BankOption? selectedBank;
  final Map<String, List<String>> transactionMethods;
  final String? agentPhoneNumber;

  const MobileServiceSectionCard({
    super.key,
    required this.sectionTitle,
    required this.items,
    required this.loginResponse,
    required this.commAccountRequest,
    required this.lovBloc,
    required this.authService,
    this.themeColor = AppColors.dashboardIconColor,
    this.selectedBank,
    required this.transactionMethods,
    this.agentPhoneNumber,
  });

  @override
  State<MobileServiceSectionCard> createState() =>
      _MobileServiceSectionCardState();
}

class _MobileServiceSectionCardState extends State<MobileServiceSectionCard> {
  String? selectedItemKey;
  bool isNavigating = false;
  bool isApiCalled = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionMethodBloc, TransactionMethodState>(
        listener: (context, state) {
          if (state is TransactionMethodSuccess &&
              selectedItemKey != null &&
              isApiCalled) {
            isApiCalled = false; // ✅ reset immediately
            isNavigating = true;
            final methodList = state.transactionName.abTransactionMethod ?? [];
            final methods = methodList.map((e) => e.transmethod ?? "").toList();

            handleNavigation(
              methods,
              selectedItemKey!,
              context,
              widget.loginResponse.headerInfo.userType,
              widget.loginResponse,
              widget.commAccountRequest,
              widget.lovBloc,
              widget.authService,
              widget.selectedBank!,
              widget.agentPhoneNumber,
            );

            selectedItemKey = null; // ✅ IMPORTANT RESET
            // ✅ VERY IMPORTANT → clear bloc state
            context.read<TransactionMethodBloc>().add(ClearTransactionMethod());
          }

          if (state is TransactionMethodFailure) {
            showCustomBottomPopup(context, state.error);
          }
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.loginBackground, //Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.sectionTitle.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) {
                    const itemsPerRow = 4;
                    const spacing = 12.0;
                    final screenWidth = constraints.maxWidth;
                    final itemWidth =
                        (screenWidth - ((itemsPerRow - 1) * spacing)) /
                            itemsPerRow;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing + 6,
                      children: widget.items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final style = _resolveTileStyle(item, index);

                        return SizedBox(
                          width: itemWidth,
                          child: GestureDetector(
                            onTap: () {
                              selectedItemKey = item.key;

                              if (item.isMoneySection) {
                                isApiCalled = true; // ✅ mark API call
                                AbTransactionName request = AbTransactionName(
                                  headerInfo: widget.loginResponse.headerInfo,
                                  menuName: "Transactions",
                                  transname: item.key,
                                );

                                context
                                    .read<TransactionMethodBloc>()
                                    .add(TransactionMethodSubmitted(request));
                              } else {
                                navigateToScreen(
                                  widget.agentPhoneNumber,
                                  item.key,
                                  context,
                                  widget.loginResponse.headerInfo.userType,
                                  widget.loginResponse,
                                  widget.commAccountRequest,
                                  widget.lovBloc,
                                  widget.authService,
                                  widget.selectedBank!,
                                );
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: style.background,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: style.iconBuilder(widget.themeColor),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(item.label,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
