import 'package:flutter/material.dart';

import '../../../../../core/widgets/form/app_text.dart';
import '../../../../../theme/colors/Appcolors.dart';

/// A rounded promotional/info card: an image up top, a caption below.
/// Generic on purpose — the reference screenshot uses it for "Manage
/// all your loan accounts securely...", but the same shape works for
/// any cross-sell/informational banner elsewhere in the app (cards
/// offers, savings tips, feature announcements, ...).
class AppPromoCard extends StatelessWidget {
  final String caption;
  final String? imageUrl;
  final double imageHeight;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AppPromoCard({
    super.key,
    required this.caption,
    this.imageUrl,
    this.imageHeight = 140,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFEDEBFB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: double.infinity,
              height: imageHeight,
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const _ImagePlaceholder();
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const _ImagePlaceholder(),
                    )
                  : const _ImagePlaceholder(),
            ),
          ),
          const SizedBox(height: 14),
          AppText(
            caption,
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: content,
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blueGrey.shade700, Colors.blueGrey.shade900],
        ),
      ),
      child: const Center(
        child: Icon(Icons.apartment, color: Colors.white54, size: 36),
      ),
    );
  }
}
