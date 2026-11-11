import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef ImagePickerCallBack = void Function(File file);
typedef FilePickerCallBack = void Function(File file);

class AppColors {
  static const k333333 = Color(0xFF333333);
}

class CommonUtilities {
  CommonUtilities();

  /// Public entry used by your UI
  void openImagePicker(BuildContext context, ImagePickerCallBack callbackFunc,
      [FilePickerCallBack? filePickerCallback]) {
    openImagePickerActionSheet(context, callbackFunc, filePickerCallback);
  }

  /// Shows bottom sheet with camera / gallery / files options.
  Future<void> openImagePickerActionSheet(BuildContext context,
      ImagePickerCallBack callbackFunc, FilePickerCallBack? filePickerCallback) async {
    // Wait for bottom sheet to close (optional)
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.photo_camera,
                  color: AppColors.k333333,
                ),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(bc).pop();
                  final file = await _openCamera();
                  if (file != null) callbackFunc(file);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: AppColors.k333333,
                ),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(bc).pop();
                  final file = await _openGallery();
                  if (file != null) callbackFunc(file);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.attach_file,
                  color: AppColors.k333333,
                ),
                title: const Text('Choose from Files'),
                onTap: () async {
                  Navigator.of(bc).pop();
                  final file = await _openFile();
                  if (file != null) {
                    if (filePickerCallback != null) {
                      filePickerCallback(file);
                    } else {
                      // fallback: call the same image callback
                      callbackFunc(file);
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.cancel,
                  color: AppColors.k333333,
                ),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.of(bc).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // -----------------------
  // Helper implementations
  // -----------------------

  /// Opens camera and returns a File or null.
  Future<File?> _openCamera() async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (picked == null) return null;
      return File(picked.path);
    } catch (e) {
      // handle errors (permissions, etc.)
      debugPrint('Camera error: $e');
      return null;
    }
  }

  /// Opens gallery and returns a File or null.
  Future<File?> _openGallery() async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return null;
      return File(picked.path);
    } catch (e) {
      debugPrint('Gallery error: $e');
      return null;
    }
  }

  /// Opens file picker and returns a File or null.
  Future<File?> _openFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: false,
      );
      if (result == null) return null;
      final path = result.files.single.path;
      if (path == null) return null;
      return File(path);
    } catch (e) {
      debugPrint('File picker error: $e');
      return null;
    }
  }
}
