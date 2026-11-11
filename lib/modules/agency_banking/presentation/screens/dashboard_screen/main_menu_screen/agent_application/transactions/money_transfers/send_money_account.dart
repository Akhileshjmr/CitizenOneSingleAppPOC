import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/money_transfers/send_money_confirmation_screen.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../data/models/CommAccountRequest.dart';
import '../../../../../../../data/models/CommFeeCalulation.dart';
import '../../../../../../../data/models/CommTransaction.dart';
import '../../../../../../../data/models/CommWalletAccountRequest.dart';
import '../../../../../../../data/models/CommWalletTransaction.dart';
import '../../../../../../../data/models/common_models/ServerMessage.dart';
import '../../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../../../data/models/login_models/UserOtpValidationInfo.dart';
import '../../../../../../../data/models/lov_models/AbLovs.dart';
import '../../../../../../../data/models/lov_models/AbLovsMaster.dart';
import '../../../../../../../data/services/AuthService.dart';
import '../../../../../../blocs/account_search_bloc/account_search_bloc.dart';
import '../../../../../../blocs/account_search_bloc/account_search_event.dart';
import '../../../../../../blocs/account_search_bloc/account_search_state.dart';
import '../../../../../../blocs/charge_calculation_bloc/charge_calculation_bloc.dart';
import '../../../../../../blocs/charge_calculation_bloc/charge_calculation_event.dart';
import '../../../../../../blocs/charge_calculation_bloc/charge_calculation_state.dart';
import '../../../../../../blocs/forgot_password_bloc/forgot_password_bloc.dart';
import '../../../../../../blocs/forgot_password_bloc/forgot_password_event.dart';
import '../../../../../../blocs/forgot_password_bloc/forgot_password_state.dart';
import '../../../../../../blocs/get_lov_bloc/get_lov_bloc.dart';
import '../../../../../../blocs/get_lov_bloc/get_lov_event.dart';
import '../../../../../../blocs/get_lov_bloc/get_lov_state.dart';
import '../../../../../../blocs/pin_validation_bloc/pin_validation_bloc.dart';
import '../../../../../../blocs/wallet_account_search/wallet_account_search_bloc.dart';
import '../../../../../../blocs/wallet_account_search/wallet_account_search_event.dart';
import '../../../../../../blocs/wallet_account_search/wallet_account_search_state.dart';
import '../../../../../BaseScreen/base_screen.dart';
import '../../../../../Dashboard/widgets/BankSelectionScreen.dart';

