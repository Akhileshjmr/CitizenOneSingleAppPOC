import 'dart:convert';
import 'dart:io';

import 'package:citizenone_app/modules/agency_banking/data/models/CommCustImageSign.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommCustImageSignList.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/WalletKycCustomerReq.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/logic/customer_information_controllers.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_upload_bloc/kyc_upload_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_registration_bloc/wallet_registration_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_registration_bloc/wallet_registration_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_registration_bloc/wallet_registration_state.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../data/models/CommCustDoc.dart';
import '../../../../../../../data/models/CommKycUpload.dart';
import '../../../../../../../data/models/lov_models/AbLovs.dart';
import '../../../../../../../data/models/lov_models/AbLovsMaster.dart';
import '../../../../../../../theme/colors/Appcolors.dart';
import '../../../../../../../utils/CommDialog.dart';
import '../../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../../blocs/get_lov_bloc/get_lov_bloc.dart';
import '../../../../../../blocs/get_lov_bloc/get_lov_event.dart';
import '../../../../../../blocs/get_lov_bloc/get_lov_state.dart';
import '../../../../../../blocs/image_upload_bloc/image_upload_bloc.dart';
import '../../../../../../blocs/image_upload_bloc/image_upload_event.dart';
import '../../../../../../blocs/kyc_upload_bloc/kyc_upload_bloc.dart';
import '../../../../../../blocs/kyc_upload_bloc/kyc_upload_event.dart';
import '../../../../../BaseScreen/base_screen.dart';

class WalletKYC extends StatefulWidget {
  final LoginUserReqResInfo? loginResponse;
  final dynamic itemKey;
  WalletKYC({
    this.loginResponse,
    this.itemKey,
  });
  @override
  _WalletKYCState createState() => _WalletKYCState();
}

class _WalletKYCState extends State<WalletKYC> {
  @override
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Agent Registration",
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            indicatorWeight: 4.0,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_balance_wallet, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'Agent Info',
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'Image Upload',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WalletAccountPage(loginResponse: widget.loginResponse),
            ImageUploadPage(loginResponse: widget.loginResponse),
          ],
        ),
      ),
    );
  }
}

class WalletAccountPage extends StatefulWidget {
  final LoginUserReqResInfo? loginResponse;
  const WalletAccountPage({this.loginResponse});
  @override
  _WalletAccountPageState createState() => _WalletAccountPageState();
}

class _WalletAccountPageState extends BaseScreenState<WalletAccountPage> {
  Map<String, List<DropdownMenuItem<String>>> dropdownItems = {};
  late GetLovBloc lovBloc;
  bool _isChecked = false;
  String? gender;
  String? nationality;
  String? countryCodes;
  Uint8List? imageBytes;
  Uint8List? uploadedImage;
  String? custType;
  String? accType;
  String? idType;
  Uint8List? capturedImageBytes;
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController mnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController custAverageMonthlyIncomeController =
      TextEditingController();
  final TextEditingController custAverageAnnualIncomeController =
      TextEditingController();
  final TextEditingController custAddress1Controller = TextEditingController();
  final TextEditingController custAddress2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController residentialNumberController =
      TextEditingController();
  final TextEditingController officeNumberController = TextEditingController();
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController issuedByController = TextEditingController();
  String? customerId;

