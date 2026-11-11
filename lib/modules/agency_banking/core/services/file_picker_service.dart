import 'dart:io';
import 'package:citizenone_app/modules/agency_banking/core/models/file_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<FileModel?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxWidth: 1280,
        maxHeight: 1280,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          Uint8List bytes = await pickedFile.readAsBytes();
          return FileModel.fromBytes(bytes, pickedFile.name);
        }
        return FileModel.fromFile(File(pickedFile.path));
      }
      return null;
    } catch (e) {
      throw Exception('Error picking image: $e');
    }
  }

  Future<FileModel?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
        maxWidth: 1280,
        maxHeight: 1280,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          Uint8List bytes = await pickedFile.readAsBytes();
          return FileModel.fromBytes(bytes, pickedFile.name);
        }
        return FileModel.fromFile(File(pickedFile.path));
      }
      return null;
    } catch (e) {
      throw Exception('Error capturing image: $e');
    }
  }

  Future<List<FileModel>> pickMultipleImages() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 75,
        maxWidth: 1280,
        maxHeight: 1280,
      );

      return pickedFiles
          .map((xFile) => FileModel.fromFile(File(xFile.path)))
          .toList();
    } catch (e) {
      throw Exception('Error picking multiple images: $e');
    }
  }

  Future<FileModel?> pickVideo() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        return FileModel.fromFile(File(pickedFile.path));
      }
      return null;
    } catch (e) {
      throw Exception('Error picking video: $e');
    }
  }

  Future<FileModel?> pickFile({
    List<String>? allowedExtensions,
    FileType fileType = FileType.any,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: fileType,
          allowedExtensions: allowedExtensions,
          allowMultiple: false,
          withData: true);
      if (result == null) return null;

      final file = result.files.single;
      if (file.bytes != null) {
        if (kIsWeb) {
          return FileModel.fromBytes(file.bytes!, file.name);
        }
        return FileModel.fromFile(File(file.path!));
      }

      return null;
    } catch (e) {
      throw Exception('Error picking file: $e');
    }
  }

  Future<List<FileModel>> pickMultipleFiles({
    List<String>? allowedExtensions,
    FileType fileType = FileType.any,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null) {
        return result.files
            .where((file) => file.path != null)
            .map((file) => FileModel.fromFile(File(file.path!)))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error picking multiple files: $e');
    }
  }

  Future<FileModel?> pickPdf() async {
    return await pickFile(
      fileType: FileType.custom,
      allowedExtensions: ['pdf'],
    );
  }

  Future<FileModel?> pickDocument() async {
    return await pickFile(
      fileType: FileType.custom,
      allowedExtensions: ['doc', 'docx', 'txt', 'pdf'],
    );
  }

  Future<List<int>> fileToBytes(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return bytes;
      // return base64Encode(bytes);
    } catch (e) {
      throw Exception('Error converting file to Base64: $e');
    }
  }
}
