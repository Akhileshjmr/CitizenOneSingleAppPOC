import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/money_transfers/fund_transfer/account_fund_transfer.dart';
import 'package:citizenone_app/modules/agency_banking/utils/UICleanupHelper.dart';
import 'package:flutter/material.dart';
import '../../../../../../constants/ModuleCode.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../BaseScreen/base_screen.dart';
import '../../../../Dashboard/widgets/BankSelectionScreen.dart';

class TransactionTypeScreen extends StatefulWidget {
  @override
  _TransactionTypeScreenState createState() => _TransactionTypeScreenState();
  final dynamic itemKey; // Add itemKey field
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;
  const TransactionTypeScreen({super.key, required this.loginResponse, required this.itemKey, required this.selectedBank});
}

class _TransactionTypeScreenState extends State<TransactionTypeScreen> {
  final Color myHexColor = Color(0xff5c7d33);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Transaction Type",
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.account_balance_wallet,
                  color: myHexColor,
                ),
                title: Text('WALLET'),
                onTap: () {
                  if (widget.itemKey == ModuleCode.fundTransfer) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AccountFundTransfer(
                              loginResponse: widget.loginResponse,
                              itemKey: widget.itemKey,
                              transactionType: "Account",
                              selectedBank: widget.selectedBank,
                            ),
                      ),
                    );
                  }
                },
              ),
              Divider(), // Adds a separator between the two options
              ListTile(
                leading: Icon(
                  Icons.account_balance,
                  color: myHexColor,
                ),
                title: Text('ACCOUNT'),
                onTap: () {
                  if (widget.itemKey == ModuleCode.fundTransfer) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AccountFundTransfer(
                              loginResponse: widget.loginResponse,
                              itemKey: widget.itemKey,
                              transactionType: "Account",
                              selectedBank: widget.selectedBank,
                            ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
