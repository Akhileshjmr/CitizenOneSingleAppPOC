import 'package:citizenone_app/modules/agency_banking/data/models/BannerContent.dart';
import 'package:flutter/material.dart';

class ResponsiveLeftBanner extends StatelessWidget {
  final List<BannerContent>? banners;

  const ResponsiveLeftBanner({Key? key, this.banners}) : super(key: key);

  bool isNetworkImage(String path) => path.startsWith('http');

  Widget _buildImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: isNetworkImage(path)
          ? Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const SizedBox(),
      )
          : Image.asset(
        path,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildBannerCard(BannerContent content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 180, width: double.infinity, child: _buildImage(content.imagePath)),
          const SizedBox(height: 12),
          if (content.title != null)
            Text(
              content.title!.toUpperCase(),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          if (content.headline != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                content.headline!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          if (content.subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                content.subtitle!,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
          if (content.ctaText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton(
                onPressed: content.onCtaPressed,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: Text(content.ctaText!.toUpperCase()),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile || banners == null || banners!.isEmpty) {
      return const SizedBox.shrink(); // hide on mobile or no content
    }

    return Container(
      width: screenWidth * 0.4,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: banners!.map(_buildBannerCard).toList(),
        ),
      ),
    );
  }
}