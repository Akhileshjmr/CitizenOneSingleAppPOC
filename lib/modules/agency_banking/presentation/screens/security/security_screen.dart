import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors/Appcolors.dart';
import '../../responsive/breakpoints.dart';
import '../Dashboard/widgets/account_desktop_shell.dart';
import 'security_change_password_screen.dart';

class SecurityScreen extends StatelessWidget {
  final LoginUserReqResInfo loginResponse;

  const SecurityScreen({super.key, required this.loginResponse});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (Breakpoints.isDesktop(constraints.maxWidth)) {
        return _buildDesktop(context);
      }
      return _buildMobile(context,
          isTablet: Breakpoints.isTablet(constraints.maxWidth));
    });
  }

  Widget _buildDesktop(BuildContext context) {
    return AccountDesktopScaffold(
      loginResponse: loginResponse,
      activeItem: AccountNavItem.security,
      pageTitle: "Security",
      pageSubtitle: "Your Security, Our Priority.",
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.kBDBFC4),
        ),
        child: _ChangePasswordTile(loginResponse: loginResponse),
      ),
    );
  }

  Widget _buildMobile(BuildContext context, {bool isTablet = false}) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Security",
              style: TextStyle(
                color: AppColors.k0F0F0F,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "Your Security, Our Priority.",
              style: TextStyle(
                color: AppColors.k868686,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: isTablet ? 640 : double.infinity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ChangePasswordTile(loginResponse: loginResponse),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangePasswordTile extends StatelessWidget {
  final LoginUserReqResInfo loginResponse;

  const _ChangePasswordTile({required this.loginResponse});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecurityChangePasswordScreen(
              loginResponse: loginResponse,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: AppColors.kBDBFC4),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.kEEF2FF,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.lock_outline,
                color: AppColors.k1E40AF,
              ),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Change Password",
                    style: TextStyle(
                      color: AppColors.k0D1F4D,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  // SizedBox(height: 4),
                  // Text(
                  //   "Last changed 30 days ago",
                  //   style: TextStyle(
                  //     color: AppColors.k9CA3AF,
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.kFFF8E1,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "UPDATE",
                style: TextStyle(
                  color: AppColors.kF59E0B,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppColors.k868686,
            ),
          ],
        ),
      ),
    );
  }
}
