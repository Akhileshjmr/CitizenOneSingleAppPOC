// import 'package:citizenone_app/modules/agency_banking/data/models/EstatementEntity.dart';
// import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
// import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/customer_application/customer_transaction_setails_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:citizenone_app/modules/agency_banking/data/models/CommFeeCalulation.dart';
// import 'package:citizenone_app/modules/agency_banking/data/models/login_models/UserOtpValidationInfo.dart';
// import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
// import 'package:citizenone_app/modules/agency_banking/utils/RandomNumberGenerator.dart';
// import '../../../../../data/models/CommTransactionDetails.dart';
// import '../../../../../utils/CommDateTimeUtils.dart';
// import '../../../../blocs/transaction_receipt_bloc/transaction_receipt_bloc.dart';
// import '../../../../blocs/transaction_receipt_bloc/transaction_receipt_event.dart';
// import '../../../../blocs/transaction_receipt_bloc/transaction_receipt_state.dart';
// import '../../../BaseScreen/base_screen.dart';
// import '../agent_application/transactions/download_receipt_screen.dart';
//
// class RecentTransactionDetailsScreen extends StatefulWidget
// {
//   final dynamic itemKey;
//   final String? transactionType;
//   final LoginUserReqResInfo? loginResponse;
//   final String? userType;
//   final EstatementEntity? transaction;
//   RecentTransactionDetailsScreen({this.itemKey, required this.transactionType,
//     this.loginResponse, this.userType, this.transaction});
//
//   @override
//   _RecentTransactionDetailsScreen createState() => _RecentTransactionDetailsScreen();
// }
//
// class _RecentTransactionDetailsScreen extends BaseScreenState<RecentTransactionDetailsScreen> {
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController noteController = TextEditingController();
//   final Color myHexColor = Color(0xff5c7d33);
//   String enteredAmount = "";
//   final AuthService authService = AuthService();
//   late UserOTPValidationInfo userOTPValidationInfo;
//   CommFeeCalculation response = CommFeeCalculation();
//   late String transactionPdf;
//
//
//   @override
//   void initState() {
//     super.initState();
//     print("ssss");
//     print(widget.loginResponse?.toJson());
//     amountController.addListener(() {
//       setState(() {
//         enteredAmount = amountController.text;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             color: Colors.white,
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           title: Text(
//             'Transaction Details ', // Fallback text for undefined keys
//             style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18
//             ),
//           ),
//           actions: [
//             Icon(
//               Icons.wifi, // Network icon
//               color: getNetworkIconColor(),
//             ),
//             SizedBox(width: 25),
//             IconButton(
//               icon: Icon(Icons.logout),
//               color: Colors.white,
//               onPressed: () {
//                 showLogoutDialog(context);
//               },
//             ),
//           ],
//           backgroundColor: myHexColor,
//         ),
//         body: BlocListener<TransactionReceiptBloc, TransactionReceiptState>(
//           listener: (context, state) {
//             if (state is TransactionReceiptSuccess) {
//               transactionPdf = state.transactionDetails.transactionPdf!;
//               AppLogger.debug('Transaction receipt PDF received');
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) =>
//                     DownloadReceiptScreen(transactionPdf)),
//               );
//             } else if (state is TransactionReceiptFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   backgroundColor: Colors.white,
//                   content: Text(
//                     state.error,
//                     style: TextStyle(color: Colors.black),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               );
//             }
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(3.0),
//             child: Card(
//               color: Colors.white,
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               margin: EdgeInsets.all(10),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // "Paid to" Section
//                     Text('Paid to', style: TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundColor: Colors.teal,
//                               child: Text(
//                                 widget.transaction?.cCustomerName?.substring(
//                                     0, 1) ?? 'I',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(widget.transaction?.cCustomerName ?? '',
//                                     style: TextStyle(fontSize: 16)),
//                                 Text(widget.transaction?.cMobileNo ?? '',
//                                     style: TextStyle(color: Colors.black)),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Text('ETB ${widget.transaction?.cAmount ?? ''}',
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//
//                     // Tick mark and date
//                     Row(
//                       children: [
//                         Icon(Icons.check_circle, color: Colors.green, size: 16),
//                         SizedBox(width: 5),
//                         Text(
//                           CommDateTimeUtils.formatTimestampToDateString(
//                               widget.transaction?.txtnDate) ?? 'Unknown Date',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Divider(height: 30, color: Colors.grey.shade300),
//
//                     // "Transfer Details" Section
//                     Text('Transfer Details', style: TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 8),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Transaction ID',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, color: Colors.grey),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           widget.transaction?.txnId ?? '',
//                           style: TextStyle(
//                               color: Colors.black, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//
//                     // Account Number and Currency Row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Debited from',
//                               style: TextStyle(fontWeight: FontWeight.bold,
//                                   color: Colors.grey),
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               widget.transaction?.cAccountNo != null &&
//                                   widget.transaction!.cAccountNo!.length > 4
//                                   ? 'XXXX${widget.transaction!.cAccountNo!
//                                   .substring(
//                                   widget.transaction!.cAccountNo!.length - 4)}'
//                                   : widget.transaction?.cAccountNo ?? '',
//                               style: TextStyle(color: Colors.black,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           'ETB ${widget.transaction?.cAmount ?? ''}',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                           textAlign: TextAlign.right,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//
//                     Divider(height: 30, color: Colors.grey.shade300),
//                     SizedBox(height: 5),
//
//                     // Action Buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: myHexColor),
//                           onPressed: () {
//                             CommTransactionDetails transactionDetails = CommTransactionDetails();
//                             transactionDetails.headerInfo = widget.loginResponse!.headerInfo;
//                             transactionDetails.transId = widget.transaction?.txnId;
//                             context.read<TransactionReceiptBloc>().add(
//                                 TransactionReceiptSubmitted(
//                                     transactionDetails));
//                           },
//                           child: Text('Receipt', style: TextStyle(color: Colors
//                               .white)),
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: myHexColor),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) =>
//                                   CustomerTransactionScreen(transactionType: '', itemKey: widget.itemKey,)),
//                             );
//                           },
//                           child: Text('Pay again', style: TextStyle(
//                               color: Colors.white)),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         )
//     );
//   }
// }

