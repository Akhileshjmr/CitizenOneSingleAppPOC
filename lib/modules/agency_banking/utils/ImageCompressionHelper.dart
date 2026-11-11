import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> saveRequestToDownloads(dynamic request) async {
  await Permission.storage.request();

  final downloadsDir = Directory('/storage/emulated/0/Download');
  if (!downloadsDir.existsSync()) {
    AppLogger.warning('Downloads folder not found');
    return;
  }

  final now = DateTime.now();

  // Month names
  final monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  // Format C → DD-MMM-YYYY_HH-MM-SS
  final formattedDate =
      '${_twoDigits(now.day)}-${monthNames[now.month - 1]}-${now.year}_'
      '${_twoDigits(now.hour)}-${_twoDigits(now.minute)}-${_twoDigits(now.second)}';

  final fileName = 'req_$formattedDate.txt';
  final file = File('${downloadsDir.path}/$fileName');

  await file.writeAsString(const JsonEncoder.withIndent('  ').convert(request));

  AppLogger.info('Request saved to downloads');
}

String _twoDigits(int n) => n.toString().padLeft(2, '0');

Future<Uint8List?> compressIfNeeded(Uint8List imageBytes) async {
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
    quality: 70, // 0-100, lower = more compression
  );

  AppLogger.debug(
      'Image compressed: ${(imageBytes.lengthInBytes / 1024).toStringAsFixed(2)} KB -> ${(compressedBytes.lengthInBytes / 1024).toStringAsFixed(2)} KB');

  return compressedBytes;
}
