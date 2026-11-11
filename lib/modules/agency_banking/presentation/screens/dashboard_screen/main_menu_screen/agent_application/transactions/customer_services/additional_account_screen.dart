import 'package:citizenone_app/modules/agency_banking/constants/AppStrings.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/BannerContent.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/additional_account_bloc/additional_account_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/additional_account_bloc/additional_account_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/additional_account_bloc/additional_account_state.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../data/models/CommAccountRequest.dart';
import '../../../../../../../data/models/CommTransaction.dart';
import '../../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../../../data/models/login_models/UserOtpValidationInfo.dart';
import '../../../../../../../data/models/lov_models/AbLovs.dart';
import '../../../../../../../data/models/lov_models/AbLovsMaster.dart';
import '../../../../../../../data/services/AuthService.dart';
import '../../../../../../../utils/CommDialog.dart';
import '../../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../../../utils/ResponsiveLeftBanner.dart';
import '../../../../../../blocs/account_search_bloc/account_search_bloc.dart';
import '../../../../../../blocs/account_search_bloc/account_search_event.dart';
import '../../../../../../blocs/account_search_bloc/account_search_state.dart';
import '../../../../../../blocs/forgot_password_bloc/forgot_password_bloc.dart';
import '../../../../../../blocs/forgot_password_bloc/forgot_password_event.dart';
import '../../../../../../blocs/forgot_password_bloc/forgot_password_state.dart';
import '../../../../../../blocs/get_lov_bloc/get_lov_bloc.dart';
import '../../../../../../blocs/get_lov_bloc/get_lov_event.dart';
import '../../../../../../blocs/get_lov_bloc/get_lov_state.dart';

class AdditionalAccountScreen extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final dynamic itemKey;

  const AdditionalAccountScreen({
    required this.loginResponse,
    required this.itemKey,
  });
  @override
  _AdditionalAccountScreen createState() => _AdditionalAccountScreen();
}

CommAccountRequest accRequest = CommAccountRequest();

class _AdditionalAccountScreen extends State<AdditionalAccountScreen> {
  Color myHexColor = Color(0xff5c7d33);
  final TextEditingController accountController = TextEditingController();
  final AuthService authService = AuthService();
  CommAccountRequest? accountRequest;
  late GetLovBloc lovBloc;
  Map<String, List<DropdownMenuItem<String>>> dropdownItems = {};
  String? branch;
  String? accountClass;
  String? currencyType;
  String? location;
  String? media;
  bool isButtonEnabled = false; // Track if the button is enabled
  TextEditingController _pinController = TextEditingController();
  String? selectedOption;
  UserOTPValidationInfo? validateOtp;

  // Get today's date formatted as dd/MM/yyyy
  String getCurrentDate() {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    // Initialize GetLovBloc once
    lovBloc = GetLovBloc(authService);
  }

  void validateForm() {
    // Check if all required fields are filled
    setState(() {
      isButtonEnabled = branch != null &&
          accountClass != null &&
          currencyType != null &&
          location != null &&
          media != null &&
          accountController.text.isNotEmpty;
    });
  }

  void getOtp() {
    UserOTPValidationInfo request = UserOTPValidationInfo();
    request.headerInfo = widget.loginResponse.headerInfo;
    request.mobileNo = widget.loginResponse.loginUserInfo.userName ?? "";
    request.userName = widget.loginResponse.loginUserInfo.userName ?? "";
    context.read<ForgotPasswordBloc>().add(ForgotPasswordSubmitted(request));
  }

