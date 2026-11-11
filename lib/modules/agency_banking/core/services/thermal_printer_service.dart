import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ThermalPrinterService {
  static const _channel = MethodChannel('com.jmr.fnb/printer');
  static final ThermalPrinterService _instance = ThermalPrinterService._();

  ThermalPrinterService._();
  factory ThermalPrinterService() => _instance;

  /// Print a formatted receipt from structured data.
  Future<bool> printReceipt(Map<String, dynamic> receiptData) async {
    return _invoke('printReceipt', {'receiptData': receiptData});
  }

  /// Print plain text content.
  Future<bool> printText(String text) async {
    return _invoke('printText', {'text': text});
  }

  /// Print an image from a file path on the device.
  Future<bool> printImageFromPath(String imagePath) async {
    return _invoke('printImage', {'imagePath': imagePath});
  }

  /// Print an image from raw bytes.
  Future<bool> printImageFromBytes(Uint8List imageBytes) async {
    return _invoke('printImage', {'imageBytes': imageBytes});
  }

  /// Print a specific page of a PDF file.
  /// [page] is zero-based (default: 0 for first page).
  Future<bool> printPdf(String pdfPath, {int page = 0}) async {
    return _invoke('printPdf', {'pdfPath': pdfPath, 'page': page});
  }

  /// Scan for available printers (USB and Bluetooth).
  /// Returns a list of printer info maps with keys:
  ///   type: "usb" or "bluetooth"
  ///   name: device name
  ///   address: device address (VID:PID for USB, MAC for Bluetooth)
  Future<List<Map<String, String>>> scanPrinters() async {
    try {
      final result = await _channel.invokeMethod('scanPrinters');
      if (result is List) {
        return result
            .cast<Map>()
            .map((m) => m.cast<String, String>())
            .toList();
      }
      return [];
    } on MissingPluginException {
      if (kDebugMode) debugPrint('ThermalPrinterService: Native printer plugin not available');
      return [];
    }
  }

  Future<bool> _invoke(String method, Map<String, dynamic> args) async {
    try {
      final result = await _channel.invokeMethod(method, args);
      if (result is String) {
        _lastDiagnostic = result;
        return true;
      }
      return result == true;
    } on MissingPluginException {
      if (kDebugMode) debugPrint('ThermalPrinterService: Native printer plugin not available');
      throw PlatformException(
        code: 'PRINTER_UNAVAILABLE',
        message: 'Printer service is not available on this device',
      );
    }
  }

  String? _lastDiagnostic;
  String? get lastDiagnostic => _lastDiagnostic;
}
