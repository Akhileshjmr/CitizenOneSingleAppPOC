import 'package:citizenone_app/modules/agency_banking/data/models/AbQueryLoanDetails.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/loan_services/pay_by_account_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/loan_services/pay_by_cash_screen.dart';
import 'package:citizenone_app/modules/agency_banking/utils/UICleanupHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../blocs/get_loan_account_details/loan_account_details_bloc.dart';
import '../../../../../../blocs/get_loan_account_details/loan_account_details_event.dart';
import '../../../../../../blocs/get_loan_account_details/loan_account_details_state.dart';
import '../../../../../BaseScreen/base_screen.dart';


class LoanRepaymentScreen extends StatefulWidget {
  final String transactionType;
  final LoginUserReqResInfo loginResponse;
  final dynamic itemKey;
  const LoanRepaymentScreen({required this.transactionType, required this.loginResponse, this.itemKey});

  @override
  _LoanRepaymentScreenState createState() => _LoanRepaymentScreenState();
}

class _LoanRepaymentScreenState extends State<LoanRepaymentScreen> {
  final Color myHexColor = Color(0xff5c7d33);
  final TextEditingController accountController = TextEditingController();
  String? accountNumber;
  String? customerName;
  String? customerId;
  late AbQueryLoanDetails loanSearchResponse;

  void searchLoanAccount() {
    AbQueryLoanDetails abQueryLoanDetails=AbQueryLoanDetails();
    abQueryLoanDetails.headerInfo=widget.loginResponse.headerInfo;
    abQueryLoanDetails.laonAccNum=accountController.text;
    context.read<LoanAccountDetailsBloc>().add(LoanAccountDetailsSubmitted(abQueryLoanDetails));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: "Loan Repayment",
        ),
        body: BlocListener<LoanAccountDetailsBloc, LoanAccountDetailsState>(
            listener: (context, state) {
              if (state is LoanAccountDetailsSuccess) {
                setState(() {
                  loanSearchResponse=state.loanDetails;
                  accountNumber = state.loanDetails.laonAccNum ?? '';
                  customerName = state.loanDetails.loanDetResp?.customerName ?? '';
                  customerId = state.loanDetails.loanDetResp?.custId ?? '';
                });
              } else if (state is LoanAccountDetailsFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Loan account not found.")),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 2,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Search input field section
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: accountController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      border: InputBorder.none,
                                      hintText: 'Enter Loan Account Number',
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  width: 1.5,
                                  color: Colors.black,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                ),
                                IconButton(
                                  icon: Icon(Icons.search, color: Colors.black),
                                  onPressed: searchLoanAccount,
                                ),
                              ],
                            ),
                          ),

                          // Conditionally display details after search
                          if (accountNumber != null) ...[
                            SizedBox(height: 16),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  child: Text(
                                    customerName != null &&
                                        customerName!.isNotEmpty
                                        ? customerName![0]
                                        : '',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  backgroundColor: Colors.teal,
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customerName ?? '',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      accountNumber ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      customerId ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Conditionally display buttons after search outside the card
                  if (accountNumber != null) ...[
                    SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 250,  // Set a fixed width for both buttons
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => PayByCashScreen(isWallet: widget.transactionType == 'Wallet',
                                //       loanSearchResponse:loanSearchResponse,
                                //       loginResponse: widget.loginResponse,
                                //       itemKey:widget.itemKey,
                                //     ),
                                //   ),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: myHexColor,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                'Pay By Cash',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: 250,  // Use the same width to maintain consistency
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PayByAccountScreen(transactionType: widget.transactionType,
                                        loanSearchResponse:loanSearchResponse,
                                        loginResponse: widget.loginResponse, itemKey: widget.itemKey),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: myHexColor,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                widget.transactionType == 'Account' ? 'Pay By Account'
                                    : 'Pay By Wallet Account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            )
        )
    );
  }
}