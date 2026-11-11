import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import '../../../../../constants/controllers.dart';
import '../../../../../data/models/login_models/UserOtpValidationInfo.dart';
import '../../../../../theme/colors/Appcolors.dart'; // Make sure this path is correct
import '../../../../../utils/CommSuccessDialogues.dart';
import '../../../../blocs/forgot_password_bloc/forgot_password_bloc.dart';
import '../../../../blocs/forgot_password_bloc/forgot_password_event.dart';
import '../../../../blocs/forgot_password_bloc/forgot_password_state.dart';
import 'labeled_dropdown.dart';
import 'labeled_textField.dart';

// Enum for KYC options
enum KycOption { faceRecognition, signature, fingerprint, otp }

class DocumentDetails extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;
  final LoginUserReqResInfo loginResponse;

  const DocumentDetails({
    Key? key,
    required this.onPrevious,
    required this.onSubmit,
    required this.loginResponse,
  }) : super(key: key);

  @override
  State<DocumentDetails> createState() => _DocumentDetailsState();
}

class _DocumentDetailsState extends State<DocumentDetails> {
  @override
  void initState() {
    super.initState();
    _selectedOption = KycOption.otp; // <-- Default option

    UserOTPValidationInfo otpReq = UserOTPValidationInfo();
    otpReq.mobileNo = widget.loginResponse.headerInfo.userName;
    otpReq.userName = widget.loginResponse.headerInfo.userName;
    otpReq.headerInfo = widget.loginResponse.headerInfo;

    context.read<ForgotPasswordBloc>().add(ForgotPasswordSubmitted(otpReq));
  }

  final ImagePicker _picker = ImagePicker();
  final SignatureController _signatureController = SignatureController();
  final _formKey = GlobalKey<FormState>();

  Uint8List? _capturedImage;
  Uint8List? _signatureImage;
  KycOption? _selectedOption;
  late String? otpUniqueId;

  final Map<KycOption, String> kycOptionLabels = {
    //KycOption.faceRecognition: "Face Recognition",
    //KycOption.signature: "Signature",
    //KycOption.fingerprint: "Fingerprint",
    KycOption.otp: "OTP",
  };

  Future<void> _handleCapturePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _capturedImage = bytes;
      });
    }
  }

  Future<Uint8List?> _showSignatureDialog() async {
    return showDialog<Uint8List?>(
      context: context,
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 420,
            child: Column(
              children: [
                Container(
                  height: 250,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
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
                          final bytes = await _signatureController.toPngBytes();
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

  Future<void> _handleSignaturePad() async {
    final signature = await _showSignatureDialog();
    if (signature != null) {
      setState(() {
        _signatureImage = signature;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          otpUniqueId = state.userOtp.otpuniqueid!;
        }
        if (state is OtpValidationFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      child: Container(
        color: AppColors.applicationCardBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 KYC Option Dropdown
            LabeledDropdown(
              label: "KYC Option",
              items: kycOptionLabels.values.toList(),
              value: _selectedOption != null
                  ? kycOptionLabels[_selectedOption!]
                  : null,
              onChanged: (val) {
                final selected = kycOptionLabels.entries
                    .firstWhere((entry) => entry.value == val)
                    .key;
                setState(() {
                  _selectedOption = selected;
                });

                if (selected == KycOption.faceRecognition) {
                  _handleCapturePhoto();
                } else if (selected == KycOption.signature) {
                  _handleSignaturePad();
                }
              },
            ),

            // 🔹 Profile Picture Display
            if (_selectedOption == KycOption.faceRecognition &&
                _capturedImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Face Recognition",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _handleCapturePhoto,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Image.memory(_capturedImage!, fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),

            // 🔹 Signature Display
            if (_selectedOption == KycOption.signature &&
                _signatureImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Signature",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _handleSignaturePad,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child:
                            Image.memory(_signatureImage!, fit: BoxFit.contain),
                      ),
                    ),
                  ],
                ),
              ),

            // 🔹 Fingerprint Placeholder
            if (_selectedOption == KycOption.fingerprint)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Fingerprint capture not implemented yet.",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            // 🔹 OTP Field
            if (_selectedOption == KycOption.otp)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: LabeledTextField(
                  label: "Enter OTP",
                  controller: otpController,
                  obscureText: true,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            const SizedBox(height: 30),

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
                    /*onPressed: widget.onSubmit,*/
                    onPressed: () {
                      if (_selectedOption == KycOption.otp) {
                        if (otpController.text.isEmpty) {
                          showCustomBottomPopup(context, "OTP is Required");
                          return;
                        }
                        if (otpController.text.length < 6) {
                          showCustomBottomPopup(context, "Invalid OTP");
                          return;
                        }

                        // ✅ Call API ONLY after validation
                        UserOTPValidationInfo otpInfo = UserOTPValidationInfo();
                        otpInfo.otp = otpController.text;
                        otpInfo.otpuniqueid = otpUniqueId!;
                        otpInfo.mobileNo =
                            widget.loginResponse.headerInfo.userName;
                        otpInfo.userName =
                            widget.loginResponse.headerInfo.userName;
                        otpInfo.headerInfo = widget.loginResponse.headerInfo;

                        context
                            .read<ForgotPasswordBloc>()
                            .add(ValidateOtpSubmitted(otpInfo));
                      }

                      widget.onSubmit();
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