import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/EstatementEntity.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/customer_application/customer_transaction_setails_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/customer_application/send_money_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommFeeCalulation.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/UserOtpValidationInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../data/models/CommTransactionDetails.dart';
import '../../../../../utils/CommDateTimeUtils.dart';
import '../../../../../utils/CommSuccessDialogues.dart';
import '../../../../blocs/transaction_receipt_bloc/transaction_receipt_bloc.dart';
import '../../../../blocs/transaction_receipt_bloc/transaction_receipt_event.dart';
import '../../../../blocs/transaction_receipt_bloc/transaction_receipt_state.dart';
import '../../../BaseScreen/base_screen.dart';
import '../../../Dashboard/widgets/BankSelectionScreen.dart';
import '../agent_application/transactions/download_receipt_screen.dart';

class RecentTransactionDetailsScreen extends StatefulWidget
{
  final dynamic itemKey;
  final String? transactionType;
  final LoginUserReqResInfo? loginResponse;
  final String? userType;
  final EstatementEntity? transaction;
  final CommAccountRequest? commAccountRequest;
  final BankOption selectedBank;

  RecentTransactionDetailsScreen({this.itemKey, required this.transactionType,
    this.loginResponse, this.userType, this.transaction, this.commAccountRequest, required this.selectedBank});

  @override
  _RecentTransactionDetailsScreen createState() => _RecentTransactionDetailsScreen();
}

class _RecentTransactionDetailsScreen extends BaseScreenState<RecentTransactionDetailsScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final Color myHexColor = Color(0xff5c7d33);
  String enteredAmount = "";
  final AuthService authService = AuthService();
  late UserOTPValidationInfo userOTPValidationInfo;
  CommFeeCalculation response = CommFeeCalculation();
  late String transactionPdf;


  @override
  void initState() {
    super.initState();
    amountController.addListener(() {
      setState(() {
        enteredAmount = amountController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          title: "Transaction Details",
        ),
        body: BlocListener<TransactionReceiptBloc, TransactionReceiptState>(
          listener: (context, state) {
            if (state is TransactionReceiptSuccess) {
              transactionPdf = state.transactionDetails.transactionPdf!;
              AppLogger.debug('Transaction receipt PDF received');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    DownloadReceiptScreen(transactionPdf:transactionPdf, selectedBank: widget.selectedBank,)),
              );
            } else if (state is TransactionReceiptFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Paid to" Section
                    Text('Paid to', style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.teal,
                              child: Text(
                                widget.transaction?.cCustomerName?.substring(
                                    0, 1) ?? 'I',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.transaction?.cCustomerName ?? '',
                                    style: TextStyle(fontSize: 16)),
                                Text(widget.transaction?.cMobileNo ?? '',
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ],
                        ),
                        Text('ETB ${widget.transaction?.cAmount ?? ''}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Tick mark and date
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 5),
                        Text(
                          CommDateTimeUtils.formatTimestampToDateString(
                              widget.transaction?.txtnDate) ?? 'Unknown Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 30, color: Colors.grey.shade300),

                    // "Transfer Details" Section
                    Text('Transfer Details', style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction ID',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.transaction?.txnId ?? '',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Account Number and Currency Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Debited from',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.transaction?.cAccountNo != null &&
                                  widget.transaction!.cAccountNo!.length > 4
                                  ? 'XXXX${widget.transaction!.cAccountNo!
                                  .substring(
                                  widget.transaction!.cAccountNo!.length - 4)}'
                                  : widget.transaction?.cAccountNo ?? '',
                              style: TextStyle(color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          'ETB ${widget.transaction?.cAmount ?? ''}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    Divider(height: 30, color: Colors.grey.shade300),
                    SizedBox(height: 5),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: myHexColor),
                          onPressed: () {
                            CommTransactionDetails transactionDetails = CommTransactionDetails();
                            transactionDetails.headerInfo = widget.loginResponse!.headerInfo;
                            transactionDetails.transId = widget.transaction?.txnId;
                            context.read<TransactionReceiptBloc>().add(
                                TransactionReceiptSubmitted(
                                    transactionDetails));
                          },
                          child: Text('Receipt', style: TextStyle(color: Colors
                              .white)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: myHexColor),
                          onPressed: () {
                            if(widget.itemKey!='SM')
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    CustomerTransactionScreen(
                                      transactionType: widget.transactionType,
                                      itemKey: widget.itemKey,
                                      transaction: widget.transaction,
                                      loginResponse: widget.loginResponse,
                                      selectedBank: widget.selectedBank,
                                    )),
                              );
                            }
                            if(widget.itemKey=='SM')
                            {
                              if(widget.transactionType=='Account')
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerSendMoneyScreen(
                                            loginResponse: widget.loginResponse,
                                            commAccountRequest: widget.commAccountRequest,
                                            transactionType: 'Account',
                                            itemKey: widget.itemKey,
                                        selectedBank: widget.selectedBank,),
                                  ),
                                );
                              }
                              else
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerSendMoneyScreen(
                                            loginResponse: widget.loginResponse,
                                            transactionType: 'Wallet',
                                            itemKey: widget.itemKey,
                                        selectedBank: widget.selectedBank,),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text('Pay again', style: TextStyle(
                              color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
