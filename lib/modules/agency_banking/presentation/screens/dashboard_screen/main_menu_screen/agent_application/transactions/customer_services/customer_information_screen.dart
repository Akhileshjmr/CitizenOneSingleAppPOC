/*
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommDateTimeUtils.dart';
import 'package:citizenone_app/modules/agency_banking/utils/UICleanupHelper.dart';
import 'package:citizenone_app/modules/agency_banking/utils/KeyboardUtils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../data/models/CommCustImageSign.dart';
import '../../../../../../../data/models/CommCustImageSignList.dart';
import '../../../../../../../data/models/lov_models/AbLovs.dart';
import '../../../../../../../data/models/lov_models/AbLovsMaster.dart';
import 'package:citizenone_app/modules/agency_banking/logic/customer_information_controllers.dart';
import '../../../../../../../data/models/CommCustDoc.dart';
import '../../../../../../../data/models/CommCustEnrollment.dart';
import '../../../../../../../data/models/CommKycUpload.dart';
import '../../../../../../../data/services/AuthService.dart';
import '../../../../../../../theme/colors/Appcolors.dart';
import '../../../../../../../utils/CommDialog.dart';
import '../../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../../../utils/RandomNumberGenerator.dart';
import '../../../../../../blocs/cust_enrollment_bloc/cust_enrollment_bloc.dart';
import '../../../../../../blocs/cust_enrollment_bloc/cust_enrollment_event.dart';
import '../../../../../../blocs/get_lov_bloc/get_lov_bloc.dart';
import '../../../../../../blocs/get_lov_bloc/get_lov_event.dart';
import '../../../../../../blocs/get_lov_bloc/get_lov_state.dart';
import '../../../../../../blocs/image_upload_bloc/image_upload_bloc.dart';
import '../../../../../../blocs/image_upload_bloc/image_upload_event.dart';
import '../../../../../../blocs/kyc_upload_bloc/kyc_upload_bloc.dart';
import '../../../../../../blocs/kyc_upload_bloc/kyc_upload_event.dart';
import '../../../../../../blocs/kyc_upload_bloc/kyc_upload_state.dart';
import '../../../../../BaseScreen/base_screen.dart';

class CustomerInformation extends StatefulWidget {
  final LoginUserReqResInfo loginResponse; // Pass the request object here
  const CustomerInformation({required this.loginResponse});

  @override
  _CustomerInformationState createState() => _CustomerInformationState();
}

class _CustomerInformationState extends State<CustomerInformation> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Customer Information",
          bottom: const TabBar(
            indicatorWeight: 4.0,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_wallet, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'CIF & Account Creation',
                      ),
                    ],
                  ),
                ),
              ),
              Tab(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Signature & Cust Image Upload',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CustomerAccountPage(request: widget.loginResponse),
            SignImageUploadPage(),
          ],
        ),
      ),
    );
  }
}

class CustomerAccountPage extends StatefulWidget {
  final LoginUserReqResInfo request;
  const CustomerAccountPage({required this.request});

  @override
  _CustomerAccountPageState createState() => _CustomerAccountPageState();
}
class _CustomerAccountPageState extends State<CustomerAccountPage> {

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passportIssueController = TextEditingController();
  final TextEditingController _passportExpiryController = TextEditingController();
  final TextEditingController _accountCreationController = TextEditingController();
  final TextEditingController _nomineeDobController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  bool _isSameAsCorrespondence = false;
  bool _trackLimit = true;
  bool _isCheckedInternetBanking = false;
  bool _isCheckedMobileBanking = false;
  bool _isCheckedResidentStatus = false;
  bool _isCheckedVisitedUs = false;
  bool _showGuardianField = false;
  Map<String, List<DropdownMenuItem<String>>> dropdownItems = {};
  Map<String, List<DropdownSearch<String>>> dropdownItems2 = {};
  late GetLovBloc lovBloc;

  @override
  void initState()
  {
    super.initState();
    var permission = widget.request.loginUserInfo.permission;
    lovBloc = GetLovBloc(AuthService());
    AbLovsMaster request = AbLovsMaster();
    request.headerInfo = widget.request.headerInfo;
    // Step 2: Create AbLovs instances for each module and add them to the request
    AbLovs custLov = AbLovs(module: "AB_LOV_CUST", genLovs: null);
    AbLovs smLov = AbLovs(module: "AB_LOV_SM", genLovs: null);
    request.abLovs = [custLov, smLov];
    // Step 3: Dispatch the GetLovSubmitted event with the combined request
    lovBloc.add(GetLovSubmitted(request));
  }
  void _updatePermanentAddress(bool isSame) {
    if (isSame) {
      permanentAddress1Controller.text = address1Controller.text;
      permanentAddress2Controller.text = address2Controller.text;
      permanentAddress3Controller.text = addressNameController.text;
      permanentCityController.text = cityController.text;
      permanentPincodeController.text = pincodeController.text;
    } else {
      permanentAddress1Controller.clear();
      permanentAddress2Controller.clear();
      permanentAddress3Controller.clear();
      permanentCityController.clear();
      permanentPincodeController.clear();
    }
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
  void _showDocumentCaptureDialog(BuildContext outerContext, String documentName) {
    final ImagePicker picker = ImagePicker();
    final TextEditingController remarksController = TextEditingController();
    bool isRemarksEmpty = false;
    XFile? capturedImage;
    Uint8List? imageBytes;
    Future<void> openCamera(StateSetter setModalState) async {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        final File imageFile = File(image.path);
        imageBytes = await imageFile.readAsBytes();
        setModalState(() {
          capturedImage = image;
        });
      }
    }

    showDialog(
      context: outerContext, // Use the outer context here
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              title: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.fbLiteDark,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
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
                    Text("Document Name", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.0),
                    Text(documentName, textAlign: TextAlign.center),
                    SizedBox(height: 16.0),
                    Text("Remarks", style: TextStyle(fontWeight: FontWeight.bold)),
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
                    const Text("Capture Document:", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () => openCamera(setModalState),
                      child: capturedImage == null
                          ? Icon(Icons.camera_alt, size: 60, color: Colors.black)
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
                    if (remarksController.text.isEmpty)
                    {
                      setModalState(() {
                        isRemarksEmpty = true;
                      });
                    }
                    else
                    {
                      CommKycUpload kycUpload = CommKycUpload();
                      kycUpload.documentName = documentName;
                      kycUpload.documentType = documentName;
                      kycUpload.image = imageBytes != null ? base64.encode(imageBytes!) : null;
                      kycUpload.uploadtype = 'CBS_KYC_UP';
                      kycUpload.docUniqueNum = '1234';
                      kycUpload.remarks = remarksController.text;
                      kycUpload.headerInfo = widget.request.headerInfo; // Pass headerInfo
                      outerContext.read<KycUploadBloc>().add(KycUploadSubmitted(kycUpload));
                      Navigator.of(context).pop();
                    }
                  },
                ),
                TextButton(
                  child:
                  const Text("Cancel"),
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
  void custEnoll(BuildContext outerContext)
  {
    CommCustEnrollment custEnroll=CommCustEnrollment();
    custEnroll.headerInfo=widget.request.headerInfo;

    //basic details
    custEnroll.cCateg=custCategeory;
    custEnroll.cType=customerTypeController.text;
    custEnroll.language=language;
    custEnroll.firstName=firstNameController.text;
    custEnroll.lastName=lastNameController.text;
    custEnroll.middleName=middleNameController.text;
    custEnroll.shortName=shortNameController.text;
    custEnroll.nationlity=nationality;
    custEnroll.titleName=title;
    custEnroll.gender=gender;
    custEnroll.birthCountry=birthCountry;
    custEnroll.birthplace=birthPlaceController.text;
    custEnroll.emailid=emailIdController.text;
    custEnroll.phoneNo=mobileNoController.text;
    custEnroll.maritalstatus=maritalStatus;
    custEnroll.custCommMode=commMode;
    custEnroll.media=media;
    custEnroll.dob=CommDateTimeUtils.convertsStringDateToDateFormateddmmyy(_dobController.text);
    custEnroll.pptIssuedDate=CommDateTimeUtils.convertsStringDateToDateFormateddmmyy(_passportIssueController.text);
    custEnroll.pptExpDate=CommDateTimeUtils.convertsStringDateToDateFormateddmmyy(_passportExpiryController.text);
    custEnroll.initTime=CommDateTimeUtils.convertsStringDateToDateFormateddmmyy(_accountCreationController.text);
    //professional
    //------------- address details
    custEnroll.zipcode=pincodeController.text;
    custEnroll.address1=address1Controller.text;
    custEnroll.address2=address2Controller.text;
    custEnroll.addressName=addressNameController.text;
    custEnroll.city=cityController.text;
    custEnroll.country=country;
    custEnroll.pAddr1=permanentAddress1Controller.text;
    custEnroll.pAddr2=permanentAddress2Controller.text;
    custEnroll.pCity=permanentAddress3Controller.text;
    custEnroll.pState=permanentCityController.text;
    custEnroll.pPinCode=permanentPincodeController.text;
    custEnroll.pState=permanentAddress3Controller.text;
    custEnroll.location=location;
    //------------ liability details
    custEnroll.trackLimits='Y';

    //-------------- channels
    custEnroll.mobileBanking=_isCheckedMobileBanking;
    custEnroll.internetBanking=_isCheckedInternetBanking;

    // ------------ account deatils
    custEnroll.accRequest?.accCcy = accCurrency ?? '';
    custEnroll.accRequest?.accoutClass = accClass ?? '';
    custEnroll.accRequest?.location = location ?? '';
    custEnroll.accRequest?.branch="000";
    custEnroll.accRequest?.createdDate = CommDateTimeUtils.convertsStringDateToDateFormateddmmyy(_accountCreationController.text)!;

    //------------- nominee details
    custEnroll.relShip=relationshipController.text;
    custEnroll.nAddr1=nAddress1Controller.text;
    custEnroll.nAddr2=nAddress2Controller.text;
    custEnroll.nAddr3=nAddress3Controller.text;
    custEnroll.nAddr4=nAddress4Controller.text;
    custEnroll.nName=nNameController.text;
    custEnroll.nDateofbirth=CommDateTimeUtils.convertsStringDateToDateFormateddmmyy(_nomineeDobController.text);
    custEnroll.nGaurdainName="abc";
    custEnroll.language=language;

    //  custom doc
    CommCustDoc custDoc=CommCustDoc();
    custDoc.docUniqueNum="1723783266804";
    custDoc.documentName="HLTH CARD[20]";
    custDoc.documentType="HLTH CARD[20]";
    custDoc.remarks=remarksController.text;
    custDoc.imgPath=imagePath;
    custEnroll.custDoc?.add(custDoc);
    custEnroll.enrollmentRefId=RandomNumberGenerator.generateId('ENAGENT',13);
    custEnroll.interntBankAcc='Y';
    custEnroll.isAccIncluded='Y';
    custEnroll.isJointCustomer='N';
    custEnroll.sameAsCorrAddr='N';
    custEnroll.usresstatus='N';
    custEnroll.vstusprev='N';
    custEnroll.countryCode= "218";
    custEnroll.cust_mode="ONLINE";
    custEnroll.lBrn= "000";
    custEnroll.liabBrn="000";
    custEnroll.liabBrn="000";
    custEnroll.liabCcy="ETB";
    custEnroll.liabName="Manu";
    custEnroll.mobBankAcc= "Y";
    custEnroll.mothermaidn_name= "likitha";
    custEnroll.pCity= "Address ";
    custEnroll.pptNo="124555BU";
    custEnroll.state= "Address ";
    // (custEnroll.accRequest?.toJson());
    outerContext.read<CustEnrollmentBloc>().add(CustEnrollmentSubmitted(custEnroll));
  }

  // Function to calculate age
  int _calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int age = today.year - dob.year;
    return age;
  }
  // Function to select date and update age conditionally
  Future<void> _nselectdate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _nomineeDobController.text = "${pickedDate.toLocal()}".split(' ')[0];
        int age = _calculateAge(pickedDate);
        _showGuardianField = age <18;
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
                              child: Text(valDes.desc, overflow: TextOverflow.ellipsis),
                            ),
                          );
                        }).toList();
                      }
                    }
                  }
                  setState(() {});
                }
                else if(state is GetLovFailure)
                {
                  showCustomBottomPopup(context, state.error);
                }
              }
          ),

          BlocListener<KycUploadBloc, KycUploadState>(
            listener: (context, state) {
              if (state is KycUploadSuccess) {
                imagePath=state.user.imgPath;
                showDocumentUploadSuccess(context,state.user.documentName);
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
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
        child:SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Other containers and fields remain the same
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.fbLiteDark,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Basic Details',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.fbLiteDark,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              TextField(
                                controller: customerTypeController,
                                decoration: InputDecoration(
                                  labelText: 'Customer Type',
                                  labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                  ),
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: InputDecoration(labelText: 'Customer Category',
                                  labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),
                                  ),
                                ),
                                value: custCategeory,
                                items: dropdownItems['ab-cust-category'] ?? [], // Map to lovId 'ab-cust-gender'
                                onChanged: (value) {
                                  setState(() {
                                    custCategeory = value as String;
                                  });
                                },
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child:  DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      decoration: InputDecoration(labelText: 'Language',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),
                                        ),
                                      ),
                                      value: language,
                                      items: dropdownItems['ab-cust-language'] ?? [], // Map to lovId 'ab-cust-gender'
                                      onChanged: (value) {
                                        setState(() {
                                          language = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 35.0),
                                  Expanded(
                                    child:  DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      decoration: InputDecoration(labelText: 'Title',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),
                                        ),
                                      ),
                                      value: title,
                                      items: dropdownItems['ab-cust-title'] ?? [], // Map to lovId 'ab-cust-gender'
                                      onChanged: (value) {
                                        setState(() {
                                          title = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: firstNameController,
                                      decoration: InputDecoration(
                                        labelText: 'First Name',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 35.0),
                                  Expanded(
                                    child: TextField(
                                      controller: middleNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Middle Name',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
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
                                      controller: lastNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Last Name',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 35.0),
                                  Expanded(
                                    child: TextField(
                                      controller: shortNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Short Name',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: DropdownSearch<String>(
                                      dropdownDecoratorProps: DropDownDecoratorProps(
                                        dropdownSearchDecoration: InputDecoration(
                                          labelText: 'Nationality',
                                          labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
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
                                      selectedItem: nationality, // Display the current value

                                      // onChanged: (String? desc) {
                                      //   setState(() {
                                      //     // Find and store the corresponding value for the selected description
                                      //     nationality = (dropdownItems2['ab-cust-nationality'] ?? [])
                                      //         .firstWhere((valDes) => valDes.desc == desc)
                                      //         .value;
                                      //   });
                                      // },
                                      // selectedItem: (dropdownItems2['ab-cust-nationality'] ?? [])
                                      //     .firstWhere(
                                      //       (valDes) => valDes.value == nationality,
                                      //   orElse: () => ValDes('', ''),
                                      // ).desc, // Display description corresponding to the selected value

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
                                    child:  DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      decoration: InputDecoration(labelText: 'Gender',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),
                                        ),
                                      ),
                                      value: gender,
                                      items: dropdownItems['ab-cust-gender'] ?? [], // Map to lovId 'ab-cust-gender'
                                      onChanged: (value) {
                                        setState(() {
                                          gender = value as String;
                                        });
                                      },
                                    ), )
                                ],
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _dobController,
                                      decoration: InputDecoration(
                                        labelText: 'Date of Birth',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                        ),
                                      ),
                                      onTap: () {
                                        // FocusScope.of(context).requestFocus(new FocusNode());
                                        CommDateTimeUtils.selectDate(context, _dobController);
                                      },
                                    ),
                                  ),

                                  SizedBox(width: 35.0),
                                  Expanded(
                                    flex: 2,
                                    child: DropdownSearch<String>(
                                      dropdownDecoratorProps: DropDownDecoratorProps(
                                        dropdownSearchDecoration: InputDecoration(
                                          labelText: 'Birth Country',
                                          labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                          ),
                                        ),
                                      ),
                                      // Format items as "value - description" strings to avoid direct indexing
                                      items: (dropdownItems['ab-cust-nationality'] ?? [])
                                          .map((item) => (item.value) as String)
                                          .toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          birthCountry = value; // Update the state
                                        });
                                      },
                                      selectedItem: birthCountry,

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

                              TextField(
                                controller: birthPlaceController,
                                decoration: InputDecoration(
                                  labelText: 'Birth Place',
                                  labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                  ),
                                ),
                              ),

                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'National Id',
                                  labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                  ),
                                ),
                              ),

                              TextField(
                                controller: passportNoController,
                                decoration: InputDecoration(
                                  labelText: 'Passport Number',
                                  labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                  ),
                                ),
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _passportIssueController,
                                      decoration: InputDecoration(
                                        labelText: 'Passport Issue Date',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                        ),
                                      ),
                                      onTap: () {
                                        KeyboardUtils.hideKeyboard();
                                        CommDateTimeUtils.selectDate(context, _passportIssueController, primaryColor: AppColors.fbLiteDark);
                                      },
                                    ),
                                  ),

                                  SizedBox(width: 35.0),
                                  Expanded(
                                    child: TextField(
                                      controller: _passportExpiryController,
                                      decoration: InputDecoration(
                                        labelText: 'Passport Expiry Date',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                        ),
                                      ),
                                      onTap: () {
                                        KeyboardUtils.hideKeyboard();
                                        CommDateTimeUtils.withFutureDate(context, _passportExpiryController);
                                      },
                                    ), )
                                ],
                              ),

                              SizedBox(height: 25.0),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.fbLiteDark,  // Border color
                                    width: 1.5,         // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0), // Padding inside the container
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: _isCheckedResidentStatus,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    _isCheckedResidentStatus = value ?? false;
                                                  });
                                                },
                                              ),
                                              Text(
                                                'Permanent US Resident Status',  // Fixed typo "Permanent"
                                                style: TextStyle(color: AppColors.fbLiteDark),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: _isCheckedVisitedUs,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    _isCheckedVisitedUs = value ?? false;
                                                  });
                                                },
                                              ),
                                              Text(
                                                'Visited US in the last 3 years',
                                                style: TextStyle(color: AppColors.fbLiteDark),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: emailIdController,
                                      decoration: InputDecoration(
                                        labelText: 'Email ID',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 35.0),
                                  Expanded(
                                    child: TextField(
                                      controller: mobileNoController,
                                      decoration: InputDecoration(
                                        labelText: 'Mobile No',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                        ),
                                      ),
                                    ), )
                                ],
                              ),

                              DropdownSearch<String>(
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: 'Mobile ISD Code',
                                    labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                    ),
                                  ),
                                ),
                                // Format items as "value - description" strings to avoid direct indexing
                                items: (dropdownItems['ab-country-codes'] ?? [])
                                    .map((item) => (item.value) as String)
                                    .toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    mobileIsdCode = value; // Update the state
                                  });
                                },
                                selectedItem: mobileIsdCode,

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

                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: InputDecoration(labelText: 'Marital Status',
                                  labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),
                                  ),
                                ),
                                value: maritalStatus,
                                items: dropdownItems['ab-marital-status'] ?? [], // Map to lovId 'ab-cust-gender'
                                onChanged: (value) {
                                  setState(() {
                                    maritalStatus = value as String;
                                  });
                                },
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child:  DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      decoration: InputDecoration(labelText: 'Communication',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),
                                        ),
                                      ),
                                      value: commMode,
                                      items: dropdownItems['ab-cust-comm-mode'] ?? [], // Map to lovId 'ab-cust-gender'
                                      onChanged: (value) {
                                        setState(() {
                                          commMode = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 35.0),
                                  Expanded(
                                    child:  DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      decoration: InputDecoration(labelText: 'Media',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),
                                        ),
                                      ),
                                      value: media,
                                      items: dropdownItems['ab-cust-media'] ?? [], // Map to lovId 'ab-cust-gender'
                                      onChanged: (value) {
                                        setState(() {
                                          media = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: 'KYC Reference Number',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 35.0),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      label: Text(
                                        'KYC Reference',
                                        style: TextStyle(color: AppColors.fbLiteDark),
                                      ),
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5), // Rectangle shape
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 35.0), // Spacing between the container and the next section
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.fbLiteDark,// Border color
                            width: 1.5,          // Border width
                          ),
                          borderRadius: BorderRadius.circular(12.0), // Rounded corners
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0), // Padding inside the container
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: Text('Professional Details',textAlign: TextAlign.center,style: TextStyle(color: AppColors.fbLiteDark,fontSize: 20,fontWeight: FontWeight.bold),),),

                              DropdownSearch<String>(
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: 'Current employer',
                                    labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                    ),
                                  ),
                                ),
                                // Format items as "value - description" strings to avoid direct indexing
                                items: (dropdownItems['ab-current-employeer'] ?? [])
                                    .map((item) => (item.value) as String)
                                    .toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    currentEmployer = value; // Update the state
                                  });
                                },
                                selectedItem: currentEmployer,

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
                                  Expanded(child:  TextField(
                                    decoration: InputDecoration(labelText: 'Current Designation',
                                      labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                      ),),
                                  ),
                                  ),
                                  SizedBox(width: 35.0),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(labelText: 'Salary',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                        ),),
                                    ),)
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child:   DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      decoration: InputDecoration(labelText: 'Salary Frequency',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),
                                        ),
                                      ),
                                      items: dropdownItems['ab-salary-frequency'] ?? [], // Map to lovId 'ab-cust-gender'
                                      onChanged: (value) {},
                                    ),
                                  ),
                                  SizedBox(width: 35.0),
                                  Expanded(
                                    child:  DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      decoration: InputDecoration(labelText: 'Employment Type',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),
                                        ),
                                      ),
                                      items: dropdownItems['ab-employment-type'] ?? [], // Map to lovId 'ab-cust-gender'
                                      onChanged: (value) {},
                                    ),)
                                ],
                              ),

                              TextField(
                                decoration: InputDecoration(labelText: 'Tenure',
                                  labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                  ),),
                              ),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0), // Sp
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.fbLiteDark,// Border color
                            width: 1.5,          // Border width
                          ),
                          borderRadius: BorderRadius.circular(12.0), // Rounded corners
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0), // Padding inside the container
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: Text('Address Details',textAlign: TextAlign.center,style: TextStyle(color: AppColors.fbLiteDark,fontSize: 20,fontWeight: FontWeight.bold),),),
                              Text('Address for Correspondence',style: TextStyle(color: AppColors.fbLiteDark,fontSize: 20,fontWeight: FontWeight.bold),),
                              TextField(
                                decoration: InputDecoration(labelText: 'Name',
                                  labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                  ),),
                              ),
                              TextField(
                                controller: address1Controller,
                                decoration: InputDecoration(labelText: 'Address 1',
                                  labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                  ),),
                              ),
                              Row(
                                children: [
                                  Expanded(child:  TextField(
                                    controller: address2Controller,
                                    decoration: InputDecoration(labelText: 'Address 2',
                                      labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                      ),),
                                  ),
                                  ),
                                  SizedBox(width: 35.0),
                                  Expanded(
                                    child: TextField(
                                      controller: addressNameController,
                                      decoration: InputDecoration(labelText: 'Address 3',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                        ),),
                                    ),)
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child:  TextField(
                                    controller: cityController,
                                    decoration: InputDecoration(labelText: 'Address 4',
                                      labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                      ),),
                                  ),
                                  ),
                                  SizedBox(width: 35.0),
                                  Expanded(
                                    child: TextField(
                                      controller: pincodeController,
                                      decoration: InputDecoration(labelText: 'Pin Code',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                        ),),
                                    ),)
                                ],
                              ),

                              DropdownSearch<String>(
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: 'Country',
                                    labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                    ),
                                  ),
                                ),
                                // Format items as "value - description" strings to avoid direct indexing
                                items: (dropdownItems['ab-cust-nationality'] ?? [])
                                    .map((item) => (item.value) as String)
                                    .toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    country = value; // Update the state
                                  });
                                },
                                selectedItem: country,

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

                              SizedBox(height: 10,),
                              Text('Permenant Address',style: TextStyle(color: AppColors.fbLiteDark,fontSize: 20,fontWeight: FontWeight.bold),),
                              Text('Is your permenant address same as correspondence address',style: TextStyle(color: Colors.black,fontSize: 15),),

                              SizedBox(height: 10.0), // Spacing between the title and radio buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<bool>(
                                      title: Text("Yes", style: TextStyle(color: AppColors.fbLiteDark)),
                                      value: true,
                                      groupValue: _isSameAsCorrespondence,
                                      onChanged: (value) {
                                        setState(() {
                                          _isSameAsCorrespondence = value!;
                                          _updatePermanentAddress(_isSameAsCorrespondence);
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<bool>(
                                      title: Text("No", style: TextStyle(color: AppColors.fbLiteDark)),
                                      value: false,
                                      groupValue: _isSameAsCorrespondence,
                                      onChanged: (value) {
                                        setState(() {
                                          _isSameAsCorrespondence = value!;
                                          _updatePermanentAddress(_isSameAsCorrespondence);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              TextField(
                                controller: permanentAddress1Controller,
                                decoration: InputDecoration(labelText: 'Address 1',
                                  labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                  ),),
                              ),
                              Row(
                                children: [
                                  Expanded(child:  TextField(
                                    controller: permanentAddress2Controller,
                                    decoration: InputDecoration(labelText: 'Address 2',
                                      labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                      ),),
                                  ),
                                  ),
                                  SizedBox(width: 35.0),
                                  Expanded(
                                    child: TextField(
                                      controller: permanentAddress3Controller,
                                      decoration: InputDecoration(labelText: 'Address 3',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                        ),),
                                    ),)
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child:  TextField(
                                    controller: permanentCityController,
                                    decoration: InputDecoration(labelText: 'Address 4',
                                      labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                      ),),
                                  ),
                                  ),
                                  SizedBox(width: 35.0),
                                  Expanded(
                                    child: TextField(
                                      controller: permanentPincodeController,
                                      decoration: InputDecoration(labelText: 'Pin Code',
                                        labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                        ),),
                                    ),)
                                ],
                              ),
                              DropdownSearch<String>(
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: 'Country',
                                    labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
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
                                selectedItem: nationality,

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
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0), // Sp
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.fbLiteDark,// Border color
                              width: 1.5,          // Border width
                            ),
                            borderRadius: BorderRadius.circular(12.0), // Rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0), // Padding inside the container
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Track Limit', style: TextStyle(color: Colors.black, fontSize: 16)),

                                Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile<bool>(
                                        title: Text("No"),
                                        value: false,
                                        groupValue: _trackLimit,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _trackLimit = value!;
                                          });
                                        },
                                        activeColor: AppColors.fbLiteDark,
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile<bool>(
                                        title: Text("Yes"), // ✅ Fix: Changed from "No" to "Yes"
                                        value: true,
                                        groupValue: _trackLimit,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _trackLimit = value!;
                                          });
                                        },
                                        activeColor: AppColors.fbLiteDark,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10),

                                TextField(
                                  controller: liaNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Liability Name',
                                    labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10),

                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: DropdownSearch<String>(
                                        dropdownDecoratorProps: DropDownDecoratorProps(
                                          dropdownSearchDecoration: InputDecoration(
                                            labelText: 'Liability Branch',
                                            labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                            ),
                                          ),
                                        ),
                                        items: (dropdownItems['ab-cust-brn'] ?? [])
                                            .where((item) => item != null) // ✅ Fix: Avoid null errors
                                            .map((item) => item.toString())
                                            .toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            liaBranch = value;
                                          });
                                        },
                                        selectedItem: liaBranch,
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
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          labelText: 'Currency',
                                          labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                          ),
                                        ),
                                        value: currency,
                                        items: dropdownItems['ab-cust-currency'] ?? [],
                                        onChanged: (value) {
                                          setState(() {
                                            currency = value as String;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10),

                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Eligibility Points',
                                    labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25.0),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.fbLiteDark,  // Border color
                                      width: 1.5,          // Border width
                                    ),
                                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0), // Padding inside the container
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            'Channels',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppColors.fbLiteDark,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Wrap(
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          spacing: 20.0,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Checkbox(
                                                  value: _isCheckedInternetBanking,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      _isCheckedInternetBanking = value ?? false;
                                                    });
                                                  },
                                                ),
                                                Text('Internet Banking', style: TextStyle(color: AppColors.fbLiteDark)),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Checkbox(
                                                  value: _isCheckedMobileBanking,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      _isCheckedMobileBanking = value ?? false;
                                                    });
                                                  },
                                                ),
                                                Text('Mobile Banking', style: TextStyle(color: AppColors.fbLiteDark)),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 25.0), // Sp
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.fbLiteDark, // Border color
                                      width: 1.5,        // Border width
                                    ),
                                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0), // Padding inside the container
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            'Account Details',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppColors.fbLiteDark,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: DropdownSearch<String>(
                                                dropdownDecoratorProps: DropDownDecoratorProps(
                                                  dropdownSearchDecoration: InputDecoration(
                                                    labelText: 'Branch',
                                                    labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                                    focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                                    ),
                                                  ),
                                                ),
                                                // Format items as "value - description" strings to avoid direct indexing
                                                items: (dropdownItems['ab-cust-brn'] ?? [])
                                                    .map((item) => (item.value) as String)
                                                    .toList(),
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    liaBranch = value; // Update the state
                                                  });
                                                },
                                                selectedItem: liaBranch,
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
                                              child:  DropdownButtonFormField<String>(
                                                isExpanded: true,
                                                decoration: InputDecoration(labelText: 'Currency',
                                                  labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),
                                                  ),
                                                ),
                                                value: accCurrency,
                                                items: dropdownItems['ab-cust-currency'] ?? [],
                                                onChanged: (value) {
                                                  setState(() {
                                                    accCurrency = value as String;
                                                  });
                                                },
                                              ), )
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            Expanded(child:DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              decoration: InputDecoration(labelText: 'Account Class',
                                                labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),
                                                ),
                                              ),
                                              value: accClass,
                                              items: dropdownItems['ab-acc-class'] ?? [], // Map to lovId 'ab-cust-gender'
                                              onChanged: (value) {
                                                setState(() {
                                                  accClass = value as String;
                                                });
                                              },
                                            ),
                                            ),
                                            SizedBox(width: 35.0),
                                            Expanded(
                                              child:  DropdownButtonFormField<String>(
                                                isExpanded: true,
                                                decoration: InputDecoration(labelText: 'Location',
                                                  labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),
                                                  ),
                                                ),
                                                value: location,
                                                items: dropdownItems['ab-cust-location'] ?? [], // Map to lovId 'ab-cust-gender'
                                                onChanged: (value) {
                                                  setState(() {
                                                    location = value as String;
                                                  });
                                                },
                                              ),)
                                          ],
                                        ),

                                        TextField(
                                          controller: _accountCreationController,
                                          decoration: InputDecoration(
                                            labelText: 'Account Creation Date',
                                            labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                            ),
                                          ),
                                          onTap: () {
                                            KeyboardUtils.hideKeyboard();
                                            CommDateTimeUtils.selectDate(context, _accountCreationController);
                                          },
                                        ),
                                        TextField(
                                          decoration: InputDecoration(labelText: 'Cheque Book Name',
                                            labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                            ),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 25.0), // Sp
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.fbLiteDark, // Border color
                                      width: 1.5,        // Border width
                                    ),
                                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0), // Padding inside the container
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            'Nominee Details',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppColors.fbLiteDark,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        TextField(
                                          controller: relationshipController,
                                          decoration: InputDecoration(labelText: 'Relationship',
                                            labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                            ),),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(child:  TextField(
                                              controller: nAddress1Controller,
                                              decoration: InputDecoration(labelText: 'Address 1',
                                                labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                                ),),
                                            ),
                                            ),
                                            SizedBox(width: 35.0),
                                            Expanded(
                                              child: TextField(
                                                controller: nAddress2Controller,
                                                decoration: InputDecoration(labelText: 'Address 2',
                                                  labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                                  ),),
                                              ),)
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(child:  TextField(
                                              controller: nAddress3Controller,
                                              decoration: InputDecoration(labelText: 'Address 3',
                                                labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                                ),),
                                            ),
                                            ),
                                            SizedBox(width: 35.0),
                                            Expanded(
                                              child: TextField(
                                                controller: nAddress4Controller,
                                                decoration: InputDecoration(labelText: 'Address 4',
                                                  labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                                  ),),
                                              ),)
                                          ],
                                        ),

                                        TextField(
                                          controller: nNameController,
                                          decoration: InputDecoration(labelText: 'Nominee Name',
                                            labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                            ),),
                                        ),

                                        TextField(
                                          controller: _nomineeDobController,
                                          decoration: InputDecoration(
                                            labelText: 'Date of Birth',
                                            labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                            ),
                                          ),
                                          onTap: () {
                                            KeyboardUtils.hideKeyboard();
                                            _nselectdate(context);
                                          },
                                        ),

                                        if(_showGuardianField)
                                          TextField(
                                            controller: nGuardianController,
                                            decoration: InputDecoration(labelText: 'Guardian Name',
                                              labelStyle: TextStyle(color: AppColors.fbLiteDark),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: AppColors.fbLiteDark,width: 2.0),

                                              ),),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 25.0), // Sp
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.fbLiteDark,// Border color
                                        width: 1.5,          // Border width
                                      ),
                                      borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(12.0), // Padding inside the container
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Center(child: Text('Upload KYC Document',textAlign: TextAlign.center,style: TextStyle(color: AppColors.fbLiteDark,fontSize: 20,fontWeight: FontWeight.bold),),),
                                              SizedBox(height: 16.0),
                                              Center(
                                                child:OutlinedButton.icon(
                                                  icon: Icon(Icons.upload_file, color: AppColors.fbLiteDark),
                                                  label: Text(
                                                    'Upload Document',
                                                    style: TextStyle(color: AppColors.fbLiteDark),
                                                  ),
                                                  onPressed: () {
                                                    _showDocumentOptions(context);
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    side: BorderSide(color: AppColors.fbLiteDark, width: 2.0),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
                                                  ),
                                                ),

                                              ),
                                            ]
                                        )
                                    )
                                ),

                                SizedBox(height: 24),
                                Center(
                                  child: buildActionButton(
                                    label: "Submit",
                                    onPressed: () {
                                      custEnoll(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ],
                  )
                ]
            )
        )
    );

  }
  @override
  void dispose() {
    _dobController.dispose();
    _passportIssueController.dispose();
    _passportExpiryController.dispose();
    _accountCreationController.dispose();
    _nomineeDobController.dispose();
    super.dispose();

  }
}

class ValDes {
  final String value;
  final String desc;

  ValDes(this.value, this.desc);
}

class SignImageUploadPage extends StatefulWidget {
  final LoginUserReqResInfo? loginResponse;
  const SignImageUploadPage({ this.loginResponse});
  @override
  _SignImageUploadPageState createState() => _SignImageUploadPageState();
}

class _SignImageUploadPageState extends State<SignImageUploadPage> {
  final ImagePicker _picker = ImagePicker();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Uint8List? _signatureImage; // Variable to store the signature image
  Uint8List?  _capturedImage;
  bool _isTermsAccepted = false;
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
                          _signatureController.clear(); // Clear the signature pad
                          _signatureImage = null; // Clear the saved signature image
                        });
                      },
                      child: Text('Clear Pad', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fbLiteDark,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_signatureController.isNotEmpty) {
                          final signature = await _signatureController.toPngBytes();
                          setState(() {
                            _signatureImage = signature; // Save the signature image
                          });
                          Navigator.of(context).pop(); // Close the dialog
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fbLiteDark,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(fontSize: 16, color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Save Signature', style: TextStyle(color: Colors.white)),
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
                    style: TextStyle(color: AppColors.fbLiteDark, fontWeight: FontWeight.bold),
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
                          ? Image.memory(_signatureImage!) // Display the signature if it exists
                          : Image.asset(
                        'assets/images/img_2.png',
                        fit: BoxFit.contain, // Placeholder image if no signature
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Draw Your Signature',
                    style: TextStyle(color: AppColors.fbLiteDark, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),
                  Container(
                    height: 250,  // Set a fixed height for the container
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

                  SizedBox(height: 25),
                  buildActionButton(
                    label: "Upload",
                    onPressed: () {
                      sumbit_image(context);
                    },
                  ),
                ],
              ),
            )
        )
    );
  }

  void sumbit_image(BuildContext context)
  {
    CommCustImageSign custImageSign=CommCustImageSign();
    custImageSign.docUniqueNum= "I";
    custImageSign.documentType="Ok";
    custImageSign.documentName="I";
    custImageSign.image=_capturedImage != null ? base64.encode(_capturedImage!) : null;
    CommCustImageSign custImageSign1=CommCustImageSign();
    custImageSign1.docUniqueNum= "S";
    custImageSign1.documentType="Ok";
    custImageSign1.documentName="S";
    custImageSign1.image=_signatureImage != null ? base64.encode(_signatureImage!) : null;
    CommCustImageSignList commCustImageSignList=CommCustImageSignList();
    commCustImageSignList.headerInfo=widget.loginResponse?.headerInfo;
    commCustImageSignList.customerId="W2025012305456";
    commCustImageSignList.transactionType="WALLET_IMG_UPLOAD";
    commCustImageSignList.commCustImageSignList=[custImageSign,custImageSign1];
    context.read<CustImageUploadBloc>().add(CustImageUploadSubmitted(commCustImageSignList));
  }
}

*/
