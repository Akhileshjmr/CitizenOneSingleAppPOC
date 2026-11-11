import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/utils/html_utils/clean_html.dart';
import '../../../data/api/end_points/ApiEndPoints.dart';
import '../../../theme/colors/Appcolors.dart';


class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool _hasError = false;
  List<String> _paragraphs = []; // used only on web

  static const _viewportAndPaddingJS = '''
    var meta = document.querySelector('meta[name="viewport"]');
    if (!meta) {
      meta = document.createElement('meta');
      meta.name = "viewport";
      document.getElementsByTagName('head')[0].appendChild(meta);
    }
    meta.content = "width=device-width, initial-scale=1.0, maximum-scale=1.0";
    document.body.style.padding = "16px";
    document.body.style.margin = "0";
    document.body.style.boxSizing = "border-box";
  ''';

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _loadParagraphsForWeb();
    } else {
      _initWebView();
    }
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) async {
            await _controller!.runJavaScript(_viewportAndPaddingJS);
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(ApiEndpoints.privacyPolicyURL));
  }

  Future<void> _loadParagraphsForWeb() async {
    try {
      final response = await http
          .get(Uri.parse(ApiEndpoints.privacyPolicyURL))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final result = extractParagraphs(response.body);
        setState(() {
          _paragraphs = result;
          _isLoading = false;
          _hasError = result.isEmpty;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hasError) {
      return const Center(child: Text("Failed to load privacy policy."));
    }
    if (kIsWeb) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _paragraphs
              .map(
                (para) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                para,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
          )
              .toList(),
        ),
      );
    }
    return WebViewWidget(controller: _controller!);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 700;

    final outerPadding = isWide ? 24.0 : 8.0;
    final contentMaxWidth = isWide ? 800.0 : double.infinity;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7F1),
        automaticallyImplyLeading: false,
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentMaxWidth),
            child: Padding(
              padding: EdgeInsets.fromLTRB(outerPadding, 6, outerPadding, 12),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _buildBody(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.k613AF5, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.k613AF5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}