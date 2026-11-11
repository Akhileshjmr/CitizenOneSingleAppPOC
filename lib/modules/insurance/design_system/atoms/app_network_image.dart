// =============================================================================
// AppNetworkImage  —  ATOM
// -----------------------------------------------------------------------------
// Image.network wrapper with a single, consistent loading spinner (AppLoader)
// and error fallback, so screens showing remote logos (vendor, insurer,
// vehicle style thumbnails, ...) don't each reimplement the same
// frameBuilder/errorBuilder pair. A null/empty url skips the network request
// entirely and goes straight to the fallback.
//
// Visibility is driven by `frameBuilder`'s `frame`, not `loadingBuilder`'s
// `loadingProgress`: the latter stays null for the whole fetch whenever the
// server doesn't emit incremental ImageChunkEvents (e.g. no Content-Length
// header), which Image.network treats as "already loaded" — so the spinner
// never appears and a blank box shows instead. `frame != null` only becomes
// true once a frame has actually been decoded, so it's unambiguous.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_loader.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.errorWidget,
    this.loaderSize = 20,
    this.loaderStrokeWidth = 2,
    this.headers,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final Map<String, String>? headers;

  /// Shown when the url is empty or the image fails to load. Defaults to a
  /// muted placeholder icon.
  final Widget? errorWidget;
  final double loaderSize;
  final double loaderStrokeWidth;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _box(_fallback());
    }

    return Image.network(
      url!,
      width: width,
      height: height,
      headers: headers,
      fit: fit,
      alignment: alignment,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return _box(
          AppLoader(size: loaderSize, strokeWidth: loaderStrokeWidth),
        );
      },
      errorBuilder: (context, error, stackTrace) => _box(_fallback()),
    );
  }

  Widget _box(Widget child) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(child: child),
    );
  }

  Widget _fallback() {
    return errorWidget ??
        Icon(
          Icons.image_not_supported_outlined,
          size: _iconSize,
          color: AppColors.textMuted,
        );
  }

  double get _iconSize {
    final base = width ?? height ?? 24.0;
    if (base < 16) return 16;
    if (base > 28) return 28;
    return base;
  }
}
