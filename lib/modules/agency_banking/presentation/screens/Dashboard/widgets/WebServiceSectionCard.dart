import 'package:citizenone_app/modules/agency_banking/constants/ModuleCode.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/get_lov_bloc/get_lov_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../data/models/login_models/LoginUserReqResInfo.dart';
import 'BankSelectionScreen.dart';
import 'dashboard_navigation.dart';

/// A single permission-driven service item, kept web-local (deliberately not
/// shared with the mobile grid) so the two platforms never risk cross-
/// contamination when either is redesigned.
typedef _WebServiceItem = ({String key, String label});

/// The 8 canonical service tiles from the web mockup, each backed by a real
/// SVG/PNG in assets/web. Matched primarily by the item's permission KEY
/// (a stable ModuleCode constant) since backend display labels are freeform
/// text and can't be relied on to match exactly.
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
  final Widget Function() iconBuilder;
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
    () => _svgIcon('assets/web/building.svg', Colors.black87),
  ),
  _TileCategory.miniStatement: _TileStyle(
    const Color(0xFFE3E8FA),
    () => _svgIcon('assets/web/wallet.svg', AppColors.k0D1F4D),
  ),
  _TileCategory.selfTransfer: _TileStyle(
    const Color(0xFFE9E9EC),
    () => _svgIcon('assets/web/refresh-cw.svg', AppColors.k0D1F4D),
  ),
  _TileCategory.thirdPartyTransfer: _TileStyle(
    const Color(0xFF2563EB),
    () => _pngIcon('assets/web/arrow-left-right.png', Colors.white),
  ),
  _TileCategory.cashDeposit: _TileStyle(
    const Color(0xFFEDE9FE),
    () => _svgIcon('assets/web/lock.svg', AppColors.k613AF5),
  ),
  _TileCategory.cashWithdraw: _TileStyle(
    const Color(0xFF10B981),
    () => _svgIcon('assets/web/building-2.svg', Colors.white),
  ),
  _TileCategory.loans: _TileStyle(
    const Color(0xFFFDE047),
    () => _pngIcon('assets/web/file.png', Colors.black87),
  ),
  _TileCategory.loanRepayment: _TileStyle(
    const Color(0xFFF59E0B),
    () => _svgIcon('assets/web/credit-card.svg', Colors.white),
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
/// gets a real assets/web icon so no tile ever renders without an image.
final List<_TileStyle> _genericFallbackStyles = [
  _TileStyle(
    const Color(0xFFE2EFFF),
    () => _svgIcon('assets/web/wallet.svg', AppColors.k0D1F4D),
  ),
  _TileStyle(
    const Color(0xFFFAEFFF),
    () => _svgIcon('assets/web/refresh-cw.svg', AppColors.k0D1F4D),
  ),
  _TileStyle(
    const Color(0xFFE8F3FE),
    () => _svgIcon('assets/web/building.svg', Colors.black87),
  ),
  _TileStyle(
    const Color(0xFFFEF1E7),
    () => _svgIcon('assets/web/lock.svg', AppColors.k613AF5),
  ),
];

_TileStyle _resolveTileStyle(_WebServiceItem item, int index) {
  final category = _keyToCategory[item.key] ?? _categoryFromLabel(item.label);
  if (category != null) return _categoryStyles[category]!;
  return _genericFallbackStyles[index % _genericFallbackStyles.length];
}

class WebServiceSectionCard extends StatelessWidget {
  final Map<String, dynamic>? permission;
  final LoginUserReqResInfo loginResponse;
  final CommAccountRequest commAccountRequest;
  final GetLovBloc lovBloc;
  final AuthService authService;
  final BankOption? selectedBank;

  const WebServiceSectionCard({
    Key? key,
    required this.permission,
    required this.loginResponse,
    required this.commAccountRequest,
    required this.lovBloc,
    required this.authService,
    this.selectedBank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> permissionGiven =
        Map<String, dynamic>.from(permission ?? {})..remove('MAIN_MENU');

    // Driven by every section actually granted in permissionGiven.
    final items = permissionGiven.keys.expand((sectionKey) {
      final sectionValue = permissionGiven[sectionKey];
      if (sectionValue is! Map) return <_WebServiceItem>[];
      final sectionItems = Map<String, dynamic>.from(sectionValue);
      return sectionItems.entries.map(
        (item) => (key: item.key, label: item.value.toString()),
      );
    }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "EXPLORE SERVICES",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text("No services available"),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                const itemsPerRow = 4;
                const spacing = 16.0;
                final itemWidth =
                    (constraints.maxWidth - ((itemsPerRow - 1) * spacing)) /
                        itemsPerRow;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing + 6,
                  children: items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final style = _resolveTileStyle(item, index);

                    return SizedBox(
                      width: itemWidth,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => navigateToScreen(
                          "",
                          item.key,
                          context,
                          loginResponse.headerInfo.userType,
                          loginResponse,
                          commAccountRequest,
                          lovBloc,
                          authService,
                          selectedBank!,
                        ),
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
                              child: Center(child: style.iconBuilder()),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.label,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black87),
                            ),
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
    );
  }
}
