// import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
// import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/customer_application/recent_transaction_details_screen.dart';
// import 'package:citizenone_app/modules/agency_banking/utils/CommDateTimeUtils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:citizenone_app/modules/agency_banking/data/models/AccountTransHistory.dart';
// import '../../../../../data/models/login_models/LoginUserReqResInfo.dart';
// import 'package:citizenone_app/modules/agency_banking/utils/RandomNumberGenerator.dart';
// import '../../../../blocs/transaction_history/transaction_history_bloc.dart';
// import '../../../../blocs/transaction_history/transaction_history_event.dart';
// import '../../../../blocs/transaction_history/transaction_history_state.dart';
// import '../../../BaseScreen/base_screen.dart';
// import '../agent_application/transactions/account_search_screen.dart';
// import '../agent_application/transactions/wallet_account_search_screen.dart';
//
// class TransHistory extends StatefulWidget {
//   final dynamic itemKey;
//   final LoginUserReqResInfo loginResponse;
//   final String? transactionType;
//   final CommAccountRequest? commAccountRequest;
//   const TransHistory(
//       {required this.loginResponse,
//         required this.itemKey,  this.transactionType,
//         this.commAccountRequest,
//       });
//
//   @override
//   _TransHistory createState() => _TransHistory();
// }
//
// class _TransHistory extends BaseScreenState<TransHistory> {
//   final Color primaryColor = Color(0xff5c7d33);
//
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController mobileNumberController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController remarksController = TextEditingController();
//
//   bool isSearchPerformed = false;
//
//   String txnRefNo = RandomNumberGenerator.generateId('AGB', 13);
//   @override
//   void initState() {
//     super.initState();
//     AccountTransHistory transactionHistory = AccountTransHistory();
//     if(widget.itemKey==ModuleCode.fundTransfer || widget.itemKey=='REC_PAY')
//     {
//       if(widget.transactionType=='Account')
//       {
//         transactionHistory.transMethod='ACCOUNT';
//       }
//       else{
//         transactionHistory.transMethod='WALLET';
//       }
//       if(widget.itemKey==ModuleCode.fundTransfer)
//       {
//         transactionHistory.moduleType=ModuleCode.fundTransfer;
//       }
//       if(widget.itemKey=='REC_PAY')
//       {
//         transactionHistory.moduleType="REC_PAY";
//       }
//     }
//     if(widget.itemKey==ModuleCode.corporatePayment)
//     {
//       transactionHistory.moduleType==ModuleCode.corporatePayment;
//     }
//     transactionHistory.headerInfo = widget.loginResponse.headerInfo;
//     context.read<TransactionHistoryBloc>().add(
//       TransactionHistorySubmitted(transactionHistory),
//     );
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<TransactionHistoryBloc, TransactionHistoryState>(
//       listener: (context, state) {
//         if (state is TransactionHistoryFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.error)),
//           );
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             color: Colors.white,
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           title: Text(
//             "Recent Transaction History",
//             style: TextStyle(color: Colors.white,fontSize: 18),
//           ),
//           backgroundColor: primaryColor,
//         ),
//         body: Stack(
//           children: [
//             // Transaction List
//             BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
//               builder: (context, state) {
//                 if (state is TransactionHistorySuccess) {
//                   final transactions = state.transHistory.eStatementEntities ?? [];
//
//                   return SingleChildScrollView(
//                     padding: EdgeInsets.only(right: 2, bottom: 5), // Leave space for the button
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Card(
//                           margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 for (int index = 0; index < transactions.length; index++) ...[
//                                   InkWell(
//                                     onTap: () {
//                                       // Navigate to another screen with transaction details
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => RecentTransactionDetailsScreen(
//                                             transaction: transactions[index],
//                                             transactionType: '',
//                                             loginResponse: widget.loginResponse,
//                                             itemKey: widget.itemKey,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     child: Column(
//                                       children: [
//                                         Row(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             // Circular Avatar
//                                             CircleAvatar(
//                                               backgroundColor: Colors.teal,
//                                               child: Text(
//                                                 transactions[index].cCustomerName?.substring(0, 1) ?? 'I',
//                                                 style: TextStyle(color: Colors.white),
//                                               ),
//                                             ),
//                                             SizedBox(width: 10), // Space between avatar and content
//
//                                             // Main Content
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     "Paid to ",
//                                                     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//                                                   ),
//                                                   SizedBox(height: 3),
//                                                   Text(
//                                                     "${transactions[index].cCustomerName ?? 'Unknown'} ${transactions[index].txnReason ?? ''}",
//                                                     style: TextStyle(color: Colors.black),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//
//                                             // Amount and Currency
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: [
//                                                 Text(
//                                                   transactions[index].cTxnCcy ?? 'ETB', // Currency
//                                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                                 ),
//                                                 SizedBox(width: 5), // Small space between currency and amount
//                                                 Text(
//                                                   transactions[index].dAmount?.toStringAsFixed(0) ?? '0', // Amount
//                                                   style: TextStyle(color: Colors.black),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                     SizedBox(height: 10,),
//                                     // Tick mark and date
//                                     Row(
//                                       children: [
//                                         Icon(Icons.check_circle, color: Colors.green, size: 16), // Tick mark
//                                         SizedBox(width: 5),
//                                         Text(
//                                           CommDateTimeUtils.formatTimestampToDateString(transactions[index].txnDate) ?? 'Unknown Date',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.grey[700],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                         if (index < transactions.length - 1) Divider(),
//                                       ]
//                                   ),
//                                   )
//                                 ],
//                               ],
//
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else if (state is TransactionHistoryLoading) {
//                   return Center(child: CircularProgressIndicator());
//                 } else {
//                   return Center(child: Text("No transactions found."));
//                 }
//               },
//             ),
//
//             // Floating Button on the Side
//             Positioned(
//               bottom: 16,
//               right: 16,
//               child: ElevatedButton(
//                 onPressed: () {
//                   if(widget.transactionType=='Account')
//                   {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AccountSearchScreen(
//                           loginResponse: widget.loginResponse,
//                           itemKey: widget.itemKey,
//                           transactionType: 'Account',
//                           commAccountRequest:widget.commAccountRequest, // Pass the successful response
//                         ),
//                       ),
//                     );
//                   }
//                   else
//                   {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => WalletAccountSearch(
//                           loginResponse: widget.loginResponse,
//                           itemKey: widget.itemKey,
//                           transactionType: 'Wallet',
//                         ),
//                       ),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                 ),
//                 child: Text(
//                        widget.itemKey==ModuleCode.fundTransfer ? "Fund Transfer"
//                       :widget.itemKey=='REC_PAY' ? 'Receive Payment'
//                       :widget.itemKey==ModuleCode.corporatePayment ? 'Corporate Payment'
//                       :widget.itemKey==ModuleCode.requestMoney ? 'Request Money'
//                       :"",
//                   style: TextStyle(fontSize: 13, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/customer_application/recent_transaction_details_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/customer_application/send_money_screen.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommDateTimeUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:citizenone_app/modules/agency_banking/data/models/AccountTransHistory.dart';
import 'package:citizenone_app/modules/agency_banking/utils/RandomNumberGenerator.dart';
import '../../../../../constants/ModuleCode.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../utils/CommSuccessDialogues.dart';
import '../../../../blocs/transaction_history/transaction_history_bloc.dart';
import '../../../../blocs/transaction_history/transaction_history_event.dart';
import '../../../../blocs/transaction_history/transaction_history_state.dart';
import '../../../BaseScreen/base_screen.dart';
import '../../../Dashboard/widgets/BankSelectionScreen.dart';
import '../agent_application/transactions/account_search_screen.dart';
import '../agent_application/transactions/wallet_account_search_screen.dart';

class TransHistory extends StatefulWidget {
  final dynamic itemKey;
  final LoginUserReqResInfo loginResponse;
  final String? transactionType;
  final CommAccountRequest? commAccountRequest;
  final BankOption selectedBank;

  const TransHistory({
    required this.loginResponse,
    required this.itemKey,
    this.transactionType,
    this.commAccountRequest,
    required this.selectedBank,
  });

  @override
  _TransHistory createState() => _TransHistory();
}

class _TransHistory extends BaseScreenState<TransHistory> {
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
    AppLogger.debug('TransHistory initState called');
    AccountTransHistory transactionHistory = AccountTransHistory();
    if (widget.itemKey == ModuleCode.fundTransfer ||
        widget.itemKey == 'REC_PAY' ||
        widget.itemKey == 'SM') {
      if (widget.transactionType == 'Account') {
        transactionHistory.transMethod = 'ACCOUNT';
      } else {
        transactionHistory.transMethod = 'WALLET';
      }
      if (widget.itemKey == ModuleCode.fundTransfer) {
        transactionHistory.moduleType = ModuleCode.fundTransfer;
      }
      if (widget.itemKey == 'REC_PAY') {
        transactionHistory.moduleType = "REC_PAY";
      }
      if (widget.itemKey == 'SM') {
        transactionHistory.moduleType = 'SM';
      }
    }
    if (widget.itemKey == ModuleCode.corporatePayment) {
      transactionHistory.moduleType == ModuleCode.corporatePayment;
      transactionHistory.transMethod = 'COMPLETED';
    }
    transactionHistory.headerInfo = widget.loginResponse.headerInfo;
    context.read<DashboardTransactionHistoryBloc>().add(
          TransactionHistorySubmitted(transactionHistory),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardTransactionHistoryBloc,
        TransactionHistoryState>(
      listener: (context, state) {
        if (state is TransactionHistoryFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Recent Transaction History",
        ),
        body: Stack(
          children: [
            // Transaction List
            BlocBuilder<DashboardTransactionHistoryBloc,
                TransactionHistoryState>(
              builder: (context, state) {
                if (state is TransactionHistorySuccess) {
                  final transactions =
                      state.transHistory.eStatementEntities ?? [];

                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                        right: 2, bottom: 5), // Leave space for the button
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (int index = 0;
                                    index < transactions.length;
                                    index++) ...[
                                  InkWell(
                                    onTap: () {
                                      // Navigate to another screen with transaction details
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RecentTransactionDetailsScreen(
                                            transaction: transactions[index],
                                            transactionType:
                                                widget.transactionType,
                                            loginResponse: widget.loginResponse,
                                            commAccountRequest:
                                                widget.commAccountRequest,
                                            itemKey: widget.itemKey,
                                            selectedBank: widget.selectedBank,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Circular Avatar
                                          CircleAvatar(
                                            backgroundColor: Colors.teal,
                                            child: Text(
                                              transactions[index]
                                                      .cCustomerName
                                                      ?.substring(0, 1) ??
                                                  'I',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(
                                              width:
                                                  10), // Space between avatar and content

                                          // Main Content
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Paid to ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  "${transactions[index].cCustomerName ?? 'Unknown'} ${transactions[index].txnReason ?? ''}",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Amount and Currency
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                transactions[index].dTxnCcy ??
                                                    'ETB', // Currency
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                  width:
                                                      5), // Small space between currency and amount
                                              Text(
                                                transactions[index]
                                                        .dAmount
                                                        ?.toStringAsFixed(0) ??
                                                    '0', // Amount
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      // Tick mark and date
                                      Row(
                                        children: [
                                          Icon(Icons.check_circle,
                                              color: Colors.green,
                                              size: 16), // Tick mark
                                          SizedBox(width: 5),
                                          Text(
                                            CommDateTimeUtils
                                                    .formatTimestampToDateString(
                                                        transactions[index]
                                                            .txnDate) ??
                                                'Unknown Date',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (index < transactions.length - 1)
                                        Divider(),
                                    ]),
                                  )
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
                  if (widget.itemKey == ModuleCode.corporatePayment) {
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
                  }
                  if (widget.transactionType == 'Account' &&
                      widget.itemKey != 'SM') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountSearchScreen(
                          loginResponse: widget.loginResponse,
                          itemKey: widget.itemKey,
                          transactionType: 'Account',
                          commAccountRequest: widget
                              .commAccountRequest, // Pass the successful response
                          selectedBank: widget.selectedBank,
                        ),
                      ),
                    );
                  }
                  if (widget.transactionType == 'Wallet' &&
                      widget.itemKey != 'SM') {
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
                  }
                  if (widget.transactionType == 'Account' &&
                      widget.itemKey == 'SM') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerSendMoneyScreen(
                          loginResponse: widget.loginResponse,
                          commAccountRequest: widget.commAccountRequest,
                          transactionType: 'Account',
                          itemKey: widget.itemKey,
                          selectedBank: widget.selectedBank,
                        ),
                      ),
                    );
                  }
                  if (widget.transactionType == 'Wallet' &&
                      widget.itemKey == 'SM') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerSendMoneyScreen(
                          loginResponse: widget.loginResponse,
                          commAccountRequest: widget.commAccountRequest,
                          transactionType: 'Wallet',
                          itemKey: widget.itemKey,
                          selectedBank: widget.selectedBank,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                ),
                child: Text(
                  widget.itemKey == ModuleCode.fundTransfer
                      ? "Fund Transfer"
                      : widget.itemKey == 'REC_PAY'
                          ? 'Receive Payment'
                          : widget.itemKey == ModuleCode.corporatePayment
                              ? 'Corporate Payment'
                              : widget.itemKey == ModuleCode.requestMoney
                                  ? 'Request Money'
                                  : widget.itemKey == 'SM'
                                      ? 'Send Money'
                                      : "",
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
