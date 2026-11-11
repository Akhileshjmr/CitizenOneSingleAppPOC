import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class AadharScanner extends StatefulWidget {
  const AadharScanner({super.key});

  @override
  State<AadharScanner> createState() => _AadharScannerState();
}

class _AadharScannerState extends State<AadharScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) controller?.pauseCamera();
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 25,
          borderWidth: 8,
          cutOutSize: 280,
        ),
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;

    await Future.delayed(const Duration(milliseconds: 250));
    await controller.pauseCamera();
    await Future.delayed(const Duration(milliseconds: 250));
    await controller.resumeCamera();

    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      Navigator.pop(context, scanData.code);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
