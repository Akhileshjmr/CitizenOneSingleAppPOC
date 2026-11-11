import 'package:citizenone_app/modules/agency_banking/data/models/CommRequestList.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../constants/ModuleCode.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../data/models/CommRequestMoney.dart';
import '../../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../../../utils/CommDateTimeUtils.dart';
import '../../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../../../utils/RandomNumberGenerator.dart';
import '../../../../../../../utils/UICleanupHelper.dart';
import '../../../../../../blocs/receive_request_bloc/receive_request_bloc.dart';
import '../../../../../../blocs/receive_request_bloc/receive_request_event.dart';
import '../../../../../../blocs/receive_request_bloc/receive_request_state.dart';
import '../../../../../../blocs/request_money_bloc/request_money_bloc.dart';
import '../../../../../../blocs/request_money_bloc/request_money_event.dart';
import '../../../../../../blocs/transaction_history/transaction_history_state.dart';
import '../../../../../BaseScreen/base_screen.dart';
import '../transaction_details_screen.dart';

class ReceiveRequest extends StatefulWidget {
  final dynamic itemKey;
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;
  // final String transaction;
  const ReceiveRequest(
      {required this.loginResponse,
        required this.itemKey,
        required this.selectedBank,
      });

  @override
  _ReceiveRequest createState() => _ReceiveRequest();
}

class _ReceiveRequest extends State<ReceiveRequest> {
  final Color primaryColor = Color(0xff5c7d33);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  bool isSearchPerformed = false;

  String txnRefNo = RandomNumberGenerator.generateId('AGB', 13);
  @override
  void initState() {
    super.initState();

    CommRequestList req=CommRequestList();
    req.headerInfo= widget.loginResponse.headerInfo;
    req.requestType="Request_Received";
    req.mobilenumber=widget.loginResponse.headerInfo.userName;
    context.read<ReceiveRequestBloc>().add(
      ReceiveRequestSubmitted(req),
    );


  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<ReceiveRequestBloc, ReceiveRequestState>(
      listener: (context, state) {
        if (state is ReceiveRequestFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Request Received",
        ),
        body: Stack(
          children: [
            // Transaction List
            BlocBuilder<ReceiveRequestBloc, ReceiveRequestState>(
              builder: (context, state) {
                if (state is ReceiveRequestSuccess) {

                  final transactions = state.receiveRequest.requestlist?? [];

                  return SingleChildScrollView(
                    padding: EdgeInsets.only(right: 2, bottom: 5), // Leave space for the button
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 4,
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (int index = 0; index < transactions.length; index++) ...[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Circular Avatar
                                      CircleAvatar(
                                        backgroundColor: Colors.teal,
                                        child: Text(
                                          transactions[index].requesterName?.substring(0, 1) ?? 'I',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 10), // Space between avatar and content
                                      // Main Content
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              transactions[index].status == "REQUEST_SUBMIT"
                                                  ? "Requesting From "
                                                  : transactions[index].status == "COMPLETED"
                                                  ? "Paid to "
                                                  : transactions[index].status == "DECLINED"
                                                  ? "Payment Declined "
                                                  : "",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17
                                              ),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              transactions[index].requesterName ?? 'Unknown',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Amount and Currency
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            transactions[index].currency ?? 'ETB',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            transactions[index].reqAmount?.toStringAsFixed(0) ?? '0',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Date Below Avatar
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0, top: 10.0), // Align with avatar
                                    child: Row(
                                      children: [
                                        // Conditional Icon based on the status
                                        if (transactions[index].status == "COMPLETED") ...[
                                          Icon(
                                            Icons.check_circle_sharp, // Green tick icon
                                            color: Colors.green,
                                            size: 16,
                                          ),
                                        ] else if (transactions[index].status == "DECLINED") ...[
                                          Icon(
                                            Icons.block, // Block symbol icon
                                            color: Colors.black,
                                            size: 16,
                                          ),
                                        ],
                                        SizedBox(width: 5), // Space between icon and date text
                                        // Date Text
                                        Text(
                                          CommDateTimeUtils.formatTimestampToDateString(transactions[index].initTime) ?? 'Unknown Date',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  // Action Buttons
                                  // Action Buttons
                                  if (transactions[index].status != "COMPLETED" && transactions[index].status != "DECLINED") ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment if needed
                                      children: [
                                        SizedBox(
                                          width: 100, // Width of the Decline button
                                          height: 40, // Height of the Decline button
                                          child: ElevatedButton(
                                            onPressed: () {
                                              CommRequestMoney requestMoney=CommRequestMoney();
                                              requestMoney.headerInfo=widget.loginResponse.headerInfo;
                                              requestMoney.reqAmount=transactions[index].reqAmount;
                                              requestMoney.operation="DECLINE_REQ";
                                              requestMoney.txntype=ModuleCode.requestMoney;
                                              requestMoney.requesterMob=transactions[index].requesterMob;
                                              requestMoney.requesterName=transactions[index].requesterName;
                                              requestMoney.requesting_toMob=transactions[index].requesting_toMob;
                                              requestMoney.requesting_toName=transactions[index].requesting_toName;
                                              requestMoney.requestId=transactions[index].requestId;
                                              requestMoney.usertype=widget.loginResponse.headerInfo.userType;
                                              context.read<RequestMoneyBloc>().add(
                                                  RequestMoneySubmitted(requestMoney));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              side: BorderSide(color: AppColors.black),
                                            ),
                                            child: Text(
                                              "Decline",
                                              style: TextStyle(color: AppColors.fbLiteDark, fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10), // Spacing between the buttons
                                        SizedBox(
                                          width: 80, // Width of the Pay button
                                          height: 40, // Height of the Pay button
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TransactionScreen(
                                                    loginResponse: widget.loginResponse,
                                                    itemKey: widget.itemKey,
                                                    transactionType: 'Wallet',
                                                    requestList: transactions[index],
                                                    selectedBank: widget.selectedBank,
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.fbLiteDark,
                                            ),
                                            child: Text(
                                              "Pay",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                  if (index < transactions.length - 1) Divider(), // Divider between items
                                  SizedBox(height: 10,),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is TransactionHistoryLoading) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Center(child: Text("No transactions found."));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
