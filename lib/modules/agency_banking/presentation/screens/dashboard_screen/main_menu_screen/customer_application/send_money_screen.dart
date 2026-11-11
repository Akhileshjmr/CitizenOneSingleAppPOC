import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../data/models/lov_models/AbLovs.dart';
import '../../../../../data/models/lov_models/AbLovsMaster.dart';
import '../../../../../data/services/AuthService.dart';
import '../../../../blocs/get_lov_bloc/get_lov_bloc.dart';
import '../../../../blocs/get_lov_bloc/get_lov_event.dart';
import '../../../../blocs/get_lov_bloc/get_lov_state.dart';
import '../../../BaseScreen/base_screen.dart';
import '../../../Dashboard/widgets/BankSelectionScreen.dart';
import 'customer_authentication_screen.dart';

class CustomerSendMoneyScreen extends StatefulWidget {
  final LoginUserReqResInfo? loginResponse;
  final String? transactionType;
  final dynamic itemKey;
  final CommAccountRequest? commAccountRequest;
  final BankOption selectedBank;

  const CustomerSendMoneyScreen(
      {this.loginResponse,
      this.transactionType,
      this.itemKey,
      this.commAccountRequest,
      required this.selectedBank});

  @override
  _CustomerSendMoneyScreen createState() => _CustomerSendMoneyScreen();
}

class _CustomerSendMoneyScreen
    extends BaseScreenState<CustomerSendMoneyScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key to track validation state
  String enteredAmount = "";
  late GetLovBloc lovBloc;
  Map<String, List<DropdownMenuItem<String>>> dropdownItems = {};
  String? idType;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool showNameError = false;
  bool showMobileError = false;
  bool showIdError = false;
  bool showAmountError = false;

  @override
  void initState() {
    super.initState();

    // Initialize GetLovBloc once
    lovBloc = GetLovBloc(AuthService());
    AbLovsMaster request = AbLovsMaster();
    request.headerInfo = widget.loginResponse!.headerInfo;
    // Step 2: Create AbLovs instances for each module and add them to the request
    AbLovs smLov = AbLovs(module: "AB_LOV_SM", genLovs: null);
    request.abLovs = [smLov];
    // Step 3: Dispatch the GetLovSubmitted event with the combined request
    lovBloc.add(GetLovSubmitted(request));

    nameController.addListener(() {
      setState(() {
        showNameError = nameController.text.isEmpty;
      });
    });

    mobileNumberController.addListener(() {
      setState(() {
        showMobileError = mobileNumberController.text.isEmpty;
      });
    });

    idController.addListener(() {
      setState(() {
        showIdError = idController.text.isEmpty;
      });
    });

    amountController.addListener(() {
      setState(() {
        showAmountError = amountController.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Send Money",
      ),
      body: BlocListener<GetLovBloc, GetLovState>(
        bloc: lovBloc,
        listener: (context, state) {
          if (state is GetLovSuccess) {
            AppLogger.debug('LOV data received for send money');
            Map<String, List<DropdownMenuItem<String>>> updatedDropdownItems =
                {};

            for (var abLov in state.user.abLovs) {
              for (var genLov in abLov.genLovs ?? []) {
                String lovId = genLov.lovId; // Access lovId directly
                if (genLov.valDes != null) {
                  // Use a Set<String> to remove duplicates efficiently
                  Set<String> uniqueValues = {};
                  updatedDropdownItems[lovId] = genLov.valDes!
                      .where((valDes) => uniqueValues
                          .add(valDes.val)) // Only add unique values
                      .map<DropdownMenuItem<String>>((valDes) {
                    return DropdownMenuItem<String>(
                      value: valDes.val,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child:
                            Text(valDes.desc, overflow: TextOverflow.ellipsis),
                      ),
                    );
                  }).toList();
                }
              }
            }
            setState(() {
              dropdownItems =
                  updatedDropdownItems; // Update dropdown items safely
            });
          }
        },
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Form(
            key: _formKey, // Attach form key
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Receiver Information',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Divider(color: myHexColor),

                          // Name Input
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              suffixIcon: showNameError
                                  ? Icon(Icons.error,
                                      color: Colors
                                          .red) // Show error icon when empty
                                  : null,
                            ),
                          ),

                          // Mobile Number Input
                          TextFormField(
                            controller: mobileNumberController,
                            decoration: InputDecoration(
                              labelText: 'Mobile Number',
                              suffixIcon: showMobileError
                                  ? Icon(Icons.error,
                                      color: Colors
                                          .red) // Show error icon when empty
                                  : null,
                            ),
                            keyboardType: TextInputType.phone,
                          ),

                          SizedBox(height: 10),

                          // ID Type Dropdown
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Beneficiary ID Type',
                            ),
                            value: idType,
                            items: dropdownItems['ab-sm-id-type'] ?? [],
                            onChanged: (value) {
                              setState(() {
                                idType = value;
                              });
                            },
                          ),

                          // ID Number Input
                          TextFormField(
                            controller: idController,
                            decoration: InputDecoration(
                              labelText: 'Enter ID Number',
                              suffixIcon: showIdError
                                  ? Icon(Icons.error,
                                      color: Colors
                                          .red) // Show error icon when empty
                                  : null,
                            ),
                            keyboardType: TextInputType.number,
                          ),

                          // Transfer Amount Input
                          TextFormField(
                            controller: amountController,
                            decoration: InputDecoration(
                              labelText: 'Transfer Amount',
                              suffixIcon: showAmountError
                                  ? Icon(Icons.error,
                                      color: Colors
                                          .red) // Show error icon when empty
                                  : null,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                enteredAmount = value;
                              });
                            },
                          ),

                          SizedBox(height: 8),
                          // Note Input
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: myHexColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Add a Note',
                                labelStyle: TextStyle(color: myHexColor),
                                alignLabelWithHint: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              maxLines: 3,
                              onChanged: (value) {},
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),

      // Pay Button with Validation
      bottomNavigationBar: enteredAmount.isNotEmpty
          ? AnimatedContainer(
              duration: Duration(milliseconds: 300),
              transform: Matrix4.translationValues(
                  0, keyboardHeight > 0 ? -keyboardHeight : 0, 0),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text("ETB $enteredAmount",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold)),
                        SizedBox(width: 130.0),
                        Container(
                            height: 24.0, width: 1.0, color: Colors.black),
                        SizedBox(width: 16.0),
                        Text(
                          "**** ${widget.transactionType == 'Wallet' ? widget.loginResponse?.headerInfo.wallet_account_no?.substring(widget.loginResponse!.headerInfo.wallet_account_no!.length - 4) : widget.loginResponse?.headerInfo.cb_account_no?.substring(widget.loginResponse!.headerInfo.cb_account_no!.length - 4)}",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myHexColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                    onPressed: () {
                      setState(() {
                        showNameError = nameController.text.isEmpty;
                        showMobileError = mobileNumberController.text.isEmpty;
                        showIdError = idController.text.isEmpty;
                        showAmountError = amountController.text.isEmpty;
                      });

                      if (!showNameError &&
                          !showMobileError &&
                          !showIdError &&
                          !showAmountError) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthenticationScreen(
                              enteredAmount: enteredAmount,
                              name: nameController.text,
                              mobileNumber: mobileNumberController.text,
                              idType: idType,
                              idNumber: idController.text,
                              loginResponse: widget.loginResponse,
                              itemKey: widget.itemKey,
                              transactionType: widget.transactionType,
                              commWalletAccountRequest: null,
                              commAccountRequest: widget.commAccountRequest,
                              selectedBank: widget.selectedBank,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('Pay',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            )
          : null,
    );
  }
}
