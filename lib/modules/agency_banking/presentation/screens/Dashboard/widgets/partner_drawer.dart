import 'package:citizenone_app/modules/agency_banking/data/models/CommAgentDetails.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/common_models/HeaderInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/common_models/ServerMessage.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/profile_drawer_bloc/profile_drawer_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/profile_drawer_bloc/profile_drawer_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/profile_drawer_bloc/profile_drawer_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/kyc_search_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/security/security_screen.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AESEncryption.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../theme/colors/Appcolors.dart';
import '../../../../utils/CommDialog.dart';

class PartnerDrawer extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;

  const PartnerDrawer({
    super.key,
    required this.loginResponse,
  });

  @override
  State<PartnerDrawer> createState() => _PartnerDrawerState();
}

class _PartnerDrawerState extends State<PartnerDrawer> {
  /// Neutral disclosure-chevron grey used by the expandable Settings
  /// section and its nested rows — matches the reference design, which
  /// keeps these arrows neutral rather than brand navy.
  static const Color _chevronGrey = Color(0xFF5F6063);

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  void _fetchProfile() {
    CommAgentDetails agentDetails = CommAgentDetails(
      headerInfo: HeaderInfo(),
      resMessage: ServerMessage(),
    );

    agentDetails.headerInfo = widget.loginResponse.headerInfo;

    context.read<ProfileDrawerBloc>().add(
          FetchProfileDrawerData(agentDetails),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * .86,
      backgroundColor: AppColors.kF8FAFC,
      elevation: 0,
      child: SafeArea(
        child: Column(
          children: [
            BlocBuilder<ProfileDrawerBloc, ProfileDrawerState>(
              builder: (context, state) {
                if (state is ProfileDrawerFailure) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.error,
                          style: const TextStyle(
                            color: AppColors.kEF4444,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: _fetchProfile,
                          child: const Text(
                            "Retry",
                            style: TextStyle(color: AppColors.k0D1F4D),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                String name = "";
                String phone = "";
                bool isLoading = state is ProfileDrawerLoading;

                if (state is ProfileDrawerSuccess) {
                  name = AESEncryptionService.decrypt(
                    state.agentDetails.agentName ?? "",
                  );

                  phone = AESEncryptionService.decrypt(
                    state.agentDetails.phNo ?? "",
                  );
                }

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 34,
                        backgroundColor: Color(0xffD9D9D9),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      isLoading
                          ? _buildSkeleton(width: 140, height: 18)
                          : Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.k0F0F0F,
                              ),
                            ),
                      const SizedBox(height: 8),
                      isLoading
                          ? _buildSkeleton(width: 180, height: 16)
                          : Text(
                              "User ID | $phone",
                              style: const TextStyle(
                                color: AppColors.k6C7072,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
            const Divider(
              height: 1,
              color: AppColors.kE2E4E5,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    children: [
                      // _menuRow(
                      //     icon: Icons.verified_user_outlined,
                      //     title: "KYC Verification",
                      //     onTap: () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => const KYCSearchScreen(),
                      //         ),
                      //       );
                      //     }),
                      /*const SizedBox(height: 4),
                      _stubExpansionRow(
                        icon: Icons.account_balance_wallet_outlined,
                        title: "Loans",
                      ),*/
                      const SizedBox(height: 4),
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          childrenPadding: EdgeInsets.zero,
                          iconColor: _chevronGrey,
                          collapsedIconColor: _chevronGrey,
                          leading: _circleIcon(Icons.settings_outlined),
                          title: const Text(
                            "Settings",
                            style: TextStyle(
                              color: AppColors.k0D1F4D,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          children: [
                            ListTile(
                              contentPadding:
                                  const EdgeInsets.only(left: 68, right: 18),
                              leading: const Icon(
                                Icons.shield_outlined,
                                color: AppColors.k0D1F4D,
                                size: 20,
                              ),
                              title: const Text(
                                "Security",
                                style: TextStyle(
                                  color: AppColors.k0D1F4D,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: _chevronGrey,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SecurityScreen(
                                      loginResponse: widget.loginResponse,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: _signOutRow(),
            ),
          ],
        ),
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

  /// Visual placeholder — no destination screen exists for this yet.
  Widget _stubExpansionRow({required IconData icon, required String title}) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        childrenPadding: EdgeInsets.zero,
        iconColor: _chevronGrey,
        collapsedIconColor: _chevronGrey,
        leading: _circleIcon(icon),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.k0D1F4D,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(68, 0, 18, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Coming soon",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signOutRow() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        showLogoutDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: AppColors.kFEF2F2,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout,
                color: AppColors.kEF4444,
                size: 20,
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
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        color: Color(0xffF6F7FB),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.k0D1F4D,
        size: 20,
      ),
    );
  }

  Widget _buildSkeleton({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
