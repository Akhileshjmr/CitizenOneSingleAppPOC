import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/app_loader.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/api_service/init_api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  const PdfViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localPath;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final path = await downloadPdfForView(widget.pdfUrl);
    setState(() {
      localPath = path;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(title: 'Offer Letter'),
    body:
        loading
            ? const Center(child: AppLoader())
            : localPath == null
            ? const Center(child: Text('Unable to load document'))
            : SfPdfViewer.file(File(localPath!)),
  );

  Future<String?> downloadPdfForView(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/offer_letter.pdf';

      await APIService.download(
        url: url,
        savePath: filePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      return filePath;
    } catch (e) {
      debugPrint('❌ PDF download failed: $e');
      return null;
    }
  }
}
