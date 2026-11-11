import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/get_lov_bloc/get_lov_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/WebBalanceCard.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/WebServiceSectionCard.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/WebSpecialOfferCard.dart';
import 'package:flutter/material.dart';

import 'BankSelectionScreen.dart';

class WebDashboardLayout extends StatelessWidget {
  final LoginUserReqResInfo loginResponse;
  final CommAccountRequest commAccountRequest;
  final GetLovBloc lovBloc;
  final AuthService authService;
  final List<dynamic> transactions; // recent transfers list
  final Widget Function(List<dynamic>) recentTransfersSection; // builder
  final BankOption? selectedBank;

  const WebDashboardLayout({
    Key? key,
    required this.loginResponse,
    required this.commAccountRequest,
    required this.lovBloc,
    required this.authService,
    required this.transactions,
    required this.recentTransfersSection,
    this.selectedBank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Total Available Balance
        WebBalanceCard(
          loginResponse: loginResponse,
          selectedBank: selectedBank,
        ),

        const SizedBox(height: 20),

        /// Services + Recent Transactions
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: WebServiceSectionCard(
                permission: loginResponse.loginUserInfo.permission,
                loginResponse: loginResponse,
                commAccountRequest: commAccountRequest,
                lovBloc: lovBloc,
                authService: authService,
                selectedBank: selectedBank,
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  recentTransfersSection(transactions), // use builder
                  WebSpecialOfferCard(loginResponse: loginResponse),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
