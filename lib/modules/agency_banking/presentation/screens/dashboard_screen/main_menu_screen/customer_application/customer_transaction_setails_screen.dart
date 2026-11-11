// import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletAccountRequest.dart';
// import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
// import 'package:flutter/material.dart';
// import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
// import 'package:citizenone_app/modules/agency_banking/data/models/CommFeeCalulation.dart';
// import '../../../../../data/models/login_models/UserOtpValidationInfo.dart';
// import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
// import 'package:citizenone_app/modules/agency_banking/utils/RandomNumberGenerator.dart';
// import '../../../BaseScreen/base_screen.dart';
// import 'customer_authentication_screen.dart';
//
// class CustomerTransactionScreen extends StatefulWidget {
//   final CommWalletAccountRequest? commWalletAccountRequest;
//   final CommAccountRequest? commAccountRequest;
//   final dynamic itemKey;
//   final String transactionType;
//   final LoginUserReqResInfo? loginResponse;
//   final CommAccountRequest? searchResponse;
//   final String? userType;
//   CustomerTransactionScreen({this.commWalletAccountRequest,this.commAccountRequest, this.itemKey, required this.transactionType,
//     this.loginResponse, this.searchResponse, this.userType});
//
//   @override
//   CustomerTransactionScreenState createState() => CustomerTransactionScreenState();
// }
// class CustomerTransactionScreenState extends BaseScreenState<CustomerTransactionScreen> {
//   late String mobileNumber ;
//   late String initial;
//   late String customerName;
//   late String accountNumber;
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController noteController = TextEditingController();
//   final Color myHexColor = Color(0xff5c7d33);
//   String enteredAmount = "";
//   final AuthService authService = AuthService();
//   late UserOTPValidationInfo userOTPValidationInfo;
//   CommFeeCalculation response = CommFeeCalculation();
//   String txnRefNo = RandomNumberGenerator.generateId('AGB', 13);
//
//   @override
//   void initState() {
//     super.initState();
//     amountController.addListener(() {
//       setState(() {
//         enteredAmount = amountController.text;
//       });
//     });
//     print('pppppppppp');
//     print(widget.itemKey);
//
//     if(widget.itemKey==ModuleCode.walletToCbs)
//     {
//       initial = ((widget.commAccountRequest?.customerName.isNotEmpty ?? false)
//           ? widget.commAccountRequest!.customerName.substring(0, 1).toUpperCase()
//           : '');
//       customerName =widget.commAccountRequest?.customerName ??
//           'Unknown Customer';
//
//       mobileNumber = widget.commAccountRequest?.mobileno ??
//           'Unknown Mobile';
//
//       accountNumber = widget.commAccountRequest?.accountNum ??
//           'Unknown Account';
//     }
//     else if(widget.itemKey==ModuleCode.cbsToWallet)
//     {
//       initial = ((widget.loginResponse?.loginUserInfo.firstName.isNotEmpty ?? false)
//           ? widget.loginResponse!.loginUserInfo.firstName.substring(0, 1).toUpperCase()
//           : '');
//       customerName =widget.loginResponse?.loginUserInfo.firstName ??
//           'Unknown Customer';
//       mobileNumber = widget.loginResponse?.headerInfo.userName ??
//           'Unknown Mobile';
//       accountNumber = widget.loginResponse?.headerInfo.wallet_account_no ??
//           'Unknown Account';
//     }
//     else if(widget.itemKey == ModuleCode.fundTransfer || widget.itemKey=='REC_PAY')
//     {
//       if(widget.transactionType=='Account')
//       {
//         initial = ((widget.searchResponse?.customerName.isNotEmpty ?? false)
//             ? widget.searchResponse!.customerName.substring(0, 1).toUpperCase()
//             : '');
//         customerName =widget.searchResponse?.customerName ??
//             'Unknown Customer';
//         mobileNumber = widget.searchResponse?.mobileno ??
//             'Unknown Mobile';
//         accountNumber = widget.searchResponse?.accountNum ??
//             'Unknown Account';
//       }
//       if(widget.transactionType=='Wallet')
//       {
//         initial = ((widget.commWalletAccountRequest?.customerName.isNotEmpty ?? false)
//             ? widget.commWalletAccountRequest!.customerName.substring(0, 1).toUpperCase()
//             : '');
//         customerName =widget.commWalletAccountRequest?.customerName ??
//             'Unknown Customer';
//         mobileNumber = widget.commWalletAccountRequest?.mobileno ??
//             'Unknown Mobile';
//         accountNumber = widget.commWalletAccountRequest?.accountNum ??
//             'Unknown Account';
//       }
//     }
//     if(widget.itemKey==ModuleCode.corporatePayment)
//     {
//       initial = ((widget.commWalletAccountRequest?.customerName.isNotEmpty ?? false)
//           ? widget.commWalletAccountRequest!.customerName.substring(0, 1).toUpperCase()
//           : '');
//       customerName =widget.commWalletAccountRequest?.customerName ??
//           'Unknown Customer';
//       mobileNumber = widget.commWalletAccountRequest?.mobileno ??
//           'Unknown Mobile';
//       accountNumber = widget.commWalletAccountRequest?.accountNum ??
//           'Unknown Account';
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           color: Colors.white,
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           widget.itemKey ==  ModuleCode.walletToCbs
//               ? "Wallet to Account Money Transfer "
//               : widget.itemKey == ModuleCode.cbsToWallet
//               ? "Account to Wallet Money Transfer"
//               : widget.itemKey == ModuleCode.fundTransfer
//               ? "Fund Transfer"
//               : widget.itemKey == ModuleCode.corporatePayment
//               ? "Corporate Payment"
//               : "", // Fallback text for undefined keys
//           style: const TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           Icon(
//             Icons.wifi, // Network icon
//             color: getNetworkIconColor(),
//           ),
//           SizedBox(width: 25),
//           IconButton(
//             icon: Icon(Icons.logout),
//             color: Colors.white,
//             onPressed: () {
//               showLogoutDialog(context);
//             },
//           ),
//         ],
//         backgroundColor: myHexColor,
//       ),
//       body: Padding(
//           padding: const EdgeInsets.all(5.0),
//           child:Column(
//               children: [
//                 Card(
//                   color: Colors.white,
//                   elevation: 4, // Adds shadow to give depth
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12), // Rounded corners
//                   ), // Add horizontal margin
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundColor: Colors.teal,
//                               radius: 20,
//                               child: Text(
//                                 initial,
//                                 style: const TextStyle(color: Colors.white, fontSize: 20),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   customerName,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     // Bold text for emphasis
//                                   ),
//                                 ),
//                                 if (widget.itemKey != ModuleCode.requestMoney)
//                                   Text(
//                                     accountNumber.length > 4
//                                         ? 'XXXX' + accountNumber.substring(
//                                         accountNumber.length - 4)
//                                         : accountNumber ?? "",
//                                     style: const TextStyle(fontSize: 15, color: Colors.black),
//                                   ),
//                                 const SizedBox(height: 5),
//                                 Text(
//                                   mobileNumber,
//                                   style: TextStyle(fontSize: 15, color: Colors.black),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: myHexColor,
//                               width: 2.0,
//                             ),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: TextField(
//                                     controller: amountController,
//                                     keyboardType: TextInputType.number,
//                                     decoration: const InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'Enter Amount',
//                                     ),
//                                     enabled: widget.itemKey != ModuleCode.receiveRequest, // Disable editing for RECV_REQ
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: myHexColor),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: TextFormField(
//                             controller: noteController,
//                             decoration: InputDecoration(
//                               labelText: 'Add a note',
//                               labelStyle: TextStyle(color: myHexColor),
//                               alignLabelWithHint: true,
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.zero,
//                             ),
//                             maxLines: 3,
//                             onChanged: (value) {
//                               // Add your logic for handling notes
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ]
//           )
//       ),
//       bottomNavigationBar: enteredAmount.isNotEmpty
//           ? AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         transform: Matrix4.translationValues(
//             0, keyboardHeight > 0 ? -keyboardHeight : 0, 0),
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         color: Colors.white,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   Flexible(
//                     child: Text(
//                       "ETB $enteredAmount", // Dynamic amount
//                       overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                         color: myHexColor,
//                       ),
//                     ),
//                   ),
//                   if (widget.itemKey != ModuleCode.requestMoney) ...[
//                     const SizedBox(width: 100.0), // Adjust spacing as needed
//                     Container(
//                       height: 24.0, // Height of the divider
//                       width: 1.0, // Thickness of the divider
//                       color: Colors.black, // Divider color
//                     ),
//                     const SizedBox(width: 16.0), // Add spacing after the divider
//                     Flexible(
//                       child:  Text(
//                         widget.itemKey == ModuleCode.receiveRequest
//                             ? widget.loginResponse?.loginUserInfo.wallet_acc_no?? '' // Use widget.accNumber for RECV_REQ
//                             : accountNumber.length > 4 ? 'XXXX' + accountNumber.substring(accountNumber.length - 4) : accountNumber?? "",    // Use accountNumber for other itemKey values
//                         overflow: TextOverflow.ellipsis, // Prevent overflow
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: myHexColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               onPressed: () {
//                 if (widget.itemKey == ModuleCode.cbsToWallet || widget.itemKey == ModuleCode.walletToCbs || widget.itemKey==ModuleCode.fundTransfer ||
//                     widget.itemKey=='REC_PAY' || widget.itemKey==ModuleCode.corporatePayment) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AuthenticationScreen(
//                         loginResponse: widget.loginResponse,
//                         commAccountRequest:widget.commAccountRequest,
//                         searchResponse: widget.searchResponse,
//                         transactionType:widget.transactionType,
//                         itemKey: widget.itemKey,
//                         commWalletAccountRequest: widget.commWalletAccountRequest,
//                         enteredAmount:amountController.text,
//                       ),
//                     ),
//                   );
//                 }
//               },
//               child: Text(
//                 widget.itemKey == ModuleCode.requestMoney ? 'Submit' : 'Pay',
//                 style: const TextStyle(
//                   color: Colors.white, // Set the text color to white
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       )
//           : null,
//     );
//   }
// }

import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';

import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommFeeCalulation.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/utils/RandomNumberGenerator.dart';
import '../../../../../constants/ModuleCode.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../data/models/EstatementEntity.dart';
import '../../../../../data/models/login_models/UserOtpValidationInfo.dart';
import '../../../BaseScreen/base_screen.dart';
import '../../../Dashboard/widgets/BankSelectionScreen.dart';
import 'customer_authentication_screen.dart';

class CustomerTransactionScreen extends StatefulWidget {
  final CommWalletAccountRequest? commWalletAccountRequest;
  final CommAccountRequest? commAccountRequest;
  final dynamic itemKey;
  final String? transactionType;
  final LoginUserReqResInfo? loginResponse;
  final CommAccountRequest? searchResponse;
  final String? userType;
  final EstatementEntity? transaction;
  final BankOption selectedBank;

  CustomerTransactionScreen(
      {this.commWalletAccountRequest,
      this.commAccountRequest,
      this.itemKey,
      required this.transactionType,
      this.loginResponse,
      this.searchResponse,
      this.userType,
      this.transaction,
      required this.selectedBank});

  @override
  CustomerTransactionScreenState createState() =>
      CustomerTransactionScreenState();
}

class CustomerTransactionScreenState
    extends BaseScreenState<CustomerTransactionScreen> {
  late String mobileNumber;
  late String initial;
  late String customerName;
  late String accountNumber;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final Color myHexColor = Color(0xff5c7d33);
  String enteredAmount = "";
  final AuthService authService = AuthService();
  late UserOTPValidationInfo userOTPValidationInfo;
  CommFeeCalculation response = CommFeeCalculation();
  String txnRefNo = RandomNumberGenerator.generateId('AGB', 13);
  @override
  void initState() {
    super.initState();
    amountController.addListener(() {
      setState(() {
        enteredAmount = amountController.text;
      });
    });
    AppLogger.debug(
        'TransactionDetails initState - itemKey: ${widget.itemKey}');
    if (widget.itemKey == ModuleCode.walletToCbs) {
      initial = ((widget.commAccountRequest?.customerName.isNotEmpty ?? false)
          ? widget.commAccountRequest!.customerName
              .substring(0, 1)
              .toUpperCase()
          : '');
      customerName =
          widget.commAccountRequest?.customerName ?? 'Unknown Customer';

      mobileNumber = widget.commAccountRequest?.mobileno ?? 'Unknown Mobile';

      accountNumber =
          widget.commAccountRequest?.accountNum ?? 'Unknown Account';
    }
    if (widget.itemKey == ModuleCode.cbsToWallet) {
      initial =
          ((widget.loginResponse?.loginUserInfo.firstName?.isNotEmpty ?? false)
              ? widget.loginResponse!.loginUserInfo.firstName
                  ?.substring(0, 1)
                  .toUpperCase()
              : '')!;
      customerName =
          widget.loginResponse?.loginUserInfo.firstName ?? 'Unknown Customer';
      mobileNumber =
          widget.loginResponse?.headerInfo.userName ?? 'Unknown Mobile';
      accountNumber = widget.loginResponse?.headerInfo.wallet_account_no ??
          'Unknown Account';
    }
    if (widget.itemKey == ModuleCode.fundTransfer ||
        widget.itemKey == 'REC_PAY') {
      if (widget.transactionType == 'Account') {
        initial = ((widget.searchResponse?.customerName.isNotEmpty ?? false)
            ? widget.searchResponse!.customerName.substring(0, 1).toUpperCase()
            : (widget.transaction?.cCustomerName?.isNotEmpty ?? false)
                ? widget.transaction?.cCustomerName
                    ?.substring(0, 1)
                    .toUpperCase()
                : '')!;
        customerName = widget.searchResponse?.customerName ??
            widget.transaction?.cCustomerName ??
            'Unknown Customer';
        mobileNumber = widget.searchResponse?.mobileno ??
            widget.transaction?.cMobileNo ??
            'Unknown Mobile';
        accountNumber = widget.searchResponse?.accountNum ??
            widget.transaction?.cAccountNo ??
            'Unknown Account';
      }
      if (widget.transactionType == 'Wallet') {
        initial =
            ((widget.commWalletAccountRequest?.customerName.isNotEmpty ?? false)
                ? widget.commWalletAccountRequest!.customerName
                    .substring(0, 1)
                    .toUpperCase()
                : (widget.transaction?.cCustomerName?.isNotEmpty ?? false)
                    ? widget.transaction?.cCustomerName
                        ?.substring(0, 1)
                        .toUpperCase()
                    : '')!;
        customerName = widget.commWalletAccountRequest?.customerName ??
            widget.transaction?.cCustomerName ??
            'Unknown Customer';
        mobileNumber = widget.commWalletAccountRequest?.mobileno ??
            widget.transaction?.cMobileNo ??
            'Unknown Mobile';
        accountNumber = widget.commWalletAccountRequest?.accountNum ??
            widget.transaction?.cAccountNo ??
            'Unknown Account';
      }
    }
    if (widget.itemKey == ModuleCode.corporatePayment) {
      initial = ((widget.commWalletAccountRequest?.customerName.isNotEmpty ??
              false)
          ? widget.commWalletAccountRequest!.customerName
              .substring(0, 1)
              .toUpperCase()
          : (widget.transaction?.cCustomerName?.isNotEmpty ?? false)
              ? widget.transaction?.cCustomerName?.substring(0, 1).toUpperCase()
              : '')!;
      customerName = widget.commWalletAccountRequest?.customerName ??
          widget.transaction?.cCustomerName ??
          'Unknown Customer';
      mobileNumber = widget.commWalletAccountRequest?.mobileno ??
          widget.transaction?.cMobileNo ??
          'Unknown Mobile';
      accountNumber = widget.commWalletAccountRequest?.accountNum ??
          widget.transaction?.cAccountNo ??
          'Unknown Account';
    }
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.itemKey == ModuleCode.walletToCbs
            ? "Wallet to Account Money Transfer "
            : widget.itemKey == ModuleCode.cbsToWallet
                ? "Account to Wallet Money Transfer"
                : widget.itemKey == ModuleCode.fundTransfer
                    ? "Fund Transfer"
                    : widget.itemKey == ModuleCode.corporatePayment
                        ? "Corporate Payment"
                        : widget.itemKey == 'REC_PAY'
                            ? "Receive Payment"
                            : "", // Fallback text for undefined keys,
      ),
      body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(children: [
            Card(
              color: Colors.white,
              elevation: 4, // Adds shadow to give depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ), // Add horizontal margin
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.teal,
                          radius: 20,
                          child: Text(
                            initial,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customerName,
                              style: const TextStyle(
                                fontSize: 18,
                                // Bold text for emphasis
                              ),
                            ),
                            if (widget.itemKey != ModuleCode.requestMoney)
                              Text(
                                accountNumber.length > 4
                                    ? 'XXXX' +
                                        accountNumber
                                            .substring(accountNumber.length - 4)
                                    : accountNumber ?? "",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            const SizedBox(height: 5),
                            Text(
                              mobileNumber,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: myHexColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: amountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Amount',
                                ),
                                enabled: widget.itemKey !=
                                    ModuleCode
                                        .receiveRequest, // Disable editing for RECV_REQ
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: myHexColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: noteController,
                        decoration: InputDecoration(
                          labelText: 'Add a note',
                          labelStyle: TextStyle(color: myHexColor),
                          alignLabelWithHint: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          // Add your logic for handling notes
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ])),
      bottomNavigationBar: enteredAmount.isNotEmpty
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.translationValues(
                  0, keyboardHeight > 0 ? -keyboardHeight : 0, 0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            "ETB $enteredAmount", // Dynamic amount
                            overflow: TextOverflow
                                .ellipsis, // Ensure text doesn't overflow
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: myHexColor,
                            ),
                          ),
                        ),
                        if (widget.itemKey != ModuleCode.requestMoney) ...[
                          const SizedBox(
                              width: 100.0), // Adjust spacing as needed
                          Container(
                            height: 24.0, // Height of the divider
                            width: 1.0, // Thickness of the divider
                            color: Colors.black, // Divider color
                          ),
                          const SizedBox(
                              width: 16.0), // Add spacing after the divider
                          Flexible(
                            child: Text(
                              widget.itemKey == ModuleCode.receiveRequest
                                  ? widget.loginResponse?.loginUserInfo
                                          .wallet_acc_no ??
                                      '' // Use widget.accNumber for RECV_REQ
                                  : accountNumber.length > 4
                                      ? 'XXXX' +
                                          accountNumber.substring(
                                              accountNumber.length - 4)
                                      : accountNumber ??
                                          "", // Use accountNumber for other itemKey values
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myHexColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      if (widget.itemKey == ModuleCode.cbsToWallet ||
                          widget.itemKey == ModuleCode.walletToCbs ||
                          widget.itemKey == ModuleCode.fundTransfer ||
                          widget.itemKey == 'REC_PAY' ||
                          widget.itemKey == ModuleCode.corporatePayment) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthenticationScreen(
                              loginResponse: widget.loginResponse,
                              commAccountRequest: widget.commAccountRequest,
                              searchResponse: widget.searchResponse,
                              transactionType: widget.transactionType,
                              itemKey: widget.itemKey,
                              transaction: widget.transaction,
                              commWalletAccountRequest:
                                  widget.commWalletAccountRequest,
                              enteredAmount: amountController.text,
                              selectedBank: widget.selectedBank,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      widget.itemKey == ModuleCode.requestMoney
                          ? 'Submit'
                          : 'Pay',
                      style: const TextStyle(
                        color: Colors.white, // Set the text color to white
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
