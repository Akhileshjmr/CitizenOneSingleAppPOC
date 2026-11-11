import 'package:citizenone_app/modules/agency_banking/data/models/CommTransaction.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/money_transfers/send_money_confirmation_screen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../data/models/CommFeeCalulation.dart';
import '../../../../../../../data/models/CommWalletTransaction.dart';
import '../../../../../../../data/models/common_models/ServerMessage.dart';
import '../../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../../../data/models/login_models/UserOtpValidationInfo.dart';
import '../../../../../../../data/models/lov_models/AbLovs.dart';
import '../../../../../../../data/models/lov_models/AbLovsMaster.dart';
import '../../../../../../../data/services/AuthService.dart';
import '../../../../../../../utils/CommSuccessDialogues.dart';
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
import '../../../../../BaseScreen/base_screen.dart';
import '../../../../../Dashboard/widgets/BankSelectionScreen.dart';
import 'send_money_account.dart';

class SendMoneyScreen extends StatefulWidget {
  final dynamic itemKey;
  final LoginUserReqResInfo loginResponse;
  final String transaction;
  final BankOption selectedBank;
  SendMoneyScreen(
      {required this.loginResponse,
      required this.itemKey,
      required this.transaction,
      required this.selectedBank});

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends BaseScreenState<SendMoneyScreen> {
  final Color myHexColor = Color(0xff5c7d33);
  bool isDialogOpen = true; // To control the blur effect
  late GetLovBloc lovBloc;
  String? selectedSecurityOption;
  late UserOTPValidationInfo userOTPValidationInfo;
  Map<String, List<DropdownMenuItem<String>>> dropdownItems = {};
  CommFeeCalculation response = CommFeeCalculation();
  CommWalletTransaction commWalletTransaction = CommWalletTransaction();
  CommTransaction commTransaction = CommTransaction();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showInitialDialog());
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

  void _showInitialDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Send Money',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.btnBackground,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.btnBackground,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isDialogOpen = false; // Remove blur
                      });
                      Navigator.pop(context); // Close dialog
                    },
                    child: Text(
                      'Pay By Cash',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.btnBackground,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendMoneyScreen2(
                            loginResponse: widget.loginResponse,
                            transaction: widget.transaction,
                            transType: "By Account",
                            itemKey: widget
                                .itemKey, // Or any specific value you want to pass
                            selectedBank: widget.selectedBank,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Pay By Account',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    isDialogOpen = false; // Remove blur
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetLovBloc, GetLovState>(
            bloc: lovBloc,
            listener: (context, state) {
              if (state is GetLovSuccess) {
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
        BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            userOTPValidationInfo = state.userOtp;
            Navigator.pop(context); // Close the bottom sheet
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (context) => ForgotPasswordBloc(AuthService()),
                  child: SendMoneyAuthenticationScreen(
                    enteredAmount: '',
                    paymentOption: "OTP",
                    itemKey: widget.itemKey,
                    userOTPValidationInfo: userOTPValidationInfo,
                    charges: response,
                    commTransaction: commTransaction,
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
      ],
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Send Money",
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80.0),
              // Leave space for the button
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildCard(
                      title: 'Depositor Details',
                      child: Column(
                        children: [
                          SizedBox(height: 4),
                          buildTextField('Name', "dName"),
                          SizedBox(height: 12),
                          buildTextField('Mobile Number', "dMob"),
                          SizedBox(height: 12),
                          buildDropdownField(
                              'Currency', 'ab-cust-currency', 'dCurrency'),
                          SizedBox(height: 12),
                          buildTextField('Transfer Amount', 'amount'),
                          SizedBox(height: 12),
                          buildTextField('Add a note', maxLines: 3, 'remarks'),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    buildCard(
                      title: 'Beneficiary Details',
                      child: Column(
                        children: [
                          SizedBox(height: 4),
                          buildTextField('Name', "bName"),
                          SizedBox(height: 12),
                          buildTextField('Mobile Number', "bMob"),
                          SizedBox(height: 12),
                          buildDropdownField(
                              'Currency', 'ab-cust-currency', "bCurrency"),
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
                            buildTextField('Depositor ID Number', 'dIdNum'),
                            buildDropdownField('Benificiary ID Type',
                                'ab-sm-id-type', "crIdType"),
                            buildTextField('Benificiary ID Number', 'bIdNum'),
                          ],
                          if (selectedSecurityOption ==
                              'By Security Answer') ...[
                            buildDropdownField('Security Questions',
                                'ab-sm-security-ques', "securirityQuestion"),
                            buildTextField('Security Answer', "securirityAns"),
                          ],
                          if (selectedSecurityOption == 'Both') ...[
                            buildDropdownField('Depositor ID Type',
                                'ab-sm-id-type', "drIdType"),
                            buildTextField('Depositor ID Number', 'dIdNum'),
                            buildDropdownField('Benificiary ID Type',
                                'ab-sm-id-type', "crIdType"),
                            buildTextField('Benificiary ID Number', 'bIdNum'),
                            buildDropdownField('Security Questions',
                                'ab-sm-security-ques', "securirityQuestion"),
                            buildTextField('Security Answer', "securirityAns"),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              left: 10,
              right: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.btnBackground,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
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

  // State variables to store text field values
  String dName = '';
  String dMob = '';
  String dCurrency = '';
  String amount = '';
  String remarks = '';
  String bName = '';
  String bMob = '';
  String bCurrency = '';
  String dIdNum = '';
  String bIdNum = '';
  String securirityAns = '';

  Widget buildTextField(String label, String variable, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        onChanged: (value) {
          setState(() {
            setTextValue(variable, value);
          });
        },
      ),
    );
  }

// Helper function to set the value of the corresponding variable
  void setTextValue(String variable, String value) {
    switch (variable) {
      case "dName":
        dName = value;
        break;
      case "dMob":
        dMob = value;
        break;
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

  Widget buildCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          child,
        ],
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
            selectedSecurityOption = value;
          });
        },
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

  // State variables to store selected values
  String drIdType = '';
  String crIdType = '';
  String securityQuestion = '';

  Widget buildDropdownField(String label, String lovId, String variable) {
    final items = dropdownItems[lovId] ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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

// Helper function to get the selected value dynamically
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
      commWalletTransaction.dName = dName;
      commWalletTransaction.dMob = dMob;
      commWalletTransaction.dCurrency = dCurrency;
      commWalletTransaction.bCurrency = bCurrency;
      commWalletTransaction.txnAmount = double.tryParse(amount);
      commWalletTransaction.remarks = remarks;
      commWalletTransaction.bIdNum = bIdNum;
      commWalletTransaction.dIdNum = dIdNum;
      commWalletTransaction.moduleType = 'SM_CASH';
      commWalletTransaction.securirityAns = '';
      // commWalletTransaction.dIdType =;
    } else {
      commTransaction.securirityQuestion = securityQuestion;
      commTransaction.bName = bName;
      commTransaction.bMob = bMob;
      commTransaction.dName = dName;
      commTransaction.dMob = dMob;
      commTransaction.dCurrency = dCurrency;
      commTransaction.bCurrency = bCurrency;
      commTransaction.txnAmount = double.tryParse(amount);
      commTransaction.remarks = remarks;
      commTransaction.bIdNum = bIdNum;
      commTransaction.dIdNum = dIdNum;
      commTransaction.moduleType = 'SM';
      commTransaction.securirityAns = '';
      // commTransaction.dIdType =;
    }
  }
}
