import 'package:citizenone_app/modules/agency_banking/data/api/ApiClient.dart';
import 'package:citizenone_app/modules/agency_banking/data/api/end_points/ApiEndPoints.dart';
import 'package:citizenone_app/modules/agency_banking/utils/SecureStorageHelper.dart';
import 'package:flutter/material.dart';

import '../../core/widgets/form/app_text.dart';
import '../../data/api/end_points/UrlStorage.dart';

/// Which base URL option is currently selected in the dialog.
enum _UrlOption { public, dev, others }

/// Global reusable "Update Base URL" dialog.
///
/// Usage from anywhere in the app:
/// ```dart
/// UpdateBaseUrlDialog.show(context);
/// ```
///
/// Optionally listen for the result:
/// ```dart
/// final newUrl = await UpdateBaseUrlDialog.show(context);
/// if (newUrl != null) {
///   // base URL was changed, e.g. restart session / re-init API client
/// }
/// ```
class UpdateBaseUrlDialog {
  /// Shows the dialog. Returns the newly selected URL if the user tapped
  /// "Update", or null if cancelled / dismissed.
  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _UpdateBaseUrlDialogWidget(),
    );
  }
}

class _UpdateBaseUrlDialogWidget extends StatefulWidget {
  const _UpdateBaseUrlDialogWidget();

  @override
  State<_UpdateBaseUrlDialogWidget> createState() =>
      _UpdateBaseUrlDialogWidgetState();
}

class _UpdateBaseUrlDialogWidgetState
    extends State<_UpdateBaseUrlDialogWidget> {
  late final TextEditingController _urlController;
  _UrlOption _selectedOption = _UrlOption.public;
  bool _isLoading = true;
  bool _isSaving = false;

  // Public / Dev base URLs are maintained centrally in ApiEndpoints.dart
  // (see ApiEndpoints.publicUrl / ApiEndpoints.devUrl) — not duplicated here.

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    _loadCurrentUrl();
  }

  Future<void> _loadCurrentUrl() async {
    // Fetch strictly from secure storage — no fallback to ApiEndpoints
    // for an *existing* value. But on a fresh install (nothing stored
    // yet), default to Public URL so it's pre-selected and checked.
    final storedUrl = await SecureStorageHelper.getBaseUrl();
    final currentUrl = (storedUrl == null || storedUrl.isEmpty)
        ? ApiEndpoints.publicUrl
        : storedUrl;
    _urlController.text = currentUrl;
    _selectedOption = _resolveOptionForUrl(currentUrl);
    if (mounted) setState(() => _isLoading = false);
  }

  /// Figures out which radio option a given URL corresponds to.
  _UrlOption _resolveOptionForUrl(String url) {
    if (url == ApiEndpoints.publicUrl) return _UrlOption.public;
    if (url == ApiEndpoints.devUrl) return _UrlOption.dev;
    return _UrlOption.others;
  }

  void _onOptionSelected(_UrlOption option) {
    setState(() {
      _selectedOption = option;
      switch (option) {
        case _UrlOption.public:
          _urlController.text = ApiEndpoints.publicUrl;
          break;
        case _UrlOption.dev:
          _urlController.text = ApiEndpoints.devUrl;
          break;
        case _UrlOption.others:
          // Leave text as-is so the user can type/paste their own value.
          break;
      }
    });
  }

  /// If the user manually types or pastes a URL, auto-switch the radio
  /// selection to reflect what they entered.
  void _onTextChanged(String value) {
    final matchedOption = _resolveOptionForUrl(value.trim());
    if (matchedOption != _selectedOption) {
      setState(() => _selectedOption = matchedOption);
    }
  }

  Future<void> _handleUpdate() async {
    final newUrl = _urlController.text.trim();

    if (newUrl.isEmpty) {
      _showError('Please enter a valid URL');
      return;
    }
    final uri = Uri.tryParse(newUrl);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      _showError('Please enter a valid URL');
      return;
    }

    setState(() => _isSaving = true);

    await UrlStorage.setBaseUrl(newUrl);
    ApiClient().updateBaseUrl(newUrl);

    if (mounted) Navigator.of(context).pop(newUrl);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive width: comfortable on phones, capped on tablets/web.
    final dialogWidth = screenWidth < 480 ? screenWidth * 0.9 : 400.0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: _isLoading
              ? const SizedBox(
                  height: 140,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Update Base URL',
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w600,
                      underline: true,
                    ),
                    const SizedBox(height: 16),

                    // URL text field
                    TextField(
                      controller: _urlController,
                      onChanged: _onTextChanged,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: const UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Option rows — bank-list style, divider before every row
                    // and one final divider after the last row
                    Divider(height: 1, color: Colors.grey.shade300),
                    _buildOptionRow(
                      label: 'Public URL',
                      option: _UrlOption.public,
                      primaryColor: primaryColor,
                    ),
                    Divider(height: 1, color: Colors.grey.shade300),
                    _buildOptionRow(
                      label: 'Dev URL',
                      option: _UrlOption.dev,
                      primaryColor: primaryColor,
                    ),
                    Divider(height: 1, color: Colors.grey.shade300),
                    _buildOptionRow(
                      label: 'Others',
                      option: _UrlOption.others,
                      primaryColor: primaryColor,
                    ),
                    Divider(height: 1, color: Colors.grey.shade300),

                    const SizedBox(height: 8),

                    // Action buttons — uppercase text buttons, right aligned
                    // with clear spacing between them, matching reference
                    Row(
                      children: [
                        TextButton(
                          onPressed: _isSaving
                              ? null
                              : () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              height: 20,
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _isSaving ? null : _handleUpdate,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: _isSaving
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      primaryColor,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'UPDATE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildOptionRow({
    required String label,
    required _UrlOption option,
    required Color primaryColor,
  }) {
    final isSelected = _selectedOption == option;

    return InkWell(
      onTap: () => _onOptionSelected(option),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected ? primaryColor : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
