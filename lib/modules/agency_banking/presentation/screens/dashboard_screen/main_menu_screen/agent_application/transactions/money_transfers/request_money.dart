import 'package:citizenone_app/modules/agency_banking/utils/CommDateTimeUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../data/models/CommRequestList.dart';
import '../../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../../../utils/RandomNumberGenerator.dart';
import '../../../../../../../utils/UICleanupHelper.dart';
import '../../../../../../blocs/receive_request_bloc/receive_request_bloc.dart';
import '../../../../../../blocs/receive_request_bloc/receive_request_event.dart';
import '../../../../../../blocs/receive_request_bloc/receive_request_state.dart';
import '../../../../../../blocs/transaction_history/transaction_history_state.dart';
import '../../../../../BaseScreen/base_screen.dart';
import '../../../../../Dashboard/widgets/BankSelectionScreen.dart';
import '../wallet_account_search_screen.dart';

class RequestMoney extends StatefulWidget {
  final dynamic itemKey;
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;
  // final String transaction;
  const RequestMoney(
      {required this.loginResponse,
        required this.itemKey,
        required this.selectedBank,
      });

  @override
  _RequestMoney createState() => _RequestMoney();
}

class _RequestMoney extends State<RequestMoney> {
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
    req.requestType="Request_Sent";
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
          title: "Request Sent",
        ),
        body: Stack(
          children: [
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
                                              "Request submitted",
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 3,),
                                            Text(
                                              "${transactions[index].requesting_toName ?? 'Unknown'} ${transactions[index].remarks ?? ''}",
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
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,

                                            ),
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
                                    child: Text(
                                      CommDateTimeUtils.formatTimestampToDateString(transactions[index].initTime) ?? 'Unknown Date',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                  if (index < transactions.length - 1) Divider(), // Divider between items
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

            // Floating Button on the Side
            Positioned(
              bottom: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WalletAccountSearch(
                        loginResponse: widget.loginResponse,
                        itemKey: widget.itemKey,
                        transactionType: 'Wallet',
                        selectedBank: widget.selectedBank,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                ),
                child: Text(
                  'Create Request',
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

