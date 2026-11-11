import 'package:citizenone_app/modules/agency_banking/data/models/CommAgentDetails.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/common_models/HeaderInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/common_models/ServerMessage.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/user_profile_bloc/user_profile_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/user_profile_bloc/user_profile_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/user_profile_bloc/user_profile_state.dart';
import 'package:citizenone_app/modules/agency_banking/utils/Loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../theme/colors/Appcolors.dart';
import '../../../../utils/AESEncryption.dart';
import '../../../../utils/CommDialog.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  const ProfileScreen({required this.loginResponse});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Color myHexColor = const Color(0xff5c7d33);
  bool _isSwitched = false; // Initial state of the toggle
  CommAgentDetails? agentDetailsResponse; // Variable to store API response
  late final String balanceType;
  late final String managePin;

  @override
  void initState() {
    super.initState();
    _fetchAgentDetails(); // Trigger the event to fetch data
  }

  void _fetchAgentDetails() {
    // Initialize CommAgentDetails
    CommAgentDetails agentDetails = CommAgentDetails(
      headerInfo: HeaderInfo(),
      resMessage: ServerMessage(),
    );
    agentDetails.headerInfo = widget.loginResponse.headerInfo;

    // Trigger the UserProfileSubmitted event
    context.read<UserProfileBloc>().add(
          UserProfileSubmitted(agentDetails),
        );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColorScreen,
      appBar: const CustomAppBar(
        title: "Profile",
      ),
      body: Stack(
        children: [
          BlocConsumer<UserProfileBloc, UserProfileState>(
            listener: (context, state) {
              // Show / Hide Loader
              if (state is UserProfileLoading) {
                context.read<LoadingCubit>().show();
              } else {
                context.read<LoadingCubit>().hide();
              }

              if (state is UserProfileSuccess) {
                setState(() {
                  agentDetailsResponse = state.agentDetails;
                });
              } else if (state is UserProfileFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
            builder: (context, state) {
              // Show empty widget until data is loaded
              if (agentDetailsResponse == null) {
                return const SizedBox.shrink();
              }

              return ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                children: [
                  _buildProfileHeader(context),
                  const SizedBox(height: 8),
                  _buildSecuritySection(context),
                  const SizedBox(height: 8),
                  _buildLogoutSection(context),
                ],
              );
            },
          ),

          // Global Loader
          const GlobalLoader(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 27),
      decoration: _boxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // Wrap in Expanded to avoid overflow
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  size: 70,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AESEncryptionService.decrypt(agentDetailsResponse?.agentName ?? '')}',
                        style: const TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${AESEncryptionService.decrypt(agentDetailsResponse?.phNo ?? '')}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Security",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text(
              "Change Password",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: const Text(
              "Change your app password",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(
                          loginResponse: widget.loginResponse,
                        )),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: _boxDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            const Icon(Icons.logout, size: 25, color: Colors.red),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {
                showLogoutDialog(context);
              },
              child: const Text(
                "LOGOUT",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ]),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
