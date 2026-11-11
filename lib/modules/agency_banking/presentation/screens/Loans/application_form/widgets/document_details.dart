import 'dart:convert';
import 'dart:typed_data';

import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/customer_registration_models/CustDocumentResponse.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/customer_registration_bloc/customer_registration_state.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:signature/signature.dart';

import '../../../../../constants/controllers.dart';
import '../../../../../data/models/lms_models/customer_registration_models/CustDocument.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlAppRequest2.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlForm.dart';
import '../../../../../theme/app_gradients.dart';
import '../../../../../theme/colors/Appcolors.dart';
import '../../../../../utils/AESEncryption.dart';
import '../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../utils/ImageCompressionHelper.dart';
import '../../../../../utils/Loader.dart';
import '../../../../blocs/lms_blocs/customer_registration_bloc/customer_registration_bloc.dart';
import '../../../../blocs/lms_blocs/customer_registration_bloc/customer_registration_event.dart';

List<String> documentNames = [
  'AADHAAR',
  'PAN',
  'Address Proof',
  'Employer Identity Card'
];
List<CustDocument> uploadedDocs = [];
List<CustDocumentResponse> gotDocs = [];
Uint8List? imageData;
Uint8List? _capturedImage;
Uint8List? _signatureImage;
Uint8List? tempImageData;
bool onUploadComplete = false;
String? ocrName;
String? ocrId;
DateTime? ocrDob;
String? ocrGen;

class KycDocumentDetails extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Uint8List? initialPhoto;
  final Uint8List? initialSignature;
  // ✅ Accepts the list directly
  final List<CustDocumentResponse> initialDocuments;
  final Function(List<CustDocument>) onDocumentsReady;
  final Function(Uint8List? photo, Uint8List? signature, String? photoExt,
      String? signExtension) onPhotoSignatureReady; // ✅ new callback
  final String? eKyc;

  const KycDocumentDetails({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.onDocumentsReady,
    required this.onPhotoSignatureReady,
    this.initialPhoto,
    this.initialSignature,
    required this.initialDocuments,
    this.eKyc,
  });

  @override
  State<KycDocumentDetails> createState() => _KycDocumentDetailsState();
}

class _KycDocumentDetailsState extends State<KycDocumentDetails> {
  final TextEditingController otpController = TextEditingController();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  final ImagePicker _picker = ImagePicker();
  String? documentName;
  // Uint8List? _capturedImage;
  // Uint8List? _signatureImage;
  final TextEditingController remarksController = TextEditingController();
  bool isRemarksEmpty = false;
  // KycOption? _selectedOption;
  bool onUploadComplete = false;
  String? photoExtension;
  String? signatureExtension;
  // Uint8List? imageData;
  String? fileExtension;
  bool isUploadAction = false;
  String? selectedFileName;
  @override
  void dispose() {
    otpController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _capturedImage = widget.initialPhoto;
    _signatureImage = widget.initialSignature;
    gotDocs = widget.initialDocuments;

    // Decode each gotDoc
    for (final doc in gotDocs) {
      try {
        final base64Str = doc.file?.split(',').last ?? doc.file ?? '';
        final decoded = base64Decode(base64Str);
        doc.decodedFile =
            decoded; // Add this field to the CustDocumentResponse class
      } catch (e) {
        AppLogger.error('Error decoding document', e);
      }
    }
  }

