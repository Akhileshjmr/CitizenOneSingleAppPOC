// ignore_for_file: prefer_expression_function_bodies

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Cached image handler with error & placeholder support
class ImageHandle extends StatelessWidget {
  const ImageHandle({
    required this.url,
    this.iconSize,
    this.bgColor,
    this.errorBgColor,
    this.size,
    this.padding,
    this.radius = 0,
    this.borderRadius,
    this.errorWidget,
    this.border,
    this.errorImage,
    this.boxShadow,
    this.fit,
    Key? key,
  }) : super(key: key);

  final String url;
  final double? iconSize;
  final Color? bgColor;
  final Color? errorBgColor;
  final Size? size;
  final double radius;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Widget? errorImage;
  final List<BoxShadow>? boxShadow;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    final height = size?.height ?? 48.r;
    final width = size?.width ?? 48.r;

    final isRectangle = borderRadius != null || radius > 0;

    /// If URL is empty → return error container directly
    if (url.isEmpty) {
      return _errorContainer(height, width, isRectangle);
    }

    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,

      /// cache optimization
      memCacheHeight: 200,
      memCacheWidth: 200,

      /// smooth loading
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 100),

      imageBuilder: (context, imageProvider) {
        return Container(
          padding: padding ?? REdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: isRectangle ? BoxShape.rectangle : BoxShape.circle,
            color: bgColor,
            borderRadius:
                isRectangle
                    ? borderRadius ?? BorderRadius.circular(radius)
                    : null,
            border: border,
            boxShadow: boxShadow,
            image: DecorationImage(
              image: imageProvider,
              fit: fit ?? BoxFit.contain,
            ),
          ),
        );
      },

      placeholder: (context, url) {
        return SizedBox(
          height: height,
          width: width,
          child: Center(
            child: SizedBox(
              width: 25.r,
              height: 25.r,
              child: CircularProgressIndicator(strokeWidth: 1.w),
            ),
          ),
        );
      },

      errorWidget:
          errorWidget ??
          (context, url, error) => _errorContainer(height, width, isRectangle),
    );
  }

  Widget _errorContainer(double height, double width, bool isRectangle) {
    return Container(
      height: height,
      width: width,
      padding: padding ?? REdgeInsets.all(5),
      decoration: BoxDecoration(
        color: errorBgColor ?? Colors.grey.shade300,
        shape: isRectangle ? BoxShape.rectangle : BoxShape.circle,
        borderRadius:
            isRectangle ? borderRadius ?? BorderRadius.circular(radius) : null,
        border: border,
      ),
      child: errorImage ?? const Icon(Icons.image),
    );
  }
}
