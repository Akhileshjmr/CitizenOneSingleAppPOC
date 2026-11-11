import 'dart:convert';
import 'dart:io';

import 'package:citizenone_app/modules/agency_banking/data/models/ExcelDataUpload.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/bulk_wallet_registration_bloc/bulk_wallet_registration_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/bulk_wallet_registration_bloc/bulk_wallet_registration_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/BaseScreen/base_screen.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants/ModuleCode.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../utils/DashedBorder.dart';
import '../../../../blocs/bulk_ft_bloc/bulk_ft_bloc.dart';
import '../../../../blocs/bulk_ft_bloc/bulk_ft_event.dart';

class UploadFileScreen extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final String itemKey;
  const UploadFileScreen({required this.loginResponse, required this.itemKey});
  @override
  _UploadFileScreenState createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends BaseScreenState<UploadFileScreen> {
  String? _fileName;
  String? _filePath;

  void _pickFile() async {
    final XTypeGroup xlsxTypeGroup = XTypeGroup(
      label: 'Excel',
      extensions: ['xlsx'],
    );

    final XFile? file = await openFile(
      acceptedTypeGroups: [xlsxTypeGroup],
    );

    if (file != null) {
      setState(() {
        _fileName = file.name; // File name only
        _filePath = file.path; // Full file path
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          title: "Upload File",
        ),
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.itemKey == ModuleCode.fundTransfer
                                ? "Fund Transfer "
                                : widget.itemKey ==
                                        ModuleCode.bulkWalletRegistration
                                    ? "Wallet Registration "
                                    : "",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Dotted Border (Only wraps Upload section)
                        DashedBorder(
                          color: Colors.black,
                          strokeWidth: 1.5,
                          dashLength: 8.0,
                          gapLength: 4.0,
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 120),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.cloud_upload,
                                    size: 50, color: Colors.grey),
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Upload file here",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: double
                                          .infinity, // Make button fill available width
                                      child: ElevatedButton(
                                        onPressed: _pickFile,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: myHexColor,
                                          padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  14), // vertical padding only
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          "Choose file",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // File info & Inputs (Outside Dashed Border, but inside Card)
                        if (_fileName != null) ...[
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Icon(Icons.insert_drive_file, color: myHexColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _fileName!,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel,
                                    color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _fileName = null;
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Batch No Input
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Enter batch no",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Upload Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (widget.itemKey == ModuleCode.fundTransfer) {
                                  handlebulkFtTransaction(context);
                                }
                                if (widget.itemKey ==
                                    ModuleCode.bulkWalletRegistration) {
                                  handlebulkWalletTransaction(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: myHexColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: const Text("Upload file",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> handlebulkFtTransaction(BuildContext context) async {
    if (_filePath != null) {
      final file = File(_filePath!);
      final bytes = await file.readAsBytes();
      final base64Data = base64Encode(bytes);
      ExcelDataUpload req = ExcelDataUpload();
      req.apiFlag = 'Y';
      req.bulkBatchId = "BP07";
      req.txnMethod = "WALLET";
      req.txnType = ModuleCode.fundTransfer;
      req.headerInfo = widget.loginResponse.headerInfo;
      req.filePath = _fileName ?? '';
      AppLogger.debug('Bulk upload file selected');
      req.excelData = base64Data; // Set the base64-encoded data as a string
      context.read<BulkFtBloc>().add(BulkFtSubmitted(req));
    }
  }

  Future<void> handlebulkWalletTransaction(BuildContext context) async {
    if (_filePath != null) {
      final file = File(_filePath!);
      final bytes = await file.readAsBytes();
      final base64Data = base64Encode(bytes);
      ExcelDataUpload req = ExcelDataUpload();
      req.apiFlag = 'Y';
      req.bulkBatchId = "BP07";
      req.txnMethod = "WALLET";
      req.txnType = ModuleCode.bulkWalletRegistration;
      req.headerInfo = widget.loginResponse.headerInfo;
      req.filePath = _fileName ?? '';
      AppLogger.debug('Bulk upload file selected');
      req.excelData = base64Data; // Set the base64-encoded data as a string
      context
          .read<BulkWalletRegistrationBloc>()
          .add(BulkWalletRegistrationSubmitted(req));
    }
  }
}