  Future<void> openCamera(StateSetter setModalState, ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      // Read original image bytes
      Uint8List originalBytes = await image.readAsBytes();

      // ✅ Compress if needed
      final Uint8List? compressedBytes = await compressIfNeeded(originalBytes);
      if (compressedBytes == null) return;

      // ✅ Get MIME type and file extension
      final mimeType = lookupMimeType('', headerBytes: compressedBytes);
      final ext = mimeType != null ? mimeType.split('/').last : "jpg";
      // ✅ Extract the original file name (without extension)
      final String fileName = p.basenameWithoutExtension(image.path);
      AppLogger.debug('Document file selected');
      AppLogger.debug('Document extension detected');

      // ✅ Save to your temp fields
      setModalState(() {
        imageData = compressedBytes;
        fileExtension = ext;
        selectedFileName = fileName;
      });
    }
  }

  void _showImageSourcePicker(BuildContext context, StateSetter setModalState) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await openCamera(setModalState, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await openCamera(setModalState, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> detectExtension(Uint8List bytes) async {
    final mimeType = lookupMimeType('', headerBytes: bytes);
    if (mimeType != null) {
      return mimeType.split('/').last; // e.g. "png" or "jpeg"
    }
    return "jpg"; // fallback
  }

  Future<void> _handleCapturePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();
      final Uint8List? finalBytes = await compressIfNeeded(bytes);
      final mimeType = lookupMimeType('', headerBytes: finalBytes);
      final extension = mimeType != null ? mimeType.split('/').last : "";
      setState(() {
        _capturedImage = finalBytes;
        photoExtension = extension; // "jpg"/"png"
      });
      AppLogger.debug('Photo captured successfully');
      AppLogger.debug('Photo extension resolved');
      widget.onPhotoSignatureReady(
          _capturedImage, _signatureImage, photoExtension, signatureExtension);
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
                      onPressed: () {
                        _signatureController.clear();
                      },
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
    final Uint8List? signature = await _showSignatureDialog();
    if (signature != null) {
      final mimeType = lookupMimeType('', headerBytes: signature);
      final extension = mimeType != null ? mimeType.split('/').last : "";
      setState(() {
        _signatureImage = signature;
        signatureExtension = extension;
      });
      widget.onPhotoSignatureReady(
          _capturedImage, _signatureImage, photoExtension, signatureExtension);
    }
  }

  void submitDocumentDetails(
    BuildContext context,
    List<CustDocument> documents,
    Uint8List? customerPhoto,
    Uint8List? customerSignature,
    String? photoExtension,
    String? signatureExtension,
  ) {
    final req = GdbCustRtlAppRequest<GdbCustRtlForm>();
    req.screenId = 'CLIENT_DATA';
    req.isDraft = true;

    GdbCustRtlForm form = GdbCustRtlForm();
    form.phone = AESEncryptionService.encrypt(mobileNoController.text);
    form.kycStatus = "SUCCESS";
    form.docs = documents;
    AppLogger.debug('Submitting document details');
    AppLogger.debug('Document name processed');
    AppLogger.debug('Document submission in progress');
    AppLogger.debug('Document file name processed');
    AppLogger.debug('Document upload prepared');
    AppLogger.debug('Document extension processed');

    CustDocument photo = CustDocument();
    photo.docName = "profilePic";
    photo.fileName = "profilePic";
    photo.issuingDate = "24/10/2015";
    photo.expiryDate = "28/04/2029";
    photo.extension = photoExtension;
    photo.file = customerPhoto;

    CustDocument signature = CustDocument();
    signature.docName = "signature";
    signature.fileName = "signature";
    signature.issuingDate = "24/10/2015";
    signature.expiryDate = "28/04/2029";
    signature.extension = signatureExtension ?? '';
    signature.file = customerSignature;

    form.profilePic = photo;
    form.signature = signature;
    req.customerDet = form;
    saveRequestToDownloads(req);
    context.read<CustomerRegistrationBloc>().add(
          CustomerRegistrationSubmitted<GdbCustRtlForm>(req),
        );
  }

  void _showDocumentCaptureDialog(
    BuildContext outerContext,
    String documentName,
    StateSetter updateParentState,
  ) {
    Future<void> openCamera(StateSetter setModalState) async {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // Read image bytes
        Uint8List originalBytes = await image.readAsBytes();

        // ✅ Compress if needed
        final Uint8List? compressedBytes =
            await compressIfNeeded(originalBytes);

        if (compressedBytes == null) return;

        // ✅ Get extension properly (.jpg/.png)
        String ext =
            p.extension(image.path).replaceFirst('.', ''); // remove dot

        tempImageData = compressedBytes;
        setModalState(() {
          imageData = compressedBytes;
          fileExtension = ext;
        });
      }
    }

    // Reset data every time dialog opens
    imageData = null;
    tempImageData = null;
    fileExtension = null;
    isRemarksEmpty = false;
    remarksController.clear();

    showDialog(
      context: outerContext,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.fbTooLite,
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
                    SizedBox(height: 8),
                    Text(documentName, textAlign: TextAlign.center),
                    SizedBox(height: 16),
                    Text("Remarks",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextField(
                      controller: remarksController,
                      textAlign: TextAlign.center,
                      maxLength: 30,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        errorText: isRemarksEmpty ? 'Remark is required' : null,
                      ),
                    ),
                    SizedBox(height: 16),
                    const Text("Capture Document:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    // GestureDetector(
                    //   onTap: () => openCamera(setModalState),
                    //   child: imageData == null
                    //       ? Icon(Icons.camera_alt, size: 60, color: Colors.black)
                    //       : imageData != null
                    //       ? Image.memory(
                    //     imageData!,
                    //     height: 100,
                    //     width: 150,
                    //     fit: BoxFit.cover,
                    //   )
                    //       : const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    //
                    // ),
                    GestureDetector(
                      onTap: () =>
                          _showImageSourcePicker(context, setModalState),
                      child: imageData == null
                          ? const Icon(Icons.camera_alt,
                              size: 60, color: Colors.black)
                          : Image.memory(
                              imageData!,
                              height: 100,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    child: Text("Upload"),
                    onPressed: () {
                      if (remarksController.text.isEmpty) {
                        setModalState(() {
                          isRemarksEmpty = true;
                        });
                        return;
                      }

                      if (imageData == null) {
                        ScaffoldMessenger.of(outerContext).showSnackBar(
                          const SnackBar(content: Text('Image is required')),
                        );
                        return;
                      }

                      // Convert captured image into CustDocument
                      // final newDoc = CustDocument(
                      //   docName: documentName, // or your logic
                      //   file: imageData, // keep Uint8List here
                      //   fileName: documentName,
                      //   issuingDate: "24/10/2015",
                      //   extension: "png",
                      //   expiryDate: "28/04/2029",
                      //
                      // );
                      final newDoc = CustDocument(
                        docName: documentName, // or your logic
                        file: imageData, // keep Uint8List here
                        fileName: selectedFileName ?? documentName,
                        issuingDate: "24/10/2015",
                        extension: "jpg",
                        expiryDate: "28/04/2029",
                      );
                      setState(() {
                        uploadedDocs.add(newDoc);
                      });
                      widget.onDocumentsReady(uploadedDocs);
                      Navigator.of(context).pop();
                    }),
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerRegistrationBloc, CustomerRegistrationState>(
      listener: (context, state) {
        if (state is CustomerRegistrationLoading) {
          context.read<LoadingCubit>().show();
        } else {
          context.read<LoadingCubit>().hide();
        }

        if (state is CustomerRegistrationSuccess) {
          if (isUploadAction) {
            setState(() {
              ocrGen = state.gdbMerchantDisProductPurResponse.gender;
              ocrDob = state.gdbMerchantDisProductPurResponse.dob;
              ocrName = state.gdbMerchantDisProductPurResponse.custName;
              ocrId = state.gdbMerchantDisProductPurResponse.uniqueId;
            });
            photoAndImageUploadSuccess(context);
            AppLogger.debug('Document registration successful');
            AppLogger.debug('Customer unique ID received');
            AppLogger.debug('Customer gender received');
            AppLogger.debug('Customer DOB received');
            AppLogger.debug('Customer name received');
          }
        } else if (state is CustomerRegistrationFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            label: RichText(
                              text: TextSpan(
                                text: 'Document Name',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0),
                            ),
                          ),
                          value: documentName,
                          items: documentNames.map((name) {
                            return DropdownMenuItem(
                              value: name,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                documentName = value;
                              });
                              _showDocumentCaptureDialog(
                                  context, value, setState);
                              // GestureDetector(
                              //   onTap: () => _showImageSourcePicker(context, setModalState),
                              //   child: imageData == null
                              //       ? const Icon(Icons.camera_alt, size: 60, color: Colors.black)
                              //       : Image.memory(
                              //     imageData!,
                              //     height: 100,
                              //     width: 150,
                              //     fit: BoxFit.cover,
                              //   ),
                              // );
                            }
                          },
                        ),
                      SizedBox(height: 20),

                      /// Uploaded Documents Preview
                      if (uploadedDocs.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Text(
                              "Uploaded Documents",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.fbTooLite,
                              ),
                            ),

                            SizedBox(height: 8),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: uploadedDocs.map((doc) {
                                  return Container(
                                    width: 250,
                                    margin: EdgeInsets.only(right: 15),
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Name:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(doc.docName ?? ''),
                                        SizedBox(height: 8),
                                        Text("Remarks:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(remarksController.text),
                                        SizedBox(height: 8),
                                        Text("Document:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 6),
                                        if (doc.file != null)
                                          Image.memory(
                                            doc.file!,
                                            height: 100,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
//                             Text("OCR Extracted Fields:", style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.blue)),
//                             const SizedBox(height: 6),
//
// // 🧩 Side-by-side key-value pairs
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text("Name:", style: TextStyle(fontWeight: FontWeight.bold)),
//                                 Text(ocrName ?? ''),
//                               ],
//                             ),
//                             const SizedBox(height: 4),
//
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text("Unique ID:", style: TextStyle(fontWeight: FontWeight.bold)),
//                                 Text(ocrId ?? ''),
//                               ],
//                             ),
//                             const SizedBox(height: 4),
//
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text("DOB:", style: TextStyle(fontWeight: FontWeight.bold)),
//                                 Text(
//                                   ocrDob != null ? DateFormat('dd/MM/yyyy').format(ocrDob!) : '',
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 4),
//
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text("Gender:", style: TextStyle(fontWeight: FontWeight.bold)),
//                                 Text(ocrGen ?? ''),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
                          ],
                        ),

                      if (gotDocs.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Text(
                              "Documents",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.fbTooLite,
                              ),
                            ),
                            SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: gotDocs.map((doc) {
                                  return Container(
                                    width: 250,
                                    margin: EdgeInsets.only(right: 15),
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey[200],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Name:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(doc.fileName ?? 'Unknown'),
                                        SizedBox(height: 8),
                                        Text("Ref No:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(doc.docRef ?? ''),
                                        SizedBox(height: 8),
                                        Text("Document:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 6),
                                        if (doc.decodedFile != null)
                                          Image.memory(
                                            doc.decodedFile!,
                                            height: 100,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          )
                                        else
                                          Text("Invalid or missing file"),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
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
                        // ------------------- PHOTO -------------------
                        GestureDetector(
                          onTap: gotDocs.isEmpty ? _handleCapturePhoto : null,
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
                                child: _capturedImage != null
                                    ? Image.memory(_capturedImage!,
                                        fit: BoxFit.cover)
                                    : Icon(Icons.camera_alt,
                                        size: 40, color: AppColors.fbLiteDark),
                              ),
                              const SizedBox(height: 8),
                              const Text("Photo",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),

                        // ------------------- SIGNATURE -------------------
                        GestureDetector(
                          onTap: gotDocs.isEmpty ? _handleSignaturePad : null,
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
                                child: _signatureImage != null
                                    ? Image.memory(_signatureImage!,
                                        fit: BoxFit.contain)
                                    : const Icon(Icons.edit,
                                        size: 40, color: AppColors.fbLiteDark),
                              ),
                              const SizedBox(height: 8),
                              const Text("Signature",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
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

            // ------------------- UPLOAD BUTTON -------------------
            if (gotDocs.isEmpty)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppBackgrounds.widgetsBackground,
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // ---- VALIDATION BEFORE UPLOADING ----
                      if (_signatureImage == null &&
                          _capturedImage == null &&
                          uploadedDocs.isEmpty) {
                        showCustomBottomPopup(
                            context, "Upload document, photo and signature");
                        return;
                      }

                      if (_signatureImage == null && _capturedImage == null) {
                        showCustomBottomPopup(
                            context, "Upload photo and signature");
                        return;
                      }

                      if (_signatureImage == null && uploadedDocs.isEmpty) {
                        showCustomBottomPopup(
                            context, "Upload document and signature");
                        return;
                      }

                      if (_capturedImage == null && uploadedDocs.isEmpty) {
                        showCustomBottomPopup(
                            context, "Upload document and photo");
                        return;
                      }

                      if (uploadedDocs.isEmpty) {
                        showCustomBottomPopup(context, "Upload KYC document");
                        return;
                      }

                      if (_capturedImage == null) {
                        showCustomBottomPopup(context, "Upload photo");
                        return;
                      }

                      if (_signatureImage == null) {
                        showCustomBottomPopup(context, "Upload signature");
                        return;
                      }

                      setState(() {
                        isUploadAction = true;
                      });
                      submitDocumentDetails(
                        context,
                        uploadedDocs, // all captured KYC docs
                        _capturedImage, // photo
                        _signatureImage, // signature
                        photoExtension, // extension for photo
                        signatureExtension, // extension for signature
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)),
                    ),
                    child: const Text(
                      'Upload',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),

            SizedBox(height: 20),
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
                    //onPressed: widget.onNext,
                    onPressed: () {
                      setState(() {
                        isUploadAction = false;
                      });
                      widget.onNext.call();
                    },
                    child: Text(widget.eKyc == "KYC" ? "Submit" : "Next"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
