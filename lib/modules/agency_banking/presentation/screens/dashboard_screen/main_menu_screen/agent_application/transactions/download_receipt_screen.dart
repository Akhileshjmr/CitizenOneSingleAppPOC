import 'dart:convert';
import 'dart:io';

import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '../../../../../../core/services/thermal_printer_service.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../utils/CommDialog.dart';
import '../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../Dashboard/dashboard_entry.dart';

class DownloadReceiptScreen extends StatefulWidget {
  final String? transactionPdf;
  final LoginUserReqResInfo? loginResponse;
  final BankOption selectedBank;
  final bool fromHistory;
  final bool fromSucess;

  const DownloadReceiptScreen({
    Key? key,
    this.loginResponse,
    this.transactionPdf,
    required this.selectedBank,
    this.fromHistory = false,
    this.fromSucess = false,
  }) : super(key: key);

  @override
  _DownloadReceiptScreen createState() => _DownloadReceiptScreen();
}

class _DownloadReceiptScreen extends State<DownloadReceiptScreen> {
  File? receiptFile;
  PdfDocument? pdfDocument;
  late Future<PdfPageImage> firstPageFuture;
  late bool cameFromHistory;
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    cameFromHistory = widget.fromHistory;
    _initPdf();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    pdfDocument?.close();
    super.dispose();
  }

  Future<void> _initPdf() async {
    try {
      final bytes = base64Decode(widget.transactionPdf ?? '');
      final tempDir = await getTemporaryDirectory();
      final pdfFile =
          await File('${tempDir.path}/receipt.pdf').writeAsBytes(bytes);

      pdfDocument = await PdfDocument.openFile(pdfFile.path);

      firstPageFuture = pdfDocument!.getPage(1).then((page) async {
        // 🔥 Render at higher resolution for better clarity
        final image = await page.render(
          width: page.width * 2,
          height: page.height * 2.5,
        );
        await page.close();
        return image!;
      });

      setState(() {
        receiptFile = pdfFile;
      });
    } catch (e) {
      debugPrint('Error decoding PDF: $e');
    }
  }

  void _navigateBack() {
    if (cameFromHistory) {
      Navigator.pop(
          context); // Close Receipt -> returns to existing HistoryScreen
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => buildDashboardEntry(
            loginResponse: widget.loginResponse!,
            selectedBank: widget.selectedBank,
          ),
        ),
        (route) => false,
      );
    }
  }

  void _navigateAppBack() {
    if (widget.fromSucess) {
      Navigator.pop(context);
      return;
    }
    _navigateBack();
  }

  Future<void> _printReceipt() async {
    if (receiptFile == null) {
      showCustomBottomPopup(
          context, "Receipt not loaded yet. Please wait and try again.");
      return;
    }

    _showPrintingDialog();

    try {
      final printerService = ThermalPrinterService();
      final pageCount = pdfDocument != null ? pdfDocument!.pagesCount : 1;

      bool printed = false;
      for (int i = 0; i < pageCount; i++) {
        printed = await printerService.printPdf(receiptFile!.path, page: i);
        if (!printed) break;
      }

      if (!mounted) return;
      Navigator.of(context).pop();

      if (printed) {
        _showPrintSuccessDialog(printerService.lastDiagnostic);
      } else {
        showCustomBottomPopup(
            context, "Print failed. Please check the printer and try again.");
      }
    } on PlatformException catch (e) {
      if (mounted) Navigator.of(context).pop();
      showCustomBottomPopup(context, e.message ?? "Print error");
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      showCustomBottomPopup(context, "Print error: $e");
    }
  }

  void _showPrintingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Printing receipt...'),
          ],
        ),
      ),
    );
  }

  void _showPrintSuccessDialog([String? diagnostic]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle,
                  size: 40, color: AppColors.fbTooLite),
              const SizedBox(height: 16),
              const Text('Receipt printed successfully',
                  style: TextStyle(fontSize: 18)),
              if (diagnostic != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    diagnostic,
                    style:
                        const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.btnBackground),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> savePdf() async {
    try {
      if (receiptFile == null) return;

      final params = SaveFileDialogParams(
        data: await receiptFile!.readAsBytes(),
        fileName: 'receipt_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );

      final path = await FlutterFileDialog.saveFile(
        params: params,
      );

      if (path != null) {
        _showDownloadSuccessDialog(context, path);
      }
    } catch (e) {
      debugPrint('Error saving PDF: $e');
      showCustomBottomPopup(context, "Failed to save receipt");
    }
  }

  void _showDownloadSuccessDialog(BuildContext context, String path) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                size: 40, color: AppColors.fbTooLite),
            const SizedBox(height: 16),
            const Text(
              'Receipt downloaded',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the success dialog
                _navigateBack(); // Close the receipt screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateBack();
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Receipt",
          onBack: _navigateAppBack,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        /// Receipt PDF/Image
                        Flexible(
                          fit: FlexFit.loose,
                          child: receiptFile != null
                              ? FutureBuilder<PdfPageImage>(
                                  future: firstPageFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      final pdfPageImage = snapshot.data!;

                                      return Center(
                                        child: InteractiveViewer(
                                          transformationController:
                                              _transformationController,
                                          panEnabled: true,
                                          scaleEnabled: true,
                                          minScale: 1.0,
                                          maxScale: 5.0,
                                          child: Image.memory(
                                            pdfPageImage.bytes,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          'Error loading PDF: ${snapshot.error}',
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }

                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),

                        const Divider(
                          height: 1,
                          thickness: 1,
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: buildActionButton(
                                  label: 'Download',
                                  onPressed:
                                      receiptFile != null ? savePdf : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: buildActionButton(
                                  label: 'Print',
                                  onPressed: receiptFile != null
                                      ? _printReceipt
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _navigateBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.btnBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Back to Home",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