  void _validatePin(BuildContext context) async {
    final pin = _pinController.text; // Null-safe trim

    if (pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter Pin')),
      );
      return;
    }
    if (pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pin must be exactly 6 digits')),
      );
      return;
    }
    CommTransaction req = CommTransaction();
    req.headerInfo = widget.loginResponse.headerInfo;
    req.dMob = widget.loginResponse.loginUserInfo.userName;
    req.custPin = _pinController.text;
    final response = await authService.pinValidation(req);
    if (response != null &&
        response.resMessage?.errorCode == "AB-ATTEMPT-100") {
      isButtonEnabled = true;
    }
  }

  void _submitOtp(BuildContext context) async {
    final otp = _pinController.text; // Null-safe trim

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter OTP')),
      );
      return;
    }
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP must be exactly 6 digits')),
      );
      return;
    }
    UserOTPValidationInfo otpInfo = UserOTPValidationInfo();
    otpInfo.otp = _pinController.text;
    otpInfo.otpuniqueid = validateOtp
        ?.otpuniqueid; // Use stored otpuniqueid from the first API response
    otpInfo.mobileNo = widget.loginResponse.loginUserInfo.userName ?? "";
    otpInfo.userName = widget.loginResponse.loginUserInfo.userName ?? "";
    otpInfo.headerInfo.message = "SKIP_SESSION";
    final response = await authService.otpFailedValidation(otpInfo);
    if (response != null && response.resMessage.errorCode == "AB-ATTEMPT-100") {
      isButtonEnabled = true;
    }
  }

  void _showBottomPopupWithInput(BuildContext context) {
    ValueNotifier<bool> showRadioButtons =
        ValueNotifier<bool>(false); // State to toggle view
    String labelText = "ENTER OTP"; // Initial text for the label
    bool isSubmitEnabled = false; // State for submit button
    String enteredInput = ""; // To hold the entered OTP or PIN

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: myHexColor),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
                top: 16.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    labelText, // Dynamically updated text
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Pinput(
                    autofocus: false,
                    controller: _pinController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onChanged: (pin) {
                      setState(() {
                        enteredInput = pin;
                        isSubmitEnabled = pin.length == 6;
                      });
                    },
                    onCompleted: (pin) {
                      setState(() {
                        enteredInput = pin;
                      });
                      if (labelText == 'ENTER OTP') {
                        // Call Submit OTP API
                        _submitOtp(context);
                      } else if (labelText == 'ENTER PIN') {
                        // Call Validate PIN API
                        _validatePin(context);
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  ValueListenableBuilder<bool>(
                    valueListenable: showRadioButtons,
                    builder: (context, isVisible, child) {
                      if (isVisible) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RadioListTile<String>(
                              title: Text('OTP',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 20)),
                              value: 'OTP',
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;
                                  labelText = "ENTER OTP"; // Update label text
                                  _pinController
                                      .clear(); // Clear input when switching
                                  isSubmitEnabled =
                                      false; // Disable submit button
                                  getOtp();
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text('PIN',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 20)),
                              value: 'PIN',
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;
                                  labelText = "ENTER PIN"; // Update label text
                                  _pinController
                                      .clear(); // Clear input when switching
                                  isSubmitEnabled =
                                      false; // Disable submit button
                                });
                              },
                            ),
                          ],
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            showRadioButtons.value = true;
                          },
                          child: Text(
                            'Authentication Type',
                            style: TextStyle(
                              color: AppColors.fbLiteDark,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: buildActionButton(
                      label: 'Submit',
                      onPressed: isSubmitEnabled
                          ? () {
                              CommAccountRequest request = CommAccountRequest();
                              request.headerInfo =
                                  widget.loginResponse.headerInfo;
                              request.accCcy = currencyType!;
                              request.accountType = accountRequest!.accountType;
                              request.accoutClass = accountClass!;
                              request.branch = branch!;
                              request.customerId = accountRequest!.customerId;
                              request.customerName =
                                  accountRequest!.customerName;
                              request.location = location!;
                              request.media = media!;
                              request.phoneNum = accountRequest!.mobileno;

                              context.read<AdditionalAccountBloc>().add(
                                    AdditionalAccountSubmitted(request),
                                  );
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final List<BannerContent> banners = [
      BannerContent(
        imagePath: "assets/images/home_loan.jpg",
        title: AppStrings.bannerTitle,
        headline: AppStrings.bannerHeading,
        subtitle: AppStrings.bannerSubtitle,
        ctaText: AppStrings.bannerCreateText,
        onCtaPressed: () {
          AppLogger.debug('Retail account banner clicked');
        },
      ),
    ];

    return Scaffold(
        appBar: const CustomAppBar(title: "Additional Account"),
        body: Row(children: [
          if (!isMobile) ResponsiveLeftBanner(banners: banners),
          Expanded(
            child: BlocConsumer<AccountSearchBloc, AccountSearchState>(
              listener: (context, state) {
                if (state is AccountSearchSuccess) {
                  setState(() {
                    accountRequest =
                        state.commAccountRequest; // Store API response
                  });
                  var permission =
                      widget.loginResponse.loginUserInfo.permission;
                  permission?.remove('MAIN_MENU');
                  AbLovsMaster request = AbLovsMaster();
                  request.headerInfo = widget.loginResponse.headerInfo;

                  // Step 2: Create AbLovs instances for each module and add them to the request
                  AbLovs smLov = AbLovs(module: "AB_LOV_CUST", genLovs: null);
                  request.abLovs = [smLov];
                  // Step 3: Dispatch the GetLovSubmitted event with the combined request
                  lovBloc.add(GetLovSubmitted(request));
                } else if (state is AccountSearchFailure) {
                  showCustomBottomPopup(context, state.error);
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              MultiBlocListener(
                                listeners: [
                                  BlocListener<GetLovBloc, GetLovState>(
                                    bloc: lovBloc,
                                    listener: (context, state) {
                                      if (state is GetLovSuccess) {
                                        for (var abLov in state.user.abLovs) {
                                          for (var genLov
                                              in abLov.genLovs ?? []) {
                                            String lovId = genLov.lovId;
                                            if (genLov.valDes != null) {
                                              dropdownItems[lovId] =
                                                  genLov.valDes!.map<
                                                      DropdownMenuItem<String>>(
                                                (valDes) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: valDes.val,
                                                    child: Text(valDes.desc),
                                                  );
                                                },
                                              ).toList();
                                            }
                                          }
                                        }
                                        setState(() {});
                                      }
                                    },
                                  ),
                                  BlocListener<ForgotPasswordBloc,
                                      ForgotPasswordState>(
                                    listener: (context, state) {
                                      if (state is ForgotPasswordSuccess) {
                                        setState(() {
                                          validateOtp = state.userOtp;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'OTP validated successfully!')),
                                        );
                                      } else if (state
                                          is ForgotPasswordFailure) {
                                        showCustomBottomPopup(
                                            context, state.error);
                                      }
                                    },
                                  ),
                                  BlocListener<AdditionalAccountBloc,
                                      AdditionalAccountState>(
                                    listener: (context, state) {
                                      if (state is AdditionalAccountSuccess) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Account Created successfully!')),
                                        );
                                      } else if (state
                                          is AdditionalAccountFailure) {
                                        showCustomBottomPopup(
                                            context, state.error);
                                      }
                                    },
                                  ),
                                ],
                                child: Column(children: [
                                  Card(
                                    elevation: 2,
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          // Account Number Field inside the card
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextField(
                                                      controller:
                                                          accountController,
                                                      onChanged: (value) =>
                                                          validateForm(),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Enter Account Number',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    width: 1.5,
                                                    color: Colors.black,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.search,
                                                        color: Colors.black),
                                                    onPressed: () {
                                                      accRequest =
                                                          CommAccountRequest();
                                                      accRequest.headerInfo =
                                                          widget.loginResponse
                                                              .headerInfo;
                                                      accRequest.accountNum =
                                                          accountController
                                                              .text;
                                                      context
                                                          .read<
                                                              AccountSearchBloc>()
                                                          .add(
                                                            AccountSearchSubmitted(
                                                                accRequest),
                                                          );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (state is AccountSearchLoading)
                                            Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          if (state is AccountSearchSuccess &&
                                              accountRequest != null) ...[
                                            SizedBox(height: 20),
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.teal,
                                                  radius: 20,
                                                  child: Text(
                                                    accountRequest!
                                                        .customerName[0]
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      accountRequest!
                                                          .customerName,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      accountRequest!
                                                          .accountNum,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      accountRequest!.mobileno,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Divider(
                                                height: 10,
                                                color: Colors.black),
                                            SizedBox(height: 15),
                                            DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                labelText: 'Branch',
                                                labelStyle: TextStyle(
                                                    color: Colors.black),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2.0),
                                                ),
                                              ),
                                              value: branch,
                                              items:
                                                  dropdownItems['ab-cust-brn'],
                                              onChanged: (String? value) {
                                                setState(() {
                                                  branch = value!;
                                                });
                                                validateForm();
                                              },
                                            ),

                                            SizedBox(height: 15),
                                            DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                labelText: 'Currency type',
                                                labelStyle: TextStyle(
                                                    color: Colors.black),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2.0),
                                                ),
                                              ),
                                              value: currencyType,
                                              items: dropdownItems[
                                                      'ab-cust-currency'] ??
                                                  [], // Map to lovId 'ab-cust-gender'
                                              onChanged: (value) {
                                                setState(() {
                                                  currencyType =
                                                      value as String;
                                                });
                                                validateForm();
                                              },
                                            ),
                                            SizedBox(height: 15),
                                            DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                labelText: 'Account class',
                                                labelStyle: TextStyle(
                                                    color: Colors.black),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2.0),
                                                ),
                                              ),
                                              value: accountClass,
                                              items: dropdownItems[
                                                      'ab-acc-class'] ??
                                                  [],
                                              onChanged: (value) {
                                                setState(() {
                                                  accountClass =
                                                      value as String;
                                                });
                                                validateForm();
                                              },
                                            ),
                                            SizedBox(height: 15),
                                            DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                labelText: 'Location',
                                                labelStyle: TextStyle(
                                                    color: Colors.black),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2.0),
                                                ),
                                              ),
                                              value: location,
                                              items: dropdownItems[
                                                      'ab-cust-location'] ??
                                                  [], // Map to lovId 'ab-cust-gender'
                                              onChanged: (value) {
                                                setState(() {
                                                  location = value as String;
                                                });
                                                validateForm();
                                              },
                                            ),
                                            SizedBox(height: 15),
                                            DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                labelText: 'Media',
                                                labelStyle: TextStyle(
                                                    color: Colors.black),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2.0),
                                                ),
                                              ),
                                              value: media,
                                              items: dropdownItems[
                                                      'ab-cust-media'] ??
                                                  [], // Map to lovId 'ab-cust-gender'
                                              onChanged: (value) {
                                                setState(() {
                                                  media = value as String;
                                                });
                                                validateForm();
                                              },
                                            ),
                                            SizedBox(height: 15),
                                            // Account Creation Date field
                                            TextFormField(
                                              initialValue: getCurrentDate(),
                                              enabled: false,
                                              // Make this field non-editable
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Account Creation Date',
                                                labelStyle: TextStyle(
                                                    color: Colors.black),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (state is AccountSearchSuccess && accountRequest != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 8.0),
                        child: Center(
                          child: buildActionButton(
                            label: 'Next',
                            onPressed: isButtonEnabled
                                ? () {
                                    _showBottomPopupWithInput(context);
                                    getOtp();
                                  }
                                : null, // disables the button
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          )
        ]));
  }
}
