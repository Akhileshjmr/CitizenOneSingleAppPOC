//
// import 'package:citizenone_app/modules/agency_banking/colors/Appcolors.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../../../../../../data/models/AbQueryLoanDetails.dart';
// import '../../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
// import '../../../../../BaseScreen/base_screen.dart';
// import '../../../customer_application/customer_authentication_screen.dart';
//
// class PayByCashScreen extends StatefulWidget {
//   final bool isWallet; // Flag to check if the transaction is wallet-based
//   final LoginUserReqResInfo loginResponse;
//   final AbQueryLoanDetails? loanSearchResponse;
//   final dynamic itemKey;
//   PayByCashScreen({required this.isWallet, required this.loginResponse, this.loanSearchResponse, this.itemKey});
//
//   @override
//   _PayByCashScreenState createState() => _PayByCashScreenState();
// }
//
// class _PayByCashScreenState extends BaseScreenState<PayByCashScreen> {
//   TextEditingController mobileNumberController = TextEditingController();
//   TextEditingController customerNameController = TextEditingController();
//   TextEditingController accountNumberController = TextEditingController();
//   TextEditingController cifIdController = TextEditingController();
//   TextEditingController enteredAmount = TextEditingController();
//   TextEditingController accountBranchController = TextEditingController();
//   TextEditingController accountCurrencyController = TextEditingController();
//   TextEditingController loanExRateController = TextEditingController();
//   TextEditingController settlementModeController = TextEditingController();
//   TextEditingController reversedController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Bind loginResponse data to respective controllers
//     accountNumberController.text = widget.loginResponse.headerInfo.cb_account_no ?? '';
//     customerNameController.text = widget.loginResponse.loginUserInfo.firstName ?? '';
//     mobileNumberController.text = widget.loginResponse.loginUserInfo.userName ?? '';
//     accountBranchController.text = widget.loginResponse.headerInfo.branchCode ?? '';
//     accountCurrencyController.text = widget.loginResponse.headerInfo.currency ?? '';
//
//     final loanDetails = widget.loanSearchResponse?.loanDetResp;
//
//     // Set CIF ID
//     if (loanDetails?.custId != null) {
//       cifIdController.text = loanDetails!.custId!;
//     }
//
//     // Safely access the first settlement entry if available
//     final settlements = loanDetails?.abLoanSettelments;
//     if (settlements != null && settlements.isNotEmpty) {
//       final settlement = settlements.first;
//       reversedController.text = settlement.rvrsd ?? '';
//       settlementModeController.text = settlement.stlmod ?? '';
//       loanExRateController.text = settlement.exRate?.toString() ?? '';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           color: Colors.white,
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Siinqee Agency',
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           buildMobileDataStatusImage(), // <-- Shows image based on mobile data status
//           const SizedBox(width: 25),
//           InkWell(
//             onTap: () {
//               showLogoutDialog(context);
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: Image.asset(
//                 'assets/images/ic_exit_to_app_white.png',
//                 width: 24,
//                 height: 24,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//         backgroundColor: AppColors.fbTooLite,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildFirstSection(),
//             SizedBox(height: 10),
//             _buildSecondSection(),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AuthenticationScreen(
//                         loginResponse: widget.loginResponse,
//                         enteredAmount: '',
//                         loanSearchResponse:widget.loanSearchResponse,
//                         commWalletAccountRequest: null,
//
//                       ),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: myHexColor,
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 100, vertical: 10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//                 child: Text(
//                   'Next',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFirstSection() {
//     return Card(
//       color: Colors.white,
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//       child: Padding(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: widget.isWallet
//               ? _buildWalletFields()
//               : _buildAccountFields(),
//         ),
//       ),
//     );
//   }
//
//   List<Widget> _buildWalletFields() {
//     return [
//       TextField(
//         controller: cifIdController,
//         readOnly: true,
//         decoration: InputDecoration(labelText: 'CIF Id'),
//       ),
//       TextField(
//         controller: customerNameController,
//         readOnly: true,
//         decoration: InputDecoration(labelText: 'Customer Name'),
//       ),
//       TextField(
//         controller: mobileNumberController,
//         readOnly: true,
//         decoration: InputDecoration(labelText: 'Mobile Number'),
//       ),
//       TextField(
//         controller: enteredAmount,
//         decoration: InputDecoration(labelText: 'Enter Amount'),
//         keyboardType: TextInputType.number,
//       ),
//     ];
//   }
//
//   List<Widget> _buildAccountFields() {
//     return [
//       TextField(
//         controller: accountNumberController,
//         decoration: InputDecoration(labelText: 'Account Number'),
//       ),
//       TextField(
//         controller: accountBranchController,
//         readOnly: true,
//         decoration: InputDecoration(labelText: 'Branch'),
//       ),
//       TextField(
//         controller: accountCurrencyController,
//         readOnly: true,
//         decoration: InputDecoration(labelText: 'Currency'),
//       ),
//       TextField(
//         controller: cifIdController,
//         readOnly: true,
//         decoration: InputDecoration(labelText: 'CIF Id'),
//       ),
//       TextField(
//         controller: customerNameController,
//         readOnly: true,
//         decoration: InputDecoration(labelText: 'Customer Name'),
//       ),
//       TextField(
//         controller: mobileNumberController,
//         readOnly: true,
//         decoration: InputDecoration(labelText: 'Mobile Number'),
//       ),
//       TextField(
//         controller: enteredAmount,
//         decoration: InputDecoration(labelText: 'Enter Amount'),
//         keyboardType: TextInputType.number,
//       ),
//     ];
//   }
//
//   Widget _buildSecondSection() {
//     return Card(
//       color: Colors.white,
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//       child: Padding(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Text(
//                 'Loan Settlements',
//                 style: TextStyle(
//                   color: Colors.orange,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Divider(color: myHexColor),
//             TextField(
//               controller: loanExRateController,
//               readOnly: true,
//               decoration: InputDecoration(labelText: 'Loan ExRate'),
//             ),
//             TextField(
//               controller: settlementModeController,
//               readOnly: true,
//               decoration: InputDecoration(labelText: 'Settlement Mode'),
//             ),
//             TextField(
//               controller: reversedController,
//               readOnly: true,
//               decoration: InputDecoration(labelText: 'Reversed'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }