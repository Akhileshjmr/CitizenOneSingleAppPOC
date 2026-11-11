import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../data/models/CommKycUpload.dart';
import '../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../data/models/lov_models/AbGenLovValDesc.dart';
import '../../../theme/colors/Appcolors.dart';
import '../../../utils/CommSuccessDialogues.dart';
import '../../../utils/ImageCompressionHelper.dart';
import '../../../utils/Loader.dart';
import '../../blocs/kyc_upload_bloc/kyc_upload_bloc.dart';
import '../../blocs/kyc_upload_bloc/kyc_upload_event.dart';
import '../../blocs/kyc_upload_bloc/kyc_upload_state.dart';
import '../Loans/application_form/widgets/LabeledRadioGroup.dart';
import '../Loans/application_form/widgets/document_details.dart';
import '../Loans/application_form/widgets/labeled_dateField.dart';
import '../Loans/application_form/widgets/labeled_dropdown.dart';
import '../Loans/application_form/widgets/labeled_textField.dart';
import '../Loans/application_form/widgets/step_placeholder.dart';
import '../Loans/application_form/widgets/stepper_header.dart';
import 'LoanApplicationSubmittedPage.dart';
import 'OtpScreen.dart';
import 'controllers.dart';

class FormLayout extends StatefulWidget {

  // final LoginUserReqResInfo loginResponse;
  // final BankOption selectedBank;


  _FormLayoutState createState() => _FormLayoutState();

  const FormLayout({
    super.key,
  });
}

class _FormLayoutState extends State<FormLayout> {
  int _currentStep = 0;
  bool isCommDataPreFetched = false;
  final List<String> _steps = [
    "Personal Information",
    "Employment & Income Details",
    "Health & Medical Information",
    "Nominee Details",
    "Document Upload",
    "Terms and Condition",
  ];
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          _buildScaffoldContent(context), // moved scaffold to separate method
          const GlobalLoader(), // overlay always available
        ],
      );
  }

  Widget _buildScaffoldContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColorScreen,
      appBar: CustomAppBar(
        title: "Application Form",
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// --- Stepper Header ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: StepperHeader(
                currentStep: _currentStep,
                steps: _steps,
                onStepSelected: (index) {
                  setState(() => _currentStep = index);
                },
                // onStepSelected: (index) {
                //   // If customer search was not successful → block all clicking
                //   if (!_isCustomerSearchSuccess) {
                //     return;
                //   }
                //   // Allow only backward step navigation
                //   if (index < _currentStep) {
                //     setState(() => _currentStep = index);
                //   }
                // }
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// --- Step Content ---
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Card(
                  elevation: 2,
                  color: AppColors.applicationCardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: _buildStepContent(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _handleStepNext(int stepIndex) {
    setState(() {
      if (_currentStep == stepIndex) {
        _currentStep++;   // 👈 increments correctly
      }else{
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const OtpScreen(),
        //   ),
        // );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => ApplicationSubmittedScreen(
        //       estimatedTime: '1 - 2 Business Days',
        //       referenceNumber: 'LN${DateTime.now().millisecondsSinceEpoch % 1000000}', // generate or pass real ref
        //       description: 'Your application has been received and is being processed. You will be notified once approved.',
        //     ),
        //   ),
        // );
      }
    });
  }

  /// --- Step Content Switcher ---
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return PersonalDetailsForm(
          onNext: () => _handleStepNext(0),
        );
      case 1:
        return EmploymentInfoForm(
          onNext: () => _handleStepNext(1),
          onPrevious: () {
            setState(() {
              if (_currentStep > 0) _currentStep--;
            });
          },

        );
      case 2:
        return HealthMedicalInfoForm
          (
          onNext: () => _handleStepNext(2),
          onPrevious: () {
            setState(() {
              if (_currentStep > 0) _currentStep--;
            });
          },
        );
      case 3:
        return NomineeDetailsForm(
          onNext: () => _handleStepNext(3),
          onPrevious: () {
            setState(() {
              if (_currentStep > 0) _currentStep--;
            });
          },

        );

      case 4:
        return DocumentUpload(
          onNext: () => _handleStepNext(4),
          onPrevious: () {
            setState(() {
              if (_currentStep > 0) _currentStep--;
            });
          }, lovValues: {

        },

        );
      case 5:
        return RequiredDocumentsUploadForm(
          onNext: () => _handleStepNext(4),

        );


      default:
        return StepPlaceholder(title: _steps[_currentStep]);
    }
  }
}


class PersonalDetailsForm extends StatefulWidget {
  final VoidCallback onNext;

  const PersonalDetailsForm({super.key, required this.onNext});

  @override
  State<PersonalDetailsForm> createState() => _PersonalDetailsFormState();
}

class _PersonalDetailsFormState extends State<PersonalDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// FULL NAME
          LabeledTextField(
            label: "Full Name",
            maxLength: 14,
            controller: fullNameController,
            isMandatory: true,
            validator: (v) => v == null || v.isEmpty
                ? "Full Name is required."
                : null,
          ),

          /// DATE OF BIRTH
          LabeledDateField(
            label: "Date of Birth",
            controller: dobController,
            lastDate: DateTime.now(),
            isMandatory: true,
            validator: (v) =>
            v == null || v.isEmpty ? " Date is required.." : null,
          ),

          /// GENDER DROPDOWN
          LabeledDropdown<String>(
            label: "Gender",
            isMandatory: true,
            value: gender,
            items: ["Male", "Female", "Other"],
            onChanged: (value) => setState(() => gender = value),
            validator: (v) =>
            v == null ? " Gender is required." : null,
          ),

          /// NATIONALITY
          LabeledTextField(
            label: "Nationality",
            maxLength: 15,
            controller: nationalityController,
            isMandatory: true,
            validator: (v) => v == null || v.isEmpty
                ? "Nationality is required."
                : null,
          ),

          /// NRC NO
          LabeledTextField(
            label: "NRC No",
            controller: nrcController,
            maxLength: 12,
            isMandatory: false,
          ),

          /// MARITAL STATUS
          LabeledDropdown<String>(
            label: "Marital Status",
            isMandatory: true,
            value: maritalStatus,
            items: [
              "Single",
              "Married",
              "Divorced",
              "Widowed",
            ],
            onChanged: (value) => setState(() => maritalStatus = value),
            validator: (v) =>
            v == null ? " Marital Status is required.." : null,
          ),

          LabeledTextField(
            label: "Mobile Number",
            controller: mobileController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 9,
            keyboardType: TextInputType.phone,
            isMandatory: true,
            validator: (v) =>
            v == null || v.isEmpty ? " Mobile Number is required." : null,
          ),

          LabeledTextField(
            label: "Email Address",
            controller: emailController,
            maxLength: 20,
            keyboardType: TextInputType.emailAddress,
            isMandatory: true,
            validator: (v) =>
            v == null || v.isEmpty ? "Email is required.." : null,
          ),

          LabeledTextField(
            label: "Residential Address",
            controller: addressController,
            maxLength: 30,
            isMandatory: true,
            validator: (v) =>
            v == null || v.isEmpty ? "Address is required.." : null,
          ),

          LabeledTextField(
            label: "City / Province",
            controller: cityController,
            isMandatory: true,
            maxLength: 15,
            validator: (v) =>
            v == null || v.isEmpty ? "City is required.." : null,
          ),

          LabeledTextField(
            label: "Postal Code",
            controller: postalController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 6,
            isMandatory: true,
            validator: (v) =>
            v == null || v.isEmpty ? "Postal Code is Required." : null,
          ),

          const SizedBox(height: 20),
          FormButtons.navigation(
            context: context,
            formKey: _formKey,
            onNext: widget.onNext,
          ),
        ],
      ),
    );
  }
}
// class ContactDetailsForm extends StatefulWidget {
//   final VoidCallback onNext;
//   final VoidCallback onPrevious;
//
//   const ContactDetailsForm({
//     super.key,
//     required this.onNext,
//     required this.onPrevious,
//   });
//
//   @override
//   State<ContactDetailsForm> createState() => _ContactDetailsFormState();
// }
//
// class _ContactDetailsFormState extends State<ContactDetailsForm> {
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//
//           LabeledTextField(
//             label: "Mobile Number",
//             controller: mobileController,
//             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             maxLength: 9,
//             keyboardType: TextInputType.phone,
//             isMandatory: true,
//             validator: (v) =>
//             v == null || v.isEmpty ? " Mobile Number is required." : null,
//           ),
//
//           LabeledTextField(
//             label: "Email Address",
//             controller: emailController,
//             maxLength: 20,
//             keyboardType: TextInputType.emailAddress,
//             isMandatory: true,
//             validator: (v) =>
//             v == null || v.isEmpty ? "Email is required.." : null,
//           ),
//
//           LabeledTextField(
//             label: "Residential Address",
//             controller: addressController,
//             maxLength: 30,
//             isMandatory: true,
//             validator: (v) =>
//             v == null || v.isEmpty ? "Address is required.." : null,
//           ),
//
//           LabeledTextField(
//             label: "City / Province",
//             controller: cityController,
//             isMandatory: true,
//             maxLength: 15,
//             validator: (v) =>
//             v == null || v.isEmpty ? "City is required.." : null,
//           ),
//
//           LabeledTextField(
//             label: "Postal Code",
//             controller: postalController,
//             keyboardType: TextInputType.number,
//             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             maxLength: 6,
//             isMandatory: true,
//             validator: (v) =>
//             v == null || v.isEmpty ? "Postal Code is Required." : null,
//           ),
//           const SizedBox(height: 20),
//           FormButtons.navigation(
//             context: context,
//             formKey: _formKey,
//             onPrevious: widget.onPrevious,
//             onNext: widget.onNext,
//           ),
//         ],
//       ),
//     );
//   }
// }
class EmploymentInfoForm extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const EmploymentInfoForm({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<EmploymentInfoForm> createState() => _EmploymentInfoFormState();
}

class _EmploymentInfoFormState extends State<EmploymentInfoForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// EMPLOYMENT TYPE (4 buttons)
          LabeledRadioGroup<String>(
            label: "Employment Type",
            isMandatory: true,
            options: [
              "Salaried",
              "Self-Employed",
              "Business Owner",
              "Others",
            ],
            value: employmentType,
            onChanged: (val) {
              setState(() => employmentType = val);
            },
            validator: (v) => v == null ? "Please choose an employment type" : null,
          ),

          const SizedBox(height: 20),

          /// EMPLOYER / BUSINESS NAME
          LabeledTextField(
            label: "Employer / Business Name",
            controller: employerController,
            isMandatory: true,
            validator: (v) =>
            v == null || v.isEmpty ? "Error message. Please try again." : null,
          ),

          /// MONTHLY INCOME
          LabeledTextField(
            label: "Monthly Income (ZK)",
            controller: incomeController,
            keyboardType: TextInputType.number,
            isMandatory: true,
            validator: (v) =>
            v == null || v.isEmpty ? "Error message. Please try again." : null,
          ),

          /// OCCUPATION
          LabeledTextField(
            label: "Occupation",
            controller: occupationController,
            isMandatory: true,
            validator: (v) =>
            v == null || v.isEmpty ? "Error message. Please try again." : null,
          ),

          /// YEARS
          LabeledTextField(
            label: "Years of Employment / Business",
            controller: yearsController,
            keyboardType: TextInputType.number,
            isMandatory: true,
            validator: (v) =>
            v == null || v.isEmpty ? "Error message. Please try again." : null,
          ),

          /// POLICY TERM DROPDOWN
          LabeledDropdown<String>(
            label: "Policy Term",
            value: policyTerm,
            items: ["5 Years", "10 Years", "15 Years", "20 Years"],
            isMandatory: true,
            onChanged: (v) => setState(() => policyTerm = v),
            validator: (v) =>
            v == null ? "Error message. Please try again." : null,
          ),

          const SizedBox(height: 10),

          /// PREMIUM FREQUENCY (3 buttons)
          LabeledRadioGroup<String>(
            label: "Premium Frequency",
            isMandatory: true,
            options: ["Monthly", "Quarterly", "Yearly"],
            value: premiumFrequency,
            onChanged: (val) {
              setState(() => premiumFrequency = val);
            },
            validator: (v) => v == null ? "Please select a frequency" : null,
          ),

          const SizedBox(height: 25),

          /// ADD-ON RIDERS
          const Text(
            "Add-On Riders:",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          ...riders.keys.map((key) {
            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(key),
              value: riders[key],
              onChanged: (v) {
                setState(() {
                  riders[key] = v ?? false;
                });
              },
            );
          }).toList(),
          const SizedBox(height: 20),
          FormButtons.navigation(
            context: context,
            formKey: _formKey,
            onPrevious: widget.onPrevious,
            onNext: widget.onNext,
          ),
        ],
      ),
    );
  }
}


class HealthMedicalInfoForm extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  /// Optional controllers — if provided, this widget will NOT dispose them.
  final TextEditingController? illnessDetailsCtrl;
  final TextEditingController? surgeryDetailsCtrl;

  const HealthMedicalInfoForm({
    super.key,
    required this.onNext,
    required this.onPrevious,
    this.illnessDetailsCtrl,
    this.surgeryDetailsCtrl,
  });

  @override
  State<HealthMedicalInfoForm> createState() => _HealthMedicalInfoFormState();
}

class _HealthMedicalInfoFormState extends State<HealthMedicalInfoForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController illnessDetailsCtrl;
  late final TextEditingController surgeryDetailsCtrl;

  // Track ownership so we only dispose controllers we created
  late final bool _ownsIllnessCtrl;
  late final bool _ownsSurgeryCtrl;

  // Local state
  String? smokeStatus;
  String? preExistingIllnessStatus;
  String? pastSurgeryStatus;
  String? familyHistoryStatus;

  /// Displayed filename (set after picking)
  String? medicalReportFileName;

  /// you can store PlatformFile here:
  PlatformFile? pickedMedicalReport;

  @override
  void initState() {
    super.initState();

    // Use passed controllers if provided, otherwise create and own them.
    if (widget.illnessDetailsCtrl != null) {
      illnessDetailsCtrl = widget.illnessDetailsCtrl!;
      _ownsIllnessCtrl = false;
    } else {
      illnessDetailsCtrl = TextEditingController();
      _ownsIllnessCtrl = true;
    }

    if (widget.surgeryDetailsCtrl != null) {
      surgeryDetailsCtrl = widget.surgeryDetailsCtrl!;
      _ownsSurgeryCtrl = false;
    } else {
      surgeryDetailsCtrl = TextEditingController();
      _ownsSurgeryCtrl = true;
    }
  }

  @override
  void dispose() {
    if (_ownsIllnessCtrl) {
      illnessDetailsCtrl.dispose();
    }
    if (_ownsSurgeryCtrl) {
      surgeryDetailsCtrl.dispose();
    }
    super.dispose();
  }

  Future<void> _pickMedicalReport() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
        // withData: true, // you can enable if you need bytes immediately
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        setState(() {
          pickedMedicalReport = file;
          medicalReportFileName = file.name;
        });

      }
    } catch (e) {
      if (kDebugMode) debugPrint('File pick error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick file')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DO YOU SMOKE OR CONSUME TOBACCO?
          LabeledRadioGroup<String>(
            label: "Do you smoke or consume tobacco?",
            isMandatory: true,
            options: const ["Yes", "No"],
            value: smokeStatus,
            onChanged: (val) {
              setState(() => smokeStatus = val);
            },
            validator: (v) => v == null ? "Please select an option" : null,
          ),

          const SizedBox(height: 16),

          /// PRE-EXISTING ILLNESSES
          LabeledRadioGroup<String>(
            label: "Any pre-existing illnesses?",
            isMandatory: true,
            options: const ["Yes", "No"],
            value: preExistingIllnessStatus,
            onChanged: (val) {
              setState(() => preExistingIllnessStatus = val);

              // If user picks No, clear text (do not dispose)
              if (val == "No") {
                illnessDetailsCtrl.clear();
              }
            },
            validator: (v) => v == null ? "Please select an option" : null,
          ),

          if (preExistingIllnessStatus == "Yes") ...[
            const SizedBox(height: 8),
            LabeledTextField(
              label: "If Yes, specify",
              controller: illnessDetailsCtrl,
              isMandatory: true,
              validator: (v) {
                if (preExistingIllnessStatus == "Yes" &&
                    (v == null || v.isEmpty)) {
                  return "Please specify the illness";
                }
                return null;
              },
            ),
          ],

          const SizedBox(height: 16),

          /// PAST SURGERIES / HOSPITALISATIONS
          LabeledRadioGroup<String>(
            label: "Any past surgeries or hospitalizations?",
            isMandatory: true,
            options: const ["Yes", "No"],
            value: pastSurgeryStatus,
            onChanged: (val) {
              setState(() => pastSurgeryStatus = val);

              if (val == "No") {
                surgeryDetailsCtrl.clear();
              }
            },
            validator: (v) => v == null ? "Please select an option" : null,
          ),

          if (pastSurgeryStatus == "Yes") ...[
            const SizedBox(height: 8),
            LabeledTextField(
              label: "If Yes, specify",
              controller: surgeryDetailsCtrl,
              isMandatory: true,
              validator: (v) {
                if (pastSurgeryStatus == "Yes" &&
                    (v == null || v.isEmpty)) {
                  return "Please specify the details";
                }
                return null;
              },
            ),
          ],

          const SizedBox(height: 16),

          /// FAMILY HISTORY OF CRITICAL ILLNESS
          LabeledRadioGroup<String>(
            label: "Family history of critical illness?",
            isMandatory: true,
            options: const ["Yes", "No"],
            value: familyHistoryStatus,
            onChanged: (val) {
              setState(() => familyHistoryStatus = val);
            },
            validator: (v) => v == null ? "Please select an option" : null,
          ),

          const SizedBox(height: 24),

          /// UPLOAD MEDICAL REPORT
          const Text(
            "Upload Medical Report",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickMedicalReport,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD0D5DD)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      medicalReportFileName ?? "Upload Medical Report (PDF/JPG/PNG)",
                      style: TextStyle(
                        fontSize: 14,
                        color: medicalReportFileName == null
                            ? const Color(0xFF98A2B3)
                            : const Color(0xFF101828),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.upload_outlined, size: 22),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          /// NAVIGATION BUTTONS (Next)
          FormButtons.navigation(
            context: context,
            formKey: _formKey,
            onPrevious: widget.onPrevious,
            onNext: widget.onNext,
          ),
        ],
      ),
    );
  }
}



class NomineeDetailsForm extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  /// Optional controllers (if you manage them in a bloc/GetX/etc)
  final TextEditingController? nomineeNameCtrl;
  final TextEditingController? relationshipCtrl;
  final TextEditingController? ageCtrl;
  final TextEditingController? contactCtrl;
  final TextEditingController? addressCtrl;

  const NomineeDetailsForm({
    super.key,
    required this.onNext,
    required this.onPrevious,
    this.nomineeNameCtrl,
    this.relationshipCtrl,
    this.ageCtrl,
    this.contactCtrl,
    this.addressCtrl,
  });

  @override
  State<NomineeDetailsForm> createState() => _NomineeDetailsFormState();
}

class _NomineeDetailsFormState extends State<NomineeDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nomineeNameCtrl;
  late final TextEditingController relationshipCtrl;
  late final TextEditingController ageCtrl;
  late final TextEditingController contactCtrl;
  late final TextEditingController addressCtrl;

  late final bool _ownsNameCtrl;
  late final bool _ownsRelationshipCtrl;
  late final bool _ownsAgeCtrl;
  late final bool _ownsContactCtrl;
  late final bool _ownsAddressCtrl;

  @override
  void initState() {
    super.initState();

    nomineeNameCtrl = widget.nomineeNameCtrl ?? TextEditingController();
    relationshipCtrl = widget.relationshipCtrl ?? TextEditingController();
    ageCtrl = widget.ageCtrl ?? TextEditingController();
    contactCtrl = widget.contactCtrl ?? TextEditingController();
    addressCtrl = widget.addressCtrl ?? TextEditingController();

    _ownsNameCtrl = widget.nomineeNameCtrl == null;
    _ownsRelationshipCtrl = widget.relationshipCtrl == null;
    _ownsAgeCtrl = widget.ageCtrl == null;
    _ownsContactCtrl = widget.contactCtrl == null;
    _ownsAddressCtrl = widget.addressCtrl == null;
  }

  @override
  void dispose() {
    if (_ownsNameCtrl) nomineeNameCtrl.dispose();
    if (_ownsRelationshipCtrl) relationshipCtrl.dispose();
    if (_ownsAgeCtrl) ageCtrl.dispose();
    if (_ownsContactCtrl) contactCtrl.dispose();
    if (_ownsAddressCtrl) addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Nominee Full Name
          LabeledTextField(
            label: "Nominee Full Name",
            controller: nomineeNameCtrl,
            isMandatory: true,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return "Please enter nominee full name";
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          /// Relationship with Applicant
          LabeledTextField(
            label: "Relationship with Applicant",
            controller: relationshipCtrl,
            isMandatory: true,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return "Please enter relationship with applicant";
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          /// Nominee Age
          LabeledTextField(
            label: "Nominee Age",
            controller: ageCtrl,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            isMandatory: true,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return "Please enter nominee age";
              }
              final age = int.tryParse(v);
              if (age == null || age <= 0) {
                return "Please enter a valid age";
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          /// Nominee Contact Number
          LabeledTextField(
            label: "Nominee Contact Number",
            controller: contactCtrl,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 10,
            isMandatory: true,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return "Please enter contact number";
              }
              final digits = v.replaceAll(RegExp(r'\D'), '');
              if (digits.length < 10) {
                return "Please enter a valid contact number";
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          /// Nominee Address
          LabeledTextField(
            label: "Nominee Address",
            controller: addressCtrl,
            isMandatory: true,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return "Please enter nominee address";
              }
              return null;
            },
          ),

          const SizedBox(height: 32),

          /// Bottom "Next" button (same style as Health/Medical form)
          FormButtons.navigation(
            context: context,
            formKey: _formKey,
            onPrevious: widget.onPrevious,
            onNext: widget.onNext,
          ),
        ],
      ),
    );
  }
}


class RequiredDocumentsUploadForm extends StatefulWidget {
  final VoidCallback onNext;

  const RequiredDocumentsUploadForm({
    super.key,
    required this.onNext,
  });

  @override
  State<RequiredDocumentsUploadForm> createState() =>
      _RequiredDocumentsUploadFormState();
}

class _RequiredDocumentsUploadFormState
    extends State<RequiredDocumentsUploadForm> {
  bool _isAgreed = false;

  String _buildDeclaration() {
    final line =
        'I hereby declare that all information provided is true and correct to the best of my knowledge. '
        'I understand that withholding or providing false information may lead to rejection of my insurance application.';
    return List.filled(5, line).join('\n\n');
  }

  void _openTerms() {
    // TODO: open terms & conditions screen or URL
  }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT:
    // - No Scaffold
    // - No SafeArea
    // - No SingleChildScrollView / CustomScrollView
    // This is just content to be dropped inside FormLayout.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// If FormLayout already shows the step title, REMOVE this Text.
        // const Text(
        //   'Required Documents Upload',
        //   style: TextStyle(
        //     fontSize: 18,
        //     fontWeight: FontWeight.w700,
        //   ),
        // ),
        const SizedBox(height: 12),

        /// Declaration text (parent scroll will handle overflow)
        Text(
          _buildDeclaration(),
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 24),

        /// Checkbox + "terms and conditions"
        InkWell(
          onTap: () => setState(() => _isAgreed = !_isAgreed),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.black45,
                    width: 1.5,
                  ),
                  color: _isAgreed ? Colors.black : Colors.transparent,
                ),
                child: _isAgreed
                    ? const Icon(
                  Icons.check,
                  size: 18,
                  color: Colors.white,
                )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    children: [
                      const TextSpan(text: 'I agree '),
                      TextSpan(
                        text: 'terms and conditions',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _openTerms,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        /// Single bottom button (same style as design)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isAgreed ? widget.onNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.btnBackground,
              disabledBackgroundColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

class DocumentUpload extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final LoginUserReqResInfo? loginResponse;
  final Map<String, List<DropdownMenuItem<AbGenLovValDesc>>> lovValues;

  const DocumentUpload({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.lovValues,
    this.loginResponse,
  });

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  AbGenLovValDesc? documentName;

  // document capture
  Uint8List? capturedImageBytes;

  // photo & signature
  final ImagePicker _picker = ImagePicker();
  Uint8List? _photoBytes;
  Uint8List? _signatureBytes;
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  bool isRemarksEmpty = false;

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  // --------------------------- DOCUMENT DIALOG ---------------------------

  void _showDocumentCaptureDialog(BuildContext outerContext, String docName) {
    final ImagePicker picker = ImagePicker();
    final TextEditingController remarksController = TextEditingController();
    bool localRemarksEmpty = false;

    XFile? capturedImage;

    Future<void> openCamera(StateSetter setModalState) async {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        final bytes = await image.readAsBytes();
        final Uint8List? finalBytes = await compressIfNeeded(bytes);
        setModalState(() {
          capturedImage = image;
        });
        setState(() {
          capturedImageBytes = finalBytes;
        });
      }
    }

    showDialog(
      context: outerContext,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              title: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.fbLiteDark,
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
                ),
                child: Text(
                  docName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Document Name",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    Text(docName, textAlign: TextAlign.center),
                    const SizedBox(height: 16.0),
                    const Text("Remarks",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: remarksController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        errorText:
                        localRemarksEmpty ? 'Remark is required' : null,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text("Capture Document:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () => openCamera(setModalState),
                      child: capturedImageBytes == null
                          ? const Icon(Icons.camera_alt,
                          size: 60, color: Colors.black)
                          : Image.memory(
                        capturedImageBytes!,
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
                  child: const Text("Upload"),
                  onPressed: () {
                    if (remarksController.text.isEmpty) {
                      setModalState(() {
                        localRemarksEmpty = true;
                      });
                    } else if (capturedImageBytes == null) {
                      showCustomBottomPopup(
                          context, "Please capture the document first");
                    } else {
                      // build request
                      final kycUpload = CommKycUpload()
                        ..documentName = docName
                        ..documentType = docName
                        ..image = base64.encode(capturedImageBytes!)
                        ..uploadtype = 'WALLET_KYC_UP'
                        ..docUniqueNum = '1234'
                        ..remarks = remarksController.text
                        ..headerInfo = widget.loginResponse!.headerInfo;

                      outerContext
                          .read<KycUploadBloc>()
                          .add(KycUploadSubmitted(kycUpload));
                      Navigator.of(context).pop();
                    }
                  },
                ),
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // -------------------------- PHOTO & SIGNATURE --------------------------

  Future<void> _capturePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    final Uint8List? finalBytes = await compressIfNeeded(bytes);

    if (finalBytes == null) return;

    setState(() => _photoBytes = finalBytes);
  }

  Future<Uint8List?> _openSignaturePad() async {
    _signatureController.clear();
    return showDialog<Uint8List?>(
      context: context,
      builder: (_) => Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 420,
            child: Column(
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Signature(
                    controller: _signatureController,
                    backgroundColor: Colors.grey[200]!,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _signatureController.clear,
                      child: const Text("Clear Pad"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_signatureController.isNotEmpty) {
                          final bytes =
                          await _signatureController.toPngBytes();
                          Navigator.of(context).pop(bytes);
                        }
                      },
                      child: const Text("Save Signature"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _captureSignature() async {
    final sigBytes = await _openSignaturePad();
    if (sigBytes == null) return;
    setState(() => _signatureBytes = sigBytes);
  }

  // ----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return BlocListener<KycUploadBloc, KycUploadState>(
      listener: (context, state) {
        if (state is KycUploadLoading) {
          context.read<LoadingCubit>().show();
        } else {
          context.read<LoadingCubit>().hide();
        }

        if (state is KycUploadSuccess) {
          // you can show success popup here
          // showDocumentUploadSuccess(context, state.user.documentName);
        } else if (state is KycUploadFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= KYC DOCUMENTS CARD =================
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'KYC Documents',
                          style: TextStyle(
                            color: AppColors.fbLiteDark,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // dropdown
                      LabeledDropdown<AbGenLovValDesc>(
                        label: "Document Name",
                        items: widget.lovValues["ab-sm-id-type"] ?? [],
                        value: documentName,
                        display: (item) => item.desc ?? "",
                        isMandatory: true,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => documentName = val);
                            _showDocumentCaptureDialog(
                              context,
                              val.val ?? '',
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // result from KycUploadBloc
                      BlocBuilder<KycUploadBloc, KycUploadState>(
                        builder: (context, state) {
                          if (state is KycUploadSuccess) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // text info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text("Selected Document Name:",
                                          style: TextStyle(fontSize: 14)),
                                      const SizedBox(height: 4),
                                      Text(
                                        state.user.documentType ?? "N/A",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text("Remarks:",
                                          style: TextStyle(fontSize: 14)),
                                      const SizedBox(height: 4),
                                      Text(
                                        state.user.remarks ?? "N/A",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text("Document Unique Number:",
                                          style: TextStyle(fontSize: 14)),
                                      const SizedBox(height: 4),
                                      Text(
                                        state.user.docUniqueNum ?? "N/A",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),

                                // image
                                if ((state.user.image != null &&
                                    state.user.image!.isNotEmpty) ||
                                    capturedImageBytes != null)
                                  Column(
                                    children: [
                                      const Text("Uploaded Document:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                      const SizedBox(height: 8),
                                      Image.memory(
                                        state.user.image != null &&
                                            state.user.image!.isNotEmpty
                                            ? base64.decode(state.user.image!)
                                            : capturedImageBytes!,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  )
                                else
                                  const Text("No image uploaded.",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 14)),
                              ],
                            );
                          } else if (state is KycUploadFailure) {
                            return Text(
                              "Upload failed: ${state.error}",
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= PHOTO & SIGNATURE CARD =================
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Photo & Signature',
                          style: TextStyle(
                            color: AppColors.fbLiteDark,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // PHOTO
                          GestureDetector(
                            onTap: _capturePhoto,
                            child: Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    border:
                                    Border.all(color: AppColors.fbLiteDark),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: _photoBytes != null
                                      ? Image.memory(_photoBytes!,
                                      fit: BoxFit.cover)
                                      : Icon(Icons.camera_alt,
                                      size: 40,
                                      color: AppColors.fbLiteDark),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Photo",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          // SIGNATURE
                          GestureDetector(
                            onTap: _captureSignature,
                            child: Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border:
                                    Border.all(color: AppColors.fbLiteDark),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: _signatureBytes != null
                                      ? Image.memory(_signatureBytes!,
                                      fit: BoxFit.contain)
                                      : Icon(Icons.edit,
                                      size: 40,
                                      color: AppColors.fbLiteDark),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Signature",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =============== PREVIOUS / NEXT ===============
              SafeArea(
                bottom: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.btnBackground,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: widget.onPrevious,
                      child: const Text("Previous"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.btnBackground,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: widget.onNext,
                      child: const Text("Next"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}








