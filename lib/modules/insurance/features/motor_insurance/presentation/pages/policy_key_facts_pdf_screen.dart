import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PolicyKeyFactsPdfArgs {
  final String? url;
  final Uint8List? bytes;

  const PolicyKeyFactsPdfArgs({this.url, this.bytes});
}

class PolicyKeyFactsPdfScreen extends StatefulWidget {
  final String? pdfUrl;
  final Uint8List? pdfBytes;

  const PolicyKeyFactsPdfScreen({
    super.key,
    this.pdfUrl,
    this.pdfBytes,
  });

  @override
  State<PolicyKeyFactsPdfScreen> createState() =>
      _PolicyKeyFactsPdfScreenState();
}

class _PolicyKeyFactsPdfScreenState extends State<PolicyKeyFactsPdfScreen> {
  late PdfViewerController _pdfViewerController;

  bool _isLoading = true;
  bool _hasError = false;

  bool get _hasPdfBytes =>
      widget.pdfBytes != null && widget.pdfBytes!.isNotEmpty;
  bool get _hasPdfUrl => widget.pdfUrl?.trim().isNotEmpty ?? false;
  bool get _hasDocument => _hasPdfBytes || _hasPdfUrl;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();

    // If there is no document, don't show the loading state.
    if (!_hasDocument) {
      _isLoading = false;
      _hasError = true;
    }
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppStatusBar(
        centerTitle: false,
        title: 'Policy Key Facts Statements',
        showBack: true,
      ),
      body: Stack(
        children: [
          if (_hasPdfBytes)
            SfPdfViewer.memory(
              widget.pdfBytes!,
              controller: _pdfViewerController,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                if (!mounted) return;

                setState(() {
                  _isLoading = false;
                  _hasError = false;
                });
              },
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                if (!mounted) return;

                setState(() {
                  _isLoading = false;
                  _hasError = true;
                });
              },
            )
          else if (_hasPdfUrl)
            SfPdfViewer.network(
              widget.pdfUrl!,
              controller: _pdfViewerController,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                if (!mounted) return;

                setState(() {
                  _isLoading = false;
                  _hasError = false;
                });
              },
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                if (!mounted) return;

                setState(() {
                  _isLoading = false;
                  _hasError = true;
                });
              },
            ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          if (_hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _hasDocument
                          ? 'Failed to load PDF document'
                          : 'PDF document is not available',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (_hasDocument) ...[
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _hasError = false;
                          });
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          bottom: 16,
          left: 16,
          right: 16,
          top: 10,
        ),
        child: AppButton(
          height: 44,
          label: 'Back',
          onPressed: () {
            context.pop();
          },
          variant: AppButtonVariant.primary,
          size: AppButtonSize.lg,
          backgroundColor: AppColors.primary,
        ),
      ),
    );
  }
}
