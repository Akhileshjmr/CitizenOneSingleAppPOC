import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/CustomSidebar.dart';
import 'package:flutter/material.dart';

import 'BankSelectionScreen.dart';

class CustomDrawer extends StatelessWidget {
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;

  const CustomDrawer({
    Key? key,
    required this.loginResponse, required this.selectedBank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: CustomSidebar(loginResponse: loginResponse, selectedBank: selectedBank,),
    );
  }
}
