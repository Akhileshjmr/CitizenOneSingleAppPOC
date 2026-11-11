import 'dart:convert';
import 'dart:typed_data';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/step_placeholder.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/customer_services/wallet_registration_files/wallet_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../../data/models/CommKycUpload.dart';
import '../../../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../../../../data/models/lov_models/AbGenLovValDesc.dart';
import '../../../../../../../../theme/colors/Appcolors.dart';
import '../../../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../../../../utils/ImageCompressionHelper.dart';
import '../../../../../../../../utils/Loader.dart';
import '../../../../../../../../utils/UICleanupHelper.dart';
import '../../../../../../../blocs/kyc_upload_bloc/kyc_upload_bloc.dart';
import '../../../../../../../blocs/kyc_upload_bloc/kyc_upload_event.dart';
import '../../../../../../../blocs/kyc_upload_bloc/kyc_upload_state.dart';
import '../../../../../../Loans/application_form/widgets/document_details.dart';
import '../../../../../../Loans/application_form/widgets/labeled_dropdown.dart';

class KycDocument extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final LoginUserReqResInfo? loginResponse;
  final Map<String, List<DropdownMenuItem<AbGenLovValDesc>>> lovValues;
  const KycDocument({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.lovValues, this.loginResponse,
  });

  @override
  State<KycDocument> createState() => _KycDocumentDetailsState();
}

class _KycDocumentDetailsState extends State<KycDocument> {
  AbGenLovValDesc? documentName;
  Uint8List? capturedImageData;
  XFile? capturedImageFile;
  bool isRemarksEmpty = false;
  // KycOption? _selectedOption;
  bool onUploadComplete = false;
  Uint8List? capturedImageBytes;
  Uint8List? imageBytes;
  Uint8List? uploadedImage;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
  }

  void _showDocumentCaptureDialog(BuildContext outerContext, String documentName) {
    final ImagePicker picker = ImagePicker();
    final TextEditingController remarksController = TextEditingController();
    bool localRemarksEmpty = false;
    XFile? capturedImage;
    Uint8List? imageData;

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
                      child: capturedImageBytes == null
                          ? Icon(Icons.camera_alt, size: 60, color: Colors.black)
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
                    child: Text("Upload"),
                    onPressed: () {
                      if (remarksController.text.isEmpty) {
                        setModalState(() {
                          isRemarksEmpty = true;
                        });
                      } else if (capturedImageBytes == null) {
                        showCustomBottomPopup(context, "Please capture the document first");
                      } else {
                        CommKycUpload kycUpload = CommKycUpload();
                        kycUpload.documentName = documentName;
                        kycUpload.documentType = documentName;
                        kycUpload.image = base64.encode(capturedImageBytes!); // ✅ will not be null now
                        kycUpload.uploadtype = 'WALLET_KYC_UP';
                        kycUpload.docUniqueNum = '1234';
                        kycUpload.remarks = remarksController.text;
                        kycUpload.headerInfo = widget.loginResponse!.headerInfo;

                        outerContext.read<KycUploadBloc>().add(KycUploadSubmitted(kycUpload));
                        Navigator.of(context).pop();
                      }
                    }
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


  @override
  Widget build(BuildContext context) {
    return BlocListener<KycUploadBloc, KycUploadState>(
        listener: (context, state) {
      if (state is KycUploadLoading) {
        context.read<LoadingCubit>().show();
      }
          if (state is KycUploadSuccess) {
            context.read<LoadingCubit>().hide();
            res=state.user;
            showDocumentUploadSuccess(context,state.user.documentName);

          }
          else if (state is KycUploadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: ListView(
            shrinkWrap: true,
            children: [
              // Upload Photo & Signature Section
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: StatefulBuilder(
                    builder: (context, setState) => Column(
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
                        SizedBox(height: 16),
                        if (gotDocs.isEmpty)
                          LabeledDropdown<AbGenLovValDesc>(
                            label: "Document Name",
                            items: widget.lovValues["ab-sm-id-type"] ?? [],
                            value: documentName,
                            display: (item) => item.desc ?? "", // 👈 always show description
                            isMandatory: true,
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  documentName = val;
                                });
                                _showDocumentCaptureDialog(
                                  context,
                                  val.val ?? '',
                                );
                              }
                            },
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Selected Document Name:", style: TextStyle(fontSize: 14)),
                                        SizedBox(height: 4),
                                        Text(
                                          state.user.documentType ?? "N/A",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        SizedBox(height: 16),

                                        Text("Remarks:", style: TextStyle(fontSize: 14)),
                                        SizedBox(height: 4),
                                        Text(
                                          state.user.remarks ?? "N/A",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        SizedBox(height: 16),

                                        Text("Document Unique Number:", style: TextStyle(fontSize: 14)),
                                        SizedBox(height: 4),
                                        Text(
                                          state.user.docUniqueNum ?? "N/A",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),

                                  // Uploaded Image Column
                                  // Uploaded Image Column
                                  if ((state.user.image != null && state.user.image!.isNotEmpty) || capturedImageBytes != null)
                                    Column(
                                      children: [
                                        Text("Uploaded Document:",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                        SizedBox(height: 8),
                                        Image.memory(
                                          state.user.image != null && state.user.image!.isNotEmpty
                                              ? base64.decode(state.user.image!) // ✅ from API
                                              : capturedImageBytes!,              // ✅ fallback from local state
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    )
                                  else
                                    Text("No image uploaded.",
                                        style: TextStyle(color: Colors.red, fontSize: 14)),

                                ],
                              );
                            } else if (state is KycUploadFailure) {
                              return Text("Upload failed: ${state.error}",
                                  style: TextStyle(color: Colors.red, fontSize: 14));
                            }
                            return SizedBox();
                          },
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              SafeArea(
                bottom: true, // ignore bottom SafeArea
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:AppColors.btnBackground,
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
              )
            ],
          ),
        )
    );
  }
}
