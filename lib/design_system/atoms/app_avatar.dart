import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  /// Headers to send with [imageUrl] (e.g. `X-Session-Token` from
  /// [sessionImageHeaders]), for callers whose avatar URL requires the
  /// same session auth as other API calls.
  final Map<String, String>? headers;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
    this.backgroundColor,
    this.foregroundColor,
    this.headers,
  });

  String get _initials {
    if (name == null || name!.trim().isEmpty) return '?';
    final parts = name!.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final bg = backgroundColor ?? tokens.primary;
    final fg = foregroundColor ?? Colors.white;

    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: bg,
        backgroundImage: imageUrl != null
            ? NetworkImage(imageUrl!, headers: headers)
            : null,
        child: imageUrl == null
            ? Text(
                _initials,
                style: TextStyle(
                  fontSize: size * 0.36,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              )
            : null,
      ),
    );
  }
}
