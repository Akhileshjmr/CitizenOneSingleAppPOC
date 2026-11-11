import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_theme_extensions.dart';

enum AppAvatarSize { sm, md, lg, xl }

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  /// Headers to send with [imageUrl] (e.g. `X-Session-Token` from
  /// `sessionImageHeaders()`), for callers whose avatar URL requires
  /// the same session auth as other API calls.
  final Map<String, String>? headers;

  AppAvatar({
    super.key,
    this.imageUrl,
    Object? size,
    AppAvatarSize? avatarSize,
    this.backgroundColor,
    this.foregroundColor,
    this.headers,
  }) : size = size is AppAvatarSize
            ? _sizeFor(size)
            : size is num
                ? size.toDouble()
                : _sizeFor(avatarSize ?? AppAvatarSize.md);

  static double _sizeFor(AppAvatarSize size) => switch (size) {
        AppAvatarSize.sm => 32,
        AppAvatarSize.md => 40,
        AppAvatarSize.lg => 56,
        AppAvatarSize.xl => 72,
      };

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final bg = backgroundColor ?? tokens.primary;
    final fg = foregroundColor ?? Colors.white;

    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: bg,
        backgroundImage:
            hasImage ? NetworkImage(imageUrl!, headers: headers) : null,
        child: hasImage
            ? null
            : Icon(
                Icons.person,
                size: size * 0.55,
                color: fg,
              ),
      ),
    );
  }
}