class SendMoneyScreen2 extends StatefulWidget {
  final dynamic itemKey;
  final LoginUserReqResInfo loginResponse;
  final String transaction;
  final String? transType;
  final BankOption selectedBank;
  SendMoneyScreen2(
      {required this.loginResponse,
      required this.itemKey,
      required this.transaction,
      this.transType,
      required this.selectedBank});

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends BaseScreenState<SendMoneyScreen2>
    with SingleTickerProviderStateMixin {
  final Color myHexColor = Color(0xff5c7d33);
  bool isDialogOpen = true; // To control the blur effect
  late TabController _tabController;
  late TextEditingController mobileNumberController;
  late TextEditingController depositorNameController;
  late TextEditingController accountNumberController;
  late TextEditingController transferAmountController;
  late TextEditingController noteController;
  late WalletSearchBloc senderSearchBloc;
  late AccountSearchBloc senderBloc;
  CommWalletAccountRequest walletSearchResponse = CommWalletAccountRequest();
  CommAccountRequest accountSearchResponse = CommAccountRequest();
  bool isWalletSearchSuccessful = false;
  bool isAccountSearchSuccessful = false;
  String selectedSecurityOption = 'By ID'; // Default selection
  Map<String, List<DropdownMenuItem<String>>> dropdownItems = {};
  final AuthService authService = AuthService();
  late GetLovBloc lovBloc;
  String? selectedIdType;
  late UserOTPValidationInfo userOTPValidationInfo;
  String? selectedSecurityQuestion;
  CommFeeCalculation response = CommFeeCalculation();
  CommWalletTransaction commWalletTransaction = CommWalletTransaction();
  CommTransaction commTransaction = CommTransaction();
  UserOTPValidationInfo otpValidationInfo = UserOTPValidationInfo();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    depositorNameController = TextEditingController();
    mobileNumberController = TextEditingController();
    accountNumberController = TextEditingController();
    transferAmountController = TextEditingController();
    noteController = TextEditingController();
    senderSearchBloc = WalletSearchBloc(AuthService());
    senderBloc = AccountSearchBloc(AuthService());
    var permission = widget.loginResponse.loginUserInfo.permission;
    permission?.remove('MAIN_MENU');
    // Initialize GetLovBloc once
    lovBloc = GetLovBloc(AuthService());
    AbLovsMaster request = AbLovsMaster();
    request.headerInfo = widget.loginResponse.headerInfo;
    // Step 2: Create AbLovs instances for each module and add them to the request
    AbLovs smLov = AbLovs(module: "AB_LOV_SM", genLovs: null);
    request.abLovs = [smLov];
    // Step 3: Dispatch the GetLovSubmitted event with the combined request
    lovBloc.add(GetLovSubmitted(request));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Future<void> _pickContact() async {
  //   // Request permission to access contacts
  //   if (await Permission.contacts.request().isGranted) {
  //     try {
  //       // Pick a contact
  //       Contact? contact = await ContactsService.openDeviceContactPicker();
  //       if (contact != null && contact.phones != null && contact.phones!.isNotEmpty) {
  //         // Extract the first mobile number
  //         String mobileNumber = contact.phones!.first.value!.replaceAll(RegExp(r'\D'), '');
  //
  //         // Update the mobile number field
  //         mobileNumberController.text = mobileNumber;
  //
  //         // Call the API (assuming API function is implemented)
  //         if (mobileNumber.length == 9) {
  //           final request = CommWalletAccountRequest(
  //             mobileno: mobileNumber,
  //             headerInfo: widget.loginResponse.headerInfo,
  //             moduleCode: widget.itemKey,
  //           );
  //
  //           senderSearchBloc.add(WalletSearchSubmitted(request));
  //         }
  //       }
  //     } catch (e) {
  //       print('Error picking contact: $e');
  //     }
  //   } else {
  //     print('Permission denied');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Send Money",
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<WalletSearchBloc, WalletSearchState>(
            bloc: senderSearchBloc,
            listener: (context, state) {
              if (state is WalletSearchSuccess) {
                setState(() {
                  isWalletSearchSuccessful = true;
                  walletSearchResponse = state.commWalletAccountRequest;
                  depositorNameController.text =
                      state.commWalletAccountRequest.customerName;
                  accountNumberController.text =
                      state.commWalletAccountRequest.accountNum;
                  mobileNumberController.text =
                      state.commWalletAccountRequest.mobileno;
                });
              } else if (state is WalletSearchFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
          ),
          BlocListener<AccountSearchBloc, AccountSearchState>(
            bloc: senderBloc,
            listener: (context, state) {
              if (state is AccountSearchSuccess) {
                setState(() {
                  isAccountSearchSuccessful = true;
                  accountSearchResponse = state.commAccountRequest;
                  depositorNameController.text =
                      state.commAccountRequest.customerName;
                  mobileNumberController.text =
                      state.commAccountRequest.mobileno;
                  accountNumberController.text =
                      state.commAccountRequest.accountNum;
                });
              } else if (state is AccountSearchFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
          ),
          BlocListener<ChargeCalculationBloc, ChargeCalculationState>(
            listener: (context, state) {
              if (state is ChargeCalculationSuccess) {
                setState(() {
                  response = state.user;
                });
              } else if (state is ChargeCalculationFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
          ),
          BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
              listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              otpValidationInfo = state.userOtp;
              Navigator.pop(context); // Close the bottom sheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => ForgotPasswordBloc(AuthService()),
                    child: SendMoneyAuthenticationScreen(
                      enteredAmount: '',
                      paymentOption: "OTP",
                      userOTPValidationInfo: otpValidationInfo,
                      charges: response,
                      commTransaction: commTransaction,
                      itemKey: widget.itemKey,
                      loginResponse: widget.loginResponse,
                      commWalletTransaction: commWalletTransaction,
                      transaction: widget.transaction,
                      selectedBank: widget.selectedBank,
                    ),
                  ),
                ),
              );
            }
          }),
          BlocListener<GetLovBloc, GetLovState>(
              bloc: lovBloc,
              listener: (context, state) {
                if (state is GetLovSuccess) {
                  AppLogger.debug('LOV data received for send money account');
                  for (var abLov in state.user.abLovs) {
                    for (var genLov in abLov.genLovs ?? []) {
                      String lovId = genLov.lovId; // Access lovId directly
                      if (genLov.valDes != null) {
                        dropdownItems[lovId] = genLov.valDes!
                            .map<DropdownMenuItem<String>>((valDes) {
                          return DropdownMenuItem<String>(
                            value: valDes.val, // Ensure `valDes.val` is unique
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(valDes.desc,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          );
                        }).toList();
                        // Ensure no duplicate items for the same value
                        dropdownItems[lovId] =
                            dropdownItems[lovId]!.toSet().toList();
                      }
                    }
                  }
                  setState(() {});
                }
              }),
        ],
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                  bottom: 80.0), // Leave space for the button
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Depositor Details Card
                    buildCard(
                        title: 'Depositor Details',
                        child: Column(children: [
                          if (widget.transaction == 'Wallet')
                            buildRowWithIcons(),
                          if (widget.transaction == 'Account')
                            buildRowWithIcons(),
                          SizedBox(height: 10),
                          if ((widget.transaction == 'Wallet' &&
                                  isWalletSearchSuccessful) ||
                              (widget.transaction == 'Account' &&
                                  isAccountSearchSuccessful)) ...[
                            buildReadOnlyTextField(
                                'Depositor Name', depositorNameController),
                            SizedBox(height: 10),
                            // Show either Account Number or Mobile Number based on transaction type
                            if (widget.transaction == 'Wallet')
                              buildReadOnlyTextField(
                                  'Account Number', accountNumberController),
                            if (widget.transaction == 'Account')
                              buildReadOnlyTextField(
                                  'Mobile Number', mobileNumberController),
                            SizedBox(height: 10),
                            buildDropdownField(
                                'Currency', 'ab-cust-currency', 'dCurrency'),
                            SizedBox(height: 10),
                            buildText('Transfer Amount', 'amount'),
                            SizedBox(height: 10),
                            buildTextField('Add a Note', maxLines: 3),
                          ],
                        ])),
                    SizedBox(height: 12),

                    // Beneficiary Details and Security only after API success
                    if (depositorNameController.text.isNotEmpty &&
                        accountNumberController.text.isNotEmpty) ...[
                      buildCard(
                        title: 'Beneficiary Details',
                        child: Column(
                          children: [
                            buildText('Name', 'bName'),
                            SizedBox(height: 10),
                            buildText('Mobile Number', 'bMob'),
                            SizedBox(height: 10),
                            buildDropdownField(
                                'Currency', 'ab-cust-currency', 'bCurrency'),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      buildCard(
                        title: 'Security',
                        child: Column(
                          children: [
                            buildRadioButton('By ID'),
                            buildRadioButton('By Security Answer'),
                            buildRadioButton('Both'),
                            if (selectedSecurityOption == 'By ID') ...[
                              buildDropdownField('Depositor ID Type',
                                  'ab-sm-id-type', "drIdType"),
                              buildTextField('Depositor ID Number'),
                              buildDropdownField('Benificiary ID Type',
                                  'ab-sm-id-type', "crIdType"),
                              buildTextField('Benificiary ID Number'),
                            ],
                            if (selectedSecurityOption ==
                                'By Security Answer') ...[
                              buildDropdownField('Security Questions',
                                  'ab-sm-security-ques', "securirityQuestion"),
                              buildTextField('Security Answer'),
                            ],
                            if (selectedSecurityOption == 'Both') ...[
                              buildDropdownField('Depositor ID Type',
                                  'ab-sm-id-type', "drIdType"),
                              buildTextField('Depositor ID Number'),
                              buildDropdownField('Benificiary ID Type',
                                  'ab-sm-id-type', "crIdType"),
                              buildTextField('Benificiary ID Number'),
                              buildDropdownField('Security Questions',
                                  'ab-sm-security-ques', "securirityQuestion"),
                              buildTextField('Security Answer'),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Save Button (Conditionally displayed after API success)
            if (depositorNameController.text.isNotEmpty &&
                accountNumberController.text.isNotEmpty)
              Positioned(
                bottom: 1,
                left: 10,
                right: 10,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myHexColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () async {
                    handleChargeCalculation();
                    savedata(context);
                    _showPaymentOption();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }

  void _showPaymentOption() {
    final forgotPasswordBloc = context.read<ForgotPasswordBloc>();
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Center the header text
                Center(
                  child: Text(
                    'Choose Payment Method',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.lock, color: myHexColor),
                  title: Center(
                    child: Text(
                      'Pay using OTP',
                      style: TextStyle(
                        fontSize: 20, // Adjust the size as needed
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    UserOTPValidationInfo request = UserOTPValidationInfo();
                    request.headerInfo = widget.loginResponse.headerInfo;
                    request.mobileNo =
                        widget.loginResponse.loginUserInfo.mobileno.toString();
                    request.userName =
                        widget.loginResponse.loginUserInfo.userName ?? "";
                    forgotPasswordBloc.add(ForgotPasswordSubmitted(request));
                  },
                ),

                ListTile(
                  leading: Icon(Icons.pin, color: myHexColor),
                  title: Center(
                    child: Text(
                      'Pay using PIN',
                      style: TextStyle(
                        fontSize: 20, // Adjust the size as needed
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close the bottom sheet
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                              create: (context) =>
                                  PinValidationBloc(AuthService()),
                              child: SendMoneyAuthenticationScreen(
                                paymentOption: "PIN",
                                itemKey: widget.itemKey,
                                loginResponse: widget.loginResponse,
                                enteredAmount: '',
                                charges: response,
                                commTransaction: commTransaction,
                                commWalletTransaction: commWalletTransaction,
                                transaction: widget.transaction,
                                selectedBank: widget.selectedBank,
                              )),
                        ));
                  },
                ),
                SizedBox(height: 8.0),
              ],
            ),
          );
        });
  }

  // Helper Method to Build Read-Only Text Fields
  Widget buildReadOnlyTextField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Add border radius here
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Match the radius when focused
            borderSide: BorderSide(
                color: myHexColor, width: 1), // Customize the focused border
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  // Helper Method to Build Cards
  Widget buildCard({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(15), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 5, // Blur radius
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(
          vertical: 1.0, horizontal: 1.0), // Add some margin
      padding: const EdgeInsets.fromLTRB(
          10, 10, 10, 18), // Add padding inside the container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget buildText(String label, String variable, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 8.0), // Add left and right padding
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Add border radius here
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Match the radius when focused
            borderSide: BorderSide(
                color: myHexColor, width: 1), // Customize the focused border
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10), // Add padding inside the text field
        ),
        onChanged: (value) {
          setState(() {
            setTextValue(variable, value);
          });
        },
      ),
    );
  }

  // Helper Method to Build Text Fields
  // Widget buildTextField(String label, TextEditingController controller,{int maxLines = 1}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add left and right padding
  //     child: TextField(
  //       controller: controller,
  //       maxLines: maxLines,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10.0), // Add border radius here
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10.0), // Match the radius when focused
  //           borderSide: BorderSide(color: myHexColor, width: 1), // Customize the focused border
  //         ),
  //         contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Add padding inside the text field
  //       ),
  //     ),
  //   );
  // }
  void setTextValue(String variable, String value) {
    switch (variable) {
      case "dCurrency":
        dCurrency = value;
        break;
      case "amount":
        amount = value;
        break;
      case "remarks":
        remarks = value;
        break;
      case "bName":
        bName = value;
        break;
      case "bMob":
        bMob = value;
        break;
      case "bCurrency":
        bCurrency = value;
        break;
      case "bIdNum":
        bIdNum = value;
        break;
      case "dIdNum":
        dIdNum = value;
        break;
      case "securirityAns":
        securirityAns = value;
        break;
    }
  }

  // Helper Method to Build Dropdown Field
// State variables to store text field values
  String dCurrency = '';
  String amount = '';
  String remarks = '';
  String bName = '';
  String bMob = '';
  String bCurrency = '';
  String dIdNum = '';
  String bIdNum = '';
  String securirityAns = '';
  // State variables to store selected values
  String drIdType = '';
  String crIdType = '';
  String securityQuestion = '';
  String? getValue(String variable) {
    switch (variable) {
      case "drIdType":
        return drIdType.isNotEmpty ? drIdType : null;
      case "crIdType":
        return crIdType.isNotEmpty ? crIdType : null;
      case "securirityQuestion":
        return securityQuestion.isNotEmpty ? securityQuestion : null;
      default:
        return null;
    }
  }

// Helper function to update the selected value dynamically
  void setValue(String variable, String value) {
    switch (variable) {
      case "drIdType":
        drIdType = value;
        break;
      case "crIdType":
        crIdType = value;
        break;
      case "securirityQuestion":
        securityQuestion = value;
        break;
    }
  }

// Ensure that the selected value is reset or matches an item in the new dropdown items
  // Helper Method to Build Dropdown Field
  Widget buildDropdownField(String label, String lovId, String variable) {
    final items = dropdownItems[lovId] ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        items: items,
        value: getValue(variable), // Get the correct value dynamically
        onChanged: (value) {
          setState(() {
            setValue(variable, value ?? '');
          });
        },
      ),
    );
  }

