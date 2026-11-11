import 'dart:io';
import 'dart:typed_data';

class FileModel {
  final File ?file;
  final Uint8List? bytes;
  final String name;
  final String path;
  final int size;
  final String extension;
  final String? mimeType;

  FileModel({
     this.file,
    required this.name,
    required this.path,
    required this.size,
    required this.extension,
    this.mimeType,
    this.bytes
  });

  factory FileModel.fromFile(File file) {
    final fileName = file.path.split('/').last;
    final fileExtension = fileName.split('.').last;
    final fileSize = file.lengthSync();

    return FileModel(
      file: file,
      name: fileName,
      path: file.path,
      size: fileSize,
      extension: fileExtension,
      mimeType: _getMimeType(fileExtension),
    );
  }
  
   factory FileModel.fromBytes(Uint8List bytes, String name) {
    final fileExtension = name.split('.').last;

    return FileModel(
      bytes: bytes,
      name: name,
      path: name, 
      size: bytes.length,
      extension: fileExtension,
      mimeType: _getMimeType(fileExtension),
    );
  }


  static String? _getMimeType(String extension) {
    final mimeTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'pdf': 'application/pdf',
      'doc': 'application/msword',
    };
    return mimeTypes[extension.toLowerCase()];
  }

  String get readableSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(2)} KB';
    if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
  
  bool get isWithinSizeLimit => size <= 2 * 1024 * 1024; // 2MB
  bool get isImage => ['jpg', 'jpeg', 'png', 'webp'].contains(extension.toLowerCase());
  bool get isPdf => extension.toLowerCase() == 'pdf';
  bool get isDocument => ['doc', 'docx', 'xls', 'xlsx', 'txt'].contains(extension.toLowerCase());
}