  @override
  void initState() {
    super.initState();
    var permission = widget.loginResponse?.loginUserInfo.permission;
    permission?.remove('MAIN_MENU');
    // Initialize GetLovBloc once
    lovBloc = GetLovBloc(AuthService());
    AbLovsMaster request = AbLovsMaster();
    request.headerInfo = widget.loginResponse!.headerInfo;
    // Step 2: Create AbLovs instances for each module and add them to the request
    AbLovs smLov = AbLovs(module: "AB_LOV_WALLET", genLovs: null);
    request.abLovs = [smLov];
    // Step 3: Dispatch the GetLovSubmitted event with the combined request
    lovBloc.add(GetLovSubmitted(request));
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  void _showDocumentOptions(BuildContext context) {
    String? selectedTitle;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            items: (dropdownItems['ab-sm-id-type'] ?? []).toList(),
            onChanged: (value) {
              selectedTitle = value; // Store the selected value
            },
          ),
        );
      },
    ).then((_) {
      // This part will execute after the bottom sheet is closed
      if (selectedTitle != null) {
        // Call dialog only if a selection was made
        _showDocumentCaptureDialog(context, selectedTitle!);
      }
    });
  }

  void _showDocumentCaptureDialog(
      BuildContext outerContext, String documentName) {
    final ImagePicker picker = ImagePicker();
    final TextEditingController remarksController = TextEditingController();
    bool isRemarksEmpty = false;
    XFile? capturedImage;
    Uint8List? imageData;
    Future<void> openCamera(StateSetter setModalState) async {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        final File imageFile = File(image.path);
        imageData = await imageFile.readAsBytes();
        setModalState(() {
          capturedImage = image;
        });

        // Update the widget's state with the captured image
        setState(() {
          capturedImageBytes = imageData;
        });
      }
    }

    showDialog(
      context: outerContext, // Use the outer context here
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.fbLiteDark,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12.0)),
                ),
                child: Text(
                  documentName,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Document Name",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.0),
                    Text(documentName, textAlign: TextAlign.center),
                    SizedBox(height: 16.0),
                    Text("Remarks",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: remarksController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        errorText: isRemarksEmpty ? 'Remark is required' : null,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    const Text("Capture Document:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () => openCamera(setModalState),
                      child: capturedImage == null
                          ? Icon(Icons.camera_alt,
                              size: 60, color: Colors.black)
                          : Image.file(
                              File(capturedImage!.path),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Upload"),
                  onPressed: () {
                    if (remarksController.text.isEmpty) {
                      setModalState(() {
                        isRemarksEmpty = true;
                        uploadedImage = imageBytes;
                      });
                    } else {
                      CommKycUpload kycUpload = CommKycUpload();
                      kycUpload.documentName = documentName;
                      kycUpload.documentType = documentName;
                      kycUpload.image =
                          imageData != null ? base64.encode(imageData!) : null;
                      kycUpload.uploadtype = 'WALLET_KYC_UP';
                      kycUpload.docUniqueNum = '1234';
                      kycUpload.remarks = remarksController.text;
                      kycUpload.headerInfo =
                          widget.loginResponse!.headerInfo; // Pass headerInfo
                      outerContext
                          .read<KycUploadBloc>()
                          .add(KycUploadSubmitted(kycUpload));
                      Navigator.of(context).pop();
                    }
                  },
                ),
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: AppColors.fbLiteDark,
            colorScheme: ColorScheme.light(
              primary: AppColors.fbLiteDark,
              onPrimary: Colors.white,
              onSurface: AppColors.fbLiteDark,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetLovBloc, GetLovState>(
            bloc: lovBloc,
            listener: (context, state) {
              if (state is GetLovSuccess) {
                AppLogger.debug('LOV data received for wallet registration');
                for (var abLov in state.user.abLovs) {
                  for (var genLov in abLov.genLovs ?? []) {
                    String lovId = genLov.lovId; // Access lovId directly
                    if (genLov.valDes != null) {
                      dropdownItems[lovId] = genLov.valDes!
                          .map<DropdownMenuItem<String>>((valDes) {
                        return DropdownMenuItem<String>(
                          value: valDes.val,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(valDes.desc,
                                overflow: TextOverflow.ellipsis),
                          ),
                        );
                      }).toList();
                    }
                  }
                }
                setState(() {});
              } else if (state is GetLovFailure) {
                showCustomBottomPopup(context, state.error);
              }
            }),
        BlocListener<WalletRegistrationBloc, WalletRegistrationState>(
          listener: (context, state) {
            if (state is WalletRegistrationSuccess) {
              customerId = state.walletRequest.walletAccountNo;
              showWalletRegistrationSuccess(context, customerId);
            } else if (state is WalletRegistrationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
        BlocListener<KycUploadBloc, KycUploadState>(
          listener: (context, state) {
            if (state is KycUploadSuccess) {
              showDocumentUploadSuccess(context, state.user.documentName);
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Document Name:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    state.user.documentName ?? "N/A",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Remarks:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    state.user.remarks ?? "N/A",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  if (state.user.image != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Uploaded Document:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Image.memory(
                          base64.decode(state.user.image!),
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ],
                    )
                  else
                    Text(
                      "No image uploaded.",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                ],
              );
            } else if (state is KycUploadFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
      ],
      child: SingleChildScrollView(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unified Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Details Section
                    Text(
                      textAlign: TextAlign.left,
                      'Basic Details',
                      style: TextStyle(
                        color: AppColors.fbLiteDark,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: fnameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 35.0),
                        Expanded(
                          child: TextField(
                            controller: mnameController,
                            decoration: InputDecoration(
                              labelText: 'Middle Name',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: lnameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 35.0),
                        Expanded(
                          child: TextField(
                            controller: _dobController,
                            decoration: InputDecoration(
                              labelText: 'Date of Birth',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                            onTap: () {
                              // FocusScope.of(context).requestFocus(FocusNode());
                              _selectDate(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                            value: gender,
                            items: dropdownItems['ab-cust-gender'] ??
                                [], // Map to lovId 'ab-cust-gender'
                            onChanged: (value) {
                              setState(() {
                                gender = value as String;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 35.0),
                        Expanded(
                          child: DropdownSearch<String>(
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Nationality',
                                labelStyle:
                                    TextStyle(color: AppColors.fbLiteDark),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.fbLiteDark, width: 2.0),
                                ),
                              ),
                            ),
                            // Format items as "value - description" strings to avoid direct indexing
                            items: (dropdownItems['ab-cust-nationality'] ?? [])
                                .map((item) => (item.value) as String)
                                .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                nationality = value; // Update the state
                              });
                            },
                            selectedItem:
                                nationality, // Display the current value
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                autofocus: false,
                                decoration: InputDecoration(
                                  labelText: "Search",
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                              showSelectedItems: true,
                              fit: FlexFit.tight,
                              containerBuilder: (ctx, popupWidget) => Column(
                                children: [
                                  Expanded(child: popupWidget),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      child: Text("Close"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Residential Address Section
                    Text(
                      textAlign: TextAlign.left,
                      'Residential Address',
                      style: TextStyle(
                        color: AppColors.fbLiteDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: custAddress1Controller,
                      decoration: InputDecoration(
                        labelText: 'House No',
                        labelStyle: TextStyle(color: Colors.black54),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.fbLiteDark, width: 2.0),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: custAddress1Controller,
                            decoration: InputDecoration(
                              labelText: 'Sub City',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 35.0),
                        Expanded(
                          child: TextField(
                            controller: cityController,
                            decoration: InputDecoration(
                              labelText: 'City',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: zipController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Zip',
                              labelStyle:
                                  const TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 35.0),
                        Expanded(
                          child: DropdownSearch<String>(
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Country',
                                labelStyle:
                                    TextStyle(color: AppColors.fbLiteDark),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.fbLiteDark, width: 2.0),
                                ),
                              ),
                            ),
                            // Format items as "value - description" strings to avoid direct indexing
                            items: (dropdownItems['ab-cust-nationality'] ?? [])
                                .map((item) => (item.value) as String)
                                .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                nationality = value; // Update the state
                              });
                            },
                            selectedItem:
                                nationality, // Display the current value
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                autofocus: false,
                                decoration: InputDecoration(
                                  labelText: "Search",
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                              showSelectedItems: true,
                              fit: FlexFit.tight,
                              containerBuilder: (ctx, popupWidget) => Column(
                                children: [
                                  Expanded(child: popupWidget),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      child: Text("Close"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Contact Details Section
                    Text(
                      textAlign: TextAlign.left,
                      'Contact Details',
                      style: TextStyle(
                        color: AppColors.fbLiteDark,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownSearch<String>(
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Nationality',
                                labelStyle:
                                    TextStyle(color: AppColors.fbLiteDark),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.fbLiteDark, width: 2.0),
                                ),
                              ),
                            ),
                            // Format items as "value - description" strings to avoid direct indexing
                            items: (dropdownItems['ab-country-codes'] ?? [])
                                .map((item) => (item.value) as String)
                                .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                countryCodes = value; // Update the state
                              });
                            },
                            selectedItem:
                                countryCodes, // Display the current value
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                autofocus: false,
                                decoration: InputDecoration(
                                  labelText: "Search",
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                              showSelectedItems: true,
                              fit: FlexFit.tight,
                              containerBuilder: (ctx, popupWidget) => Column(
                                children: [
                                  Expanded(child: popupWidget),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      child: Text("Close"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 35.0),
                        Expanded(
                          child: TextField(
                            controller: mobileNumber,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Mobile Number',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: residentialNumberController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Residential Number ',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 35.0),
                        Expanded(
                          child: TextField(
                            controller: officeNumberController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Office Number ',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    // Occupation Section
                    Text(
                      textAlign: TextAlign.left,
                      'Occupation',
                      style: TextStyle(
                        color: AppColors.fbLiteDark,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Designation',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 35.0),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Employer',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: custAverageMonthlyIncomeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Average Monthly Income',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 35.0),
                        Expanded(
                          child: TextField(
                            controller: custAverageAnnualIncomeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Average Annual Income',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Customer Type',
                        labelStyle: TextStyle(color: Colors.black54),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.fbLiteDark, width: 2.0),
                        ),
                      ),
                      value: custType,
                      items: dropdownItems['wallet_cust_type'] ?? [],
                      onChanged: (value) {
                        setState(() {
                          custType = value!;
                        });
                      },
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Account Type',
                        labelStyle: TextStyle(color: Colors.black54),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.fbLiteDark, width: 2.0),
                        ),
                      ),
                      value: accType,
                      items: dropdownItems['ab_acc_type'] ?? [],
                      onChanged: (value) {
                        setState(() {
                          accType = value!;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    // ID Details Section
                    Text(
                      textAlign: TextAlign.left,
                      'ID Details',
                      style: TextStyle(
                        color: AppColors.fbLiteDark,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownSearch<String>(
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'Id Type',
                          labelStyle: TextStyle(color: AppColors.fbLiteDark),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.fbLiteDark, width: 2.0),
                          ),
                        ),
                      ),
                      // Format items as "value - description" strings to avoid direct indexing
                      items: (dropdownItems['ab-sm-id-type'] ?? [])
                          .map((item) => (item.value) as String)
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          idType = value; // Update the state
                        });
                      },
                      selectedItem: idType, // Display the current value

                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          autofocus: false,
                          decoration: InputDecoration(
                            labelText: "Search",
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                        showSelectedItems: true,
                        fit: FlexFit.tight,
                        containerBuilder: (ctx, popupWidget) => Column(
                          children: [
                            Expanded(child: popupWidget),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                child: Text("Close"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: idNumberController,
                            decoration: InputDecoration(
                              labelText: 'ID Number ',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 35.0),
                        Expanded(
                          child: TextField(
                            controller: issuedByController,
                            decoration: InputDecoration(
                              labelText: 'Issued By',
                              labelStyle: TextStyle(color: Colors.black54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.fbLiteDark, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

// CBS Account Linkage Section
                    Text(
                      textAlign: TextAlign.left,
                      'CBS Account Linkage',
                      style: TextStyle(
                        color: AppColors.fbLiteDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                        ),
                        Text(
                          'CBS Account Link',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload KYC Document',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.fbLiteDark,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: OutlinedButton.icon(
                            icon: Icon(Icons.upload_file,
                                color: AppColors.fbLiteDark),
                            label: Text(
                              'Upload Document',
                              style: TextStyle(color: Colors.black54),
                            ),
                            onPressed: () {
                              _showDocumentOptions(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: AppColors.fbLiteDark, width: 2.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 28.0, vertical: 20.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        BlocBuilder<KycUploadBloc, KycUploadState>(
                          builder: (context, state) {
                            if (state is KycUploadSuccess) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text Data Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Document Name
                                        Text(
                                          "Selected Document Name:",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          state.user.documentName ?? "N/A",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        SizedBox(height: 16),

                                        // Remarks
                                        Text(
                                          "Remarks:",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          state.user.remarks ?? "N/A",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        SizedBox(height: 16),

                                        // Document Unique Number
                                        Text(
                                          "Document Unique Number:",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          state.user.docUniqueNum ?? "N/A",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),

                                  // Uploaded Image Column
                                  if (capturedImageBytes != null)
                                    Column(
                                      children: [
                                        Text(
                                          "Uploaded Document:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        SizedBox(height: 8),
                                        Image.memory(
                                          Uint8List.fromList(
                                              capturedImageBytes as List<int>),
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    )
                                  else
                                    Text(
                                      "No image uploaded.",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 14),
                                    ),
                                ],
                              );
                            } else if (state is KycUploadFailure) {
                              return Text(
                                "Upload failed: ${state.error}",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              );
                            }
                            return SizedBox(); // Default state
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            SizedBox(height: 10.0),

            // Submit Button
            Center(
              child: buildActionButton(
                label: "Submit",
                onPressed: () {
                  walletCreation(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void walletCreation(BuildContext context) {
    WalletKycCustomerReq request = WalletKycCustomerReq();
    request.headerInfo = widget.loginResponse?.headerInfo;
    // Basic Details
    request.fname = fnameController.text;
    request.mname = mnameController.text;
    request.lname = lnameController.text;
    request.gender = gender;
    request.nlty = nationality;
    // residential address
    request.custAddress1 = custAddress1Controller.text;
    request.custAddress2 = custAddress2Controller.text;
    request.custAddress3 = cityController.text;
    request.city = cityController.text;
    // request.zip=zipController.text;
    // request.country=country;
    // // Contact Details
    // request.mobNo=mobileNumber.text;
    // request.resNo=residentialNumberController.text;
    // request.officeNo=officeNumberController.text;
    // occupation
    // request.custAvgAnnualIncome=custAverageAnnualIncomeController.text;
    // request.custAvgMonthlyIncome=custAverageMonthlyIncomeController.text;
    request.custType = custType;
    request.acType = accType;
    // ID details
    request.idType = idType;
    request.idNo = idNumberController.text;
    request.idIssueby = issuedByController.text;
    // kyc upload
    CommCustDoc custDoc = CommCustDoc();
    custDoc.docUniqueNum = "1723783266804";
    custDoc.documentName = "HLTH CARD[20]";
    custDoc.documentType = "HLTH CARD[20]";
    custDoc.remarks = remarksController.text;
    custDoc.imgPath = imagePath;
    request.custDoc?.add(custDoc);

    ///
    request.walletAccEnable = "Y";
    request.cbsAccEnable = "N";
    request.beforeorAfterlogin = "N";
    request.currency = "Currency";
    request.customerId = "Customer Id";
    context
        .read<WalletRegistrationBloc>()
        .add(WalletRegistrationSubmitted(request));
  }
}

class ImageUploadPage extends StatefulWidget {
  final LoginUserReqResInfo? loginResponse;
  const ImageUploadPage({this.loginResponse});
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final ImagePicker _picker = ImagePicker();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Uint8List? _signatureImage; // Variable to store the signature image
  Uint8List? _capturedImage; // Variable to store the captured image
  bool _isTermsAccepted = false; // Variable to track the checkbox state
  Uint8List? capturedImageBytes;
  XFile? image;

  Future<void> _openCamera() async {
    image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final File imageFile = File(image!.path); // Add the null check
      _capturedImage = await imageFile.readAsBytes();
      setState(() {
        capturedImageBytes = _capturedImage;
      });
      AppLogger.info(
          'Image path: ${image!.path}'); // Use null-aware operator or check
    }
  }

  void _openSignaturePad() {
    if (!_isTermsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please accept the terms and conditions before proceeding.',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.fbLiteDark),
                  ),
                  child: Signature(
                    controller: _signatureController,
                    backgroundColor: Colors.grey[200]!,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _signatureController
                              .clear(); // Clear the signature pad
                          _signatureImage =
                              null; // Clear the saved signature image
                        });
                      },
                      child: Text('Clear Pad',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fbLiteDark,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_signatureController.isNotEmpty) {
                          final signature =
                              await _signatureController.toPngBytes();
                          setState(() {
                            _signatureImage =
                                signature; // Save the signature image
                          });
                          Navigator.of(context).pop(); // Close the dialog
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fbLiteDark,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(fontSize: 16, color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Save Signature',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _openCamera,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: _capturedImage != null
                      ? Image.file(
                          File(image!.path), // Display the captured image
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/img_1.png',
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Take A Picture',
                style: TextStyle(
                    color: AppColors.fbLiteDark, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _openSignaturePad,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.fbLiteDark),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: _signatureImage != null
                      ? Image.memory(
                          _signatureImage!) // Display the signature if it exists
                      : Image.asset(
                          'assets/images/img_2.png',
                          fit: BoxFit
                              .contain, // Placeholder image if no signature
                        ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Draw Your Signature',
                style: TextStyle(
                    color: AppColors.fbLiteDark, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                height: 250, // Set a fixed height for the container
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      CheckboxListTile(
                        title: Text(
                          'I agree to the Terms and Conditions',
                          style: TextStyle(color: AppColors.fbLiteDark),
                        ),
                        value: _isTermsAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            _isTermsAccepted = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Terms and Conditions:\n\n'
                        'Declaration, I acknowledge that I have read and understood the Terms and Conditions and by executing this document, I agree and am bound by the Electronic Banking Terms and Conditions in my use of Mobile Banking Service.\n\n'
                        'I also acknowledge that the service provided by the Bank and my obligations under this agreement, in respect of the accounts nominated in this agreement are subject to the terms and conditions governing those accounts.\n\n'
                        'I acknowledge that my first use of Mobile Banking facility will indicate my acceptance of those Electronic Banking Terms and Conditions.\n\n'
                        'I confirm that the personal details provided are true and correct. I have received, read, and understand terms and conditions.\n\n'
                        'Usage of my card, account, or other banking services is acknowledgment that I accept the Terms and Conditions of use together with the corresponding risks.\n\n'
                        'I am responsible for all transactions using my Card/PIN and other electronic login credentials and am therefore required to keep this credentials confidential.\n\n'
                        'I accept Bank may use my personal details as per the Disclosure Statement.',
                        style: TextStyle(color: AppColors.fbLiteDark),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              buildActionButton(
                label: "Upload",
                onPressed: () {
                  sumbit_image(context);
                },
              ),
            ],
          ),
        )));
  }

  void sumbit_image(BuildContext context) {
    CommCustImageSign custImageSign = CommCustImageSign();
    custImageSign.docUniqueNum = "I";
    custImageSign.documentType = "Ok";
    custImageSign.documentName = "I";
    custImageSign.image =
        _capturedImage != null ? base64.encode(_capturedImage!) : null;
    CommCustImageSign custImageSign1 = CommCustImageSign();
    custImageSign1.docUniqueNum = "S";
    custImageSign1.documentType = "Ok";
    custImageSign1.documentName = "S";
    custImageSign1.image =
        _signatureImage != null ? base64.encode(_signatureImage!) : null;
    CommCustImageSignList commCustImageSignList = CommCustImageSignList();
    commCustImageSignList.headerInfo = widget.loginResponse?.headerInfo;
    commCustImageSignList.customerId = "W2025012305456";
    commCustImageSignList.transactionType = "WALLET_IMG_UPLOAD";
    commCustImageSignList.commCustImageSignList = [
      custImageSign,
      custImageSign1
    ];
    context
        .read<CustImageUploadBloc>()
        .add(CustImageUploadSubmitted(commCustImageSignList));
  }
}