  Widget buildRadioButton(String label) {
    return ListTile(
      title: Text(label),
      leading: Radio<String>(
        value: label,
        groupValue: selectedSecurityOption,
        onChanged: (value) {
          setState(() {
            selectedSecurityOption = value!;
          });
        },
      ),
    );
  }

  // Helper Method to Build Row with Icons
  Widget buildRowWithIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: widget.transaction == 'Wallet'
            ? mobileNumberController
            : accountNumberController,
        keyboardType: widget.transaction == 'Wallet'
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          labelText: widget.transaction == 'Wallet'
              ? 'Mobile Number'
              : 'Account Number',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Add border radius
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Match radius when focused
            borderSide: BorderSide(
                color: myHexColor, width: 1), // Customize the focused border
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          // Add the search icon and conditionally include the asset image
          suffixIcon: Row(
            mainAxisSize:
                MainAxisSize.min, // Ensure the row takes minimum width
            children: [
              IconButton(
                icon: Icon(Icons.search, color: myHexColor),
                onPressed: () {
                  final inputValue = widget.transaction == 'Wallet'
                      ? mobileNumberController.text
                      : accountNumberController.text;

                  if (widget.transaction == 'Wallet') {
                    // Validate and trigger wallet search
                    if (inputValue.length == 9) {
                      final request = CommWalletAccountRequest(
                        mobileno: inputValue,
                        headerInfo: widget.loginResponse.headerInfo,
                        moduleCode: widget.itemKey,
                      );
                      senderSearchBloc.add(WalletSearchSubmitted(request));
                    }
                  } else if (widget.transaction == 'Account') {
                    // Trigger account search logic here (if any)
                    // Example: Dispatch an AccountSearchSubmitted event
                    CommAccountRequest accRequest = CommAccountRequest();
                    accRequest.headerInfo = widget.loginResponse.headerInfo;
                    accRequest.accountNum = accountNumberController.text;
                    senderBloc.add(AccountSearchSubmitted(accRequest));
                  }
                },
              ),
              if (widget.transaction == 'Wallet')
                IconButton(
                  icon: Image.asset(
                    'assets/images/img.png', // Path to your asset image
                    height: 25,
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                    // _pickContact();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  chargeCal() async {
    CommWalletTransaction req = CommWalletTransaction(
      headerInfo: widget.loginResponse.headerInfo,
      resMessage: ServerMessage(),
    );
    context.read<ChargeCalculationBloc>().add(ChargeCalculationSubmitted(req));
  }

  void handleChargeCalculation() async {
    await chargeCal(); // Ensure this is called within an async function
  }

  void savedata(BuildContext context) {
    if (widget.transaction == 'Wallet') {
      commWalletTransaction.crIdType = crIdType;
      commWalletTransaction.drIdType = drIdType;
      commWalletTransaction.securirityQuestion = securityQuestion;
      commWalletTransaction.bName = bName;
      commWalletTransaction.bMob = bMob;
      commWalletTransaction.dName = depositorNameController.text;
      commWalletTransaction.dMob = mobileNumberController.text;
      commWalletTransaction.dAccountNo = accountNumberController.text;
      commWalletTransaction.dCurrency = dCurrency;
      commWalletTransaction.bCurrency = bCurrency;
      commWalletTransaction.txnAmount = double.tryParse(amount);
      commWalletTransaction.remarks = remarks;
      commWalletTransaction.bIdNum = bIdNum;
      commWalletTransaction.dIdNum = dIdNum;
      commWalletTransaction.moduleType = 'SM';
      commWalletTransaction.securirityAns = '';
    } else {
      commTransaction.securirityQuestion = securityQuestion;
      commTransaction.bName = bName;
      commTransaction.bMob = bMob;
      commTransaction.dName = depositorNameController.text;
      commTransaction.dMob = mobileNumberController.text;
      commTransaction.dAccountNo = accountNumberController.text;
      commTransaction.dCurrency = dCurrency;
      commTransaction.bCurrency = bCurrency;
      commTransaction.txnAmount = double.tryParse(amount);
      commTransaction.remarks = remarks;
      commTransaction.bIdNum = bIdNum;
      commTransaction.dIdNum = dIdNum;
      commTransaction.moduleType = 'SM';
      commTransaction.securirityAns = '';
    }
  }
}
