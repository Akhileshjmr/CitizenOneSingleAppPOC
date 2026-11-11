import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/left_menu_screen/history/transaction_history_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/left_menu_screen/profile/profile_screen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/loans_module/app/loans_module.dart';
import 'BankSelectionScreen.dart';

class CustomSidebar extends StatelessWidget {
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;

  const CustomSidebar({
    Key? key,
    required this.loginResponse,
    required this.selectedBank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: selectedBank.logoPath != null
                ? Image.asset(selectedBank.logoPath!, height: 40)
                : const Icon(Icons.account_balance,
                    size: 40, color: AppColors.k613AF5),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                _menuItem(
                  icon: Icons.home_outlined,
                  title: "Home",
                  selected: true,
                  onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
                ),
                _menuItem(
                  icon: Icons.account_circle_outlined,
                  title: "Profile",
                  selected: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          loginResponse: loginResponse,
                        ),
                      ),
                    );
                  },
                ),
                _menuItem(
                  icon: Icons.history,
                  title: "History",
                  selected: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(
                          loginResponse: loginResponse,
                          selectedBank: selectedBank,
                        ),
                      ),
                    );
                  },
                ),
                _menuItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: "Loans",
                  selected: false,
                  onTap: () {
                    LoansModule.openPlHistoryByAgentPhone(
                      phoneNumber:
                          (loginResponse.loginUserInfo.mobileno ?? '')
                              .toString(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: selected ? AppColors.k613AF5 : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: selected ? Colors.white : Colors.grey.shade700,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (selected)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFB923C),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
