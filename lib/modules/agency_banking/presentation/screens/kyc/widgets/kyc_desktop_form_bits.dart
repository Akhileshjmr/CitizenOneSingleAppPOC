import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../theme/colors/Appcolors.dart';
import 'button/kyc_custom_button.dart';

/// Small uppercase section label + divider used at the top of every desktop
/// form card (e.g. "PERSONAL INFORMATION"), matching the reference designs.
class KycSectionLabel extends StatelessWidget {
  final String text;

  const KycSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: AppColors.kycSectionAccent,
          ),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: AppColors.borderLight),
        const SizedBox(height: 20),
      ],
    );
  }
}

/// Back (outlined) / Continue (filled) button row shared by every desktop
/// KYC form card. Mirrors the mobile `bottomButtons`/`bottomButton` methods
/// already present on each screen — same callbacks, just laid out inline at
/// the bottom of the card instead of a fixed `bottomNavigationBar`.
class KycDesktopButtonRow extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onContinue;
  final String backLabel;
  final String continueLabel;
  final bool isLoading;

  const KycDesktopButtonRow({
    super.key,
    required this.onBack,
    required this.onContinue,
    this.backLabel = "Back",
    this.continueLabel = "Continue",
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            title: backLabel,
            onTap: onBack,
            backgroundColor: AppColors.white,
            isOutlined: true,
            outlineColor: AppColors.k613AF5,
            borderRadius: 10,
            textStyle: const TextStyle(
              color: AppColors.k613AF5,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            height: 48,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppButton(
            title: continueLabel,
            onTap: onContinue,
            backgroundColor: AppColors.k613AF5,
            borderRadius: 10,
            height: 48,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}

/// White rounded card shell every desktop KYC form's content sits in —
/// matches the reference designs' card chrome (shadow, radius, padding).
class KycDesktopCard extends StatelessWidget {
  final Widget child;

  const KycDesktopCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Bordered toggle card for single-choice selections on desktop (e.g.
/// "Salaried Employee" / "Self Employed") — replaces the plain
/// `RadioListTile` row used on mobile/tablet, matching the reference
/// designs' selector-card look.
class KycSelectorCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const KycSelectorCard({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.k613AF5.withValues(alpha: 0.06)
              : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.k613AF5 : AppColors.kycBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.k613AF5 : AppColors.kycBorder,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.k613AF5 : AppColors.kycFieldLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashed-border upload box used by the desktop Document Upload screen —
/// empty state shows an upload icon + hint text, uploaded state shows a
/// green-tinted card with the file name/size and a remove control, matching
/// the reference designs.
class KycDesktopUploadTile extends StatelessWidget {
  final String title;
  final bool isRequired;
  final bool isUploaded;
  final String? fileName;
  final String? fileSizeLabel;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const KycDesktopUploadTile({
    super.key,
    required this.title,
    required this.isUploaded,
    required this.onTap,
    this.isRequired = false,
    this.fileName,
    this.fileSizeLabel,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: const TextStyle(
              color: AppColors.kycFieldLabel,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: '*',
                  style: TextStyle(color: AppColors.kycErrorRed),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: isUploaded ? _uploadedBox() : _emptyBox(),
        ),
      ],
    );
  }

  Widget _emptyBox() {
    return const _DashedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Icon(Icons.file_upload_outlined,
                color: AppColors.kycSubtitleGray, size: 22),
            SizedBox(height: 8),
            Text(
              'Click to upload',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.kycFieldLabel,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'PNG, JPG, PDF up to 5MB',
              style: TextStyle(fontSize: 11, color: AppColors.kycSubtitleGray),
            ),
          ],
        ),
      ),
    );
  }

  Widget _uploadedBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.kycSuccessBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kycSuccessBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file_outlined,
              color: AppColors.kycSuccessTextDark, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fileName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kycSuccessTextDark,
                  ),
                ),
                if (fileSizeLabel != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    fileSizeLabel!,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.kycSubtitleGray),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.check_circle,
              color: AppColors.kycSuccessGreen, size: 18),
          if (onRemove != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(Icons.close,
                  color: AppColors.kycSubtitleGray, size: 18),
            ),
          ],
        ],
      ),
    );
  }
}

/// Dashed-border signature pad trigger used by the desktop Document Upload
/// screen — same visual shell as [KycDesktopUploadTile], but with a
/// pencil icon + "Draw signature here" placeholder, and shows the captured
/// signature image once set. Opens the existing `SignaturePadDialog` on tap
/// (wired by the caller) — no signing logic lives here.
class KycDesktopSignatureTile extends StatelessWidget {
  final String title;
  final bool isRequired;
  final Uint8List? signatureBytes;
  final VoidCallback onTap;

  const KycDesktopSignatureTile({
    super.key,
    required this.title,
    required this.onTap,
    this.isRequired = false,
    this.signatureBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: const TextStyle(
              color: AppColors.kycFieldLabel,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: '*',
                  style: TextStyle(color: AppColors.kycErrorRed),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: _DashedBox(
            child: signatureBytes != null
                ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.memory(signatureBytes!,
                        height: 70, fit: BoxFit.contain),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Column(
                      children: [
                        const Icon(Icons.edit_outlined,
                            color: AppColors.kycSubtitleGray, size: 22),
                        const SizedBox(height: 8),
                        const Text(
                          'Draw signature here',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kycFieldLabel,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                            height: 1, width: 120, color: AppColors.kycBorder),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

/// Compact uploaded-document row used by the desktop Review & Submit
/// screen's "UPLOADED DOCUMENTS" section — file icon + label, a green
/// "Uploaded" pill, and a "Replace"/"Upload" text link, matching the
/// reference design (as opposed to the full upload tile used on the
/// Document Upload step itself).
class KycUploadedDocRow extends StatelessWidget {
  final String label;
  final bool isUploaded;
  final VoidCallback onReplace;

  const KycUploadedDocRow({
    super.key,
    required this.label,
    required this.isUploaded,
    required this.onReplace,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.description_outlined,
              size: 18, color: AppColors.kycSubtitleGray),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.kycFieldLabel,
              ),
            ),
          ),
          if (isUploaded) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.kycSuccessBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.kycSuccessBorder),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle,
                      size: 14, color: AppColors.kycSuccessGreen),
                  SizedBox(width: 4),
                  Text(
                    'Uploaded',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kycSuccessTextDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
          GestureDetector(
            onTap: onReplace,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh, size: 14, color: AppColors.k613AF5),
                const SizedBox(width: 4),
                Text(
                  isUploaded ? 'Replace' : 'Upload',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.k613AF5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared dashed-border rounded box shell for [KycDesktopUploadTile] and
/// [KycDesktopSignatureTile] — Flutter has no built-in dashed border, so
/// this paints one directly rather than pulling in a package dependency.
class _DashedBox extends StatelessWidget {
  final Widget child;

  const _DashedBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _DashedBorderPainter(color: AppColors.kycBorder, radius: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          color: AppColors.kF8FAFC,
          child: child,
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final dashPath = Path();
    const dashWidth = 5.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        dashPath.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance = next + dashSpace;
      }
    }
    canvas.drawPath(
      dashPath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
