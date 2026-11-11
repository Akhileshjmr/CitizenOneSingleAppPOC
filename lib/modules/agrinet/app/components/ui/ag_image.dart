import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AgImage extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;
  final Widget? errorWidget;
  final Widget? placeholder;
  final bool isCircular;

  const AgImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.width = 50,
    this.height = 50,
    this.borderRadius = 0,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.placeholder,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    final double finalRadius = isCircular ? width / 2 : borderRadius;

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(finalRadius),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    // Asset Image
    if (assetPath != null && assetPath!.isNotEmpty) {
      return Image.asset(
        assetPath!,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ??
              const Icon(Icons.person, size: 50, color: Colors.grey);
        },
      );
    }

    // Network Image
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      fit: fit,
      placeholder:
          (c, u) =>
              placeholder ??
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorWidget:
          (c, u, e) =>
              errorWidget ??
              const Icon(Icons.person, size: 50, color: Colors.grey),
    );
  }
}
