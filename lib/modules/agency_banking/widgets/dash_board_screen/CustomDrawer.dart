import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:citizenone_app/modules/loans_module/app/loans_module.dart';

import '../../core/widgets/BackgroundComponent.dart';
import '../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import '../../presentation/screens/left_menu_screen/history/transaction_history_screen.dart';
import '../../presentation/screens/left_menu_screen/profile/profile_screen.dart';
import '../../theme/app_gradients.dart';
import '../../theme/colors/Appcolors.dart';
import '../../utils/CommDialog.dart';

class CustomDrawer extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;

  const CustomDrawer({
    super.key,
    required this.loginResponse,
    required this.selectedBank,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.zero,
        bottomRight: Radius.zero,
      ),
      child: Drawer(
        backgroundColor: AppColors.kF8FAFC,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 140,
                decoration: AppBackgrounds.screenBackground(),
                child: Builder(
                  builder: (context) {
                    final logoBytes = widget.selectedBank.logoBytes;

                    if (logoBytes != null && logoBytes.isNotEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.memory(
                            logoBytes,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }

                    return const Center(
                      child: Icon(
                        Icons.account_balance,
                        size: 50,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: Column(
                      children: [
                        _buildMenuCard(
                          children: [
                            _menuRow(
                              icon: Icons.person_outline,
                              title: "Profile",
                              onTap: () {
                                Navigator.pop(context);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      loginResponse: widget.loginResponse,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1, color: AppColors.kE2E4E5),
                            _menuRow(
                              icon: Icons.history,
                              title: "History",
                              onTap: () {
                                Navigator.pop(context);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HistoryScreen(
                                      loginResponse: widget.loginResponse,
                                      selectedBank: widget.selectedBank,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1, color: AppColors.kE2E4E5),
                            _loansExpansionTile(),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildMenuCard(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                showLogoutDialog(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 48,
                                      width: 48,
                                      decoration: const BoxDecoration(
                                        color: AppColors.kFEF2F2,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.logout,
                                        color: AppColors.kEF4444,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      "Sign Out",
                                      style: TextStyle(
                                        color: AppColors.kEF4444,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({required List<Widget> children}) {
    return SizedBox(
      width: double.infinity,
      child: Backgroundcomponent(
        child: Column(children: children),
      ),
    );
  }

  Widget _menuRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            _circleIcon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.k0D1F4D,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loansExpansionTile() {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        childrenPadding: EdgeInsets.zero,
        iconColor: AppColors.k0D1F4D,
        collapsedIconColor: Colors.grey,
        leading: _circleIcon(Icons.account_balance_wallet_outlined),
        title: const Text(
          "Loans",
          style: TextStyle(
            color: AppColors.k0D1F4D,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        children: [
          _loanMenuItem(
            leadingIcon: "assets/icons/loans/personal_loan.svg",
            title: 'Personal Loan',
            onTap: () {
              Navigator.pop(context);

              LoansModule.openPlHistoryByAgentPhone(
                  phoneNumber:
                      (widget.loginResponse.loginUserInfo.mobileno ?? '')
                          .toString());
            },
          ),
          _loanMenuItem(
            leadingIcon: "assets/icons/loans/credit_cards.svg",
            title: 'Credit Cards',
            onTap: () {
              _showFeatureUnavailableScreen();
            },
          ),
          _loanMenuItem(
            leadingIcon: "assets/icons/loans/auto_loan.svg",
            title: 'Auto Loan',
            onTap: () {
              _showFeatureUnavailableScreen();
            },
          ),
          _loanMenuItem(
            leadingIcon: "assets/icons/loans/home_loan.svg",
            title: 'Home Loan',
            onTap: () {
              _showFeatureUnavailableScreen();
            },
          ),
          _loanMenuItem(
            leadingIcon: "assets/icons/loans/pre_approved.svg",
            title: 'Pre-approved Loans',
            onTap: () {
              _showFeatureUnavailableScreen();
            },
          ),
        ],
      ),
    );
  }

  Widget _loanMenuItem({
    required String leadingIcon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(
        left: 28,
        right: 18,
      ),
      leading: SvgPicture.asset(
        leadingIcon,
        height: 22,
        width: 22,
        colorFilter: const ColorFilter.mode(
          AppColors.k0D1F4D,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.k0D1F4D,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      height: 48,
      width: 48,
      decoration: const BoxDecoration(
        color: Color(0xffF6F7FB),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.k0D1F4D,
        size: 24,
      ),
    );
  }

  void _showFeatureUnavailableScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
          ),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 100,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Feature Unavailable',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This feature is not available at the moment.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ),
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
