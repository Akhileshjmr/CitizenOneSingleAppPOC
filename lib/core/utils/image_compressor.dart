import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressor {
Future<Uint8List?> compress(Uint8List imageBytes) async {
  // 1 MB = 1024 * 1024 bytes
  const int maxSizeInBytes = 1024 * 1024;

  if (imageBytes.lengthInBytes <= maxSizeInBytes) {
    return imageBytes;
  }

  // Compress
  final compressedBytes = await FlutterImageCompress.compressWithList(
    imageBytes,
    minWidth: 800, // adjust based on needs
    minHeight: 800,
    quality: 70,   // 0-100, lower = more compression
  );

  debugPrint("Original size: ${(imageBytes.lengthInBytes / 1024).toStringAsFixed(2)} KB");
  debugPrint("Compressed size: ${(compressedBytes.lengthInBytes / 1024).toStringAsFixed(2)} KB");

  return compressedBytes;
}
}