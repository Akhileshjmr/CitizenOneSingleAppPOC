import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentUploadModel {
  String? docId; // after upload
  String name = "";
  String? filePath;
  File? preview;

  RxBool isSaved = false.obs; // tick icon state
  RxBool isUploading = false.obs;
  RxDouble progress = 0.0.obs;

  TextEditingController textController = TextEditingController();

  Future<String?> fileToBase64() async {
    try {
      if (filePath == null) return null;
      final bytes = await File(filePath!).readAsBytes();
      return base64Encode(bytes);
    } catch (_) {
      return null;
    }
  }

  /// API expects ONLY docId
  Map<String, dynamic> toSubmitJson() => {"docId": docId};
}
