import 'package:citizenone_app/modules/agency_banking/core/widgets/app_avatar.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/custom_app_bar.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommAgentDetails.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/common_models/HeaderInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/common_models/ServerMessage.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/user_profile_bloc/user_profile_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/user_profile_bloc/user_profile_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/user_profile_bloc/user_profile_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/breakpoints.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/account_desktop_shell.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AESEncryption.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Newer profile screen matching the latest design reference, added
/// alongside [ProfileScreen] rather than replacing it.
class ProfileV2Screen extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  const ProfileV2Screen({super.key, required this.loginResponse});

  @override
  State<ProfileV2Screen> createState() => _ProfileV2ScreenState();
}

class _ProfileV2ScreenState extends State<ProfileV2Screen> {
  CommAgentDetails? agentDetailsResponse;

  @override
  void initState() {
    super.initState();
    _fetchAgentDetails();
  }

  void _fetchAgentDetails() {
    CommAgentDetails agentDetails = CommAgentDetails(
      headerInfo: HeaderInfo(),
      resMessage: ServerMessage(),
    );
    agentDetails.headerInfo = widget.loginResponse.headerInfo;

    context.read<UserProfileBloc>().add(
          UserProfileSubmitted(agentDetails),
        );
  }

  String get _agentName =>
      AESEncryptionService.decrypt(agentDetailsResponse?.agentName ?? '');

  String get _userId =>
      AESEncryptionService.decrypt(agentDetailsResponse?.phNo ?? '');

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileSuccess) {
          setState(() {
            agentDetailsResponse = state.agentDetails;
          });
        } else if (state is UserProfileFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      builder: (context, state) {
        final bool isLoading =
            state is UserProfileLoading || agentDetailsResponse == null;

        return LayoutBuilder(builder: (context, constraints) {
          final double width = constraints.maxWidth;

          if (Breakpoints.isDesktop(width)) {
            return _buildDesktop(isLoading);
          }

          return _buildMobile(
            isLoading,
            isTablet: Breakpoints.isTablet(width),
          );
        });
      },
    );
  }

  Widget _buildDesktop(bool isLoading) {
    return AccountDesktopScaffold(
      loginResponse: widget.loginResponse,
      activeItem: AccountNavItem.profile,
      pageTitle: "Profile",
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Center(child: CircularProgressIndicator()),
            )
          : _ProfileCard(name: _agentName, userId: _userId),
    );
  }

  Widget _buildMobile(bool isLoading, {bool isTablet = false}) {
    return Scaffold(
      backgroundColor: AppColors.bgColorScreen,
      appBar: const CustomAppBar(title: "Profile"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 20,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isTablet ? 640 : 480),
                  child: _ProfileCard(name: _agentName, userId: _userId),
                ),
              ),
            ),
    );
  }
}

/// Centered avatar + name + user-id card, matching the profile card from
/// the design reference (rounded corners, thin border, no shadow).
class _ProfileCard extends StatelessWidget {
  final String name;
  final String userId;

  const _ProfileCard({required this.name, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kBDBFC4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppAvatar(size: 84),
          const SizedBox(height: 16),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.k0F0F0F,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "User ID | $userId",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.k6C7072,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
