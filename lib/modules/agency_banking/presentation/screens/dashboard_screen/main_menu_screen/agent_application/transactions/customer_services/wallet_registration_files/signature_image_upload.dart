import 'dart:convert';
import 'dart:typed_data';

import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import '../../../../../../../../data/models/CommCustImageSign.dart';
import '../../../../../../../../data/models/CommCustImageSignList.dart';
import '../../../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../../../../theme/colors/Appcolors.dart';
import '../../../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../../../../utils/ImageCompressionHelper.dart';
import '../../../../../../../../utils/Loader.dart';
import '../../../../../../../blocs/image_upload_bloc/image_upload_bloc.dart';
import '../../../../../../../blocs/image_upload_bloc/image_upload_event.dart';
import '../../../../../../../blocs/image_upload_bloc/image_upload_state.dart';
import '../../../../../../Dashboard/widgets/BankSelectionScreen.dart';

class ImageUploadPage extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final VoidCallback onPrevious;
  final BankOption selectedBank;
  // final VoidCallback onSubmit;
  final String? customerId;
  const ImageUploadPage({
    required this.loginResponse,
    required this.onPrevious,
    this.customerId,
    required this.selectedBank,
  });
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

  Uint8List? _signatureImage;
  Uint8List? _capturedImage;
  bool _isTermsAccepted = false;
  Uint8List? capturedImageBytes;
  XFile? image;

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
          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
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
                          _signatureController.clear();
                          _signatureImage = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fbLiteDark,
                      ),
                      child: const Text('Clear Pad',
                          style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_signatureController.isNotEmpty) {
                          final signature =
                              await _signatureController.toPngBytes();
                          setState(() {
                            _signatureImage = signature;
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fbLiteDark,
                      ),
                      child: const Text('Save Signature',
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

  Future<void> _handleCapturePhoto() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      final Uint8List bytes = await pickedImage.readAsBytes();
      final Uint8List? finalBytes = await compressIfNeeded(bytes);
      setState(() {
        _capturedImage = finalBytes;
        image = pickedImage;
      });
      AppLogger.debug('Photo captured successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustImageUploadBloc, CustImageUploadState>(
      listener: (context, state) {
        if (state is CustImageUploadLoading) {
          context.read<LoadingCubit>().show();
        } else {
          context.read<LoadingCubit>().hide();
        }

        if (state is CustImageUploadSuccess) {
          walletDocSuccess(context, state.message, widget.loginResponse,
              widget.selectedBank);
        } else if (state is CustImageUploadFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Camera Capture
              GestureDetector(
                onTap: _handleCapturePhoto,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: _capturedImage != null
                      ? Image.memory(_capturedImage!, fit: BoxFit.cover)
                      : Image.asset('assets/images/img_1.png',
                          fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Take A Picture',
                  style: TextStyle(
                      color: AppColors.fbLiteDark,
                      fontWeight: FontWeight.bold)),

              const SizedBox(height: 20),

              // Signature
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
                      ? Image.memory(_signatureImage!)
                      : Image.asset('assets/images/img_2.png',
                          fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 10),
              Text('Draw Your Signature',
                  style: TextStyle(
                      color: AppColors.fbLiteDark,
                      fontWeight: FontWeight.bold)),

              const SizedBox(height: 20),

              // Terms and Conditions
              Container(
                height: 250,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        title: Text('I agree to the Terms and Conditions',
                            style: TextStyle(color: AppColors.fbLiteDark)),
                        value: _isTermsAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            _isTermsAccepted = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 10),
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

              const SizedBox(height: 30),

              // buildActionButton(
              // label: "Upload",
              // onPressed: () => sumbit_image(context),
              // ),

              const SizedBox(height: 30),

              // 🔹 Navigation Buttons
              SafeArea(
                bottom: true,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: widget.onPrevious,
                        child: const Text("Previous"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.btnBackground,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => sumbit_image(context),
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sumbit_image(BuildContext context) {
    if (_capturedImage == null && _signatureImage == null) {
      showCustomBottomPopup(context, "Please Capture Image and Signature");
      return;
    }
    if (_capturedImage == null) {
      showCustomBottomPopup(context, "Please Capture Image");
      return;
    }
    if (_signatureImage == null) {
      showCustomBottomPopup(context, "Please Capture Signature");
      return;
    }
    final custImageSign = CommCustImageSign()
      ..docUniqueNum = "I"
      ..documentType = "Ok"
      ..documentName = "I"
      ..image = _capturedImage != null ? base64.encode(_capturedImage!) : null;

    final custImageSign1 = CommCustImageSign()
      ..docUniqueNum = "S"
      ..documentType = "Ok"
      ..documentName = "S"
      ..image =
          _signatureImage != null ? base64.encode(_signatureImage!) : null;

    final commCustImageSignList = CommCustImageSignList()
      ..headerInfo = widget.loginResponse?.headerInfo
      ..customerId = widget.customerId
      ..transactionType = "WALLET_IMG_UPLOAD"
      ..commCustImageSignList = [custImageSign, custImageSign1];

    context
        .read<CustImageUploadBloc>()
        .add(CustImageUploadSubmitted(commCustImageSignList));
  }
}
