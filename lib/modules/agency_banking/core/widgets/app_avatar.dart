import 'package:flutter/material.dart';

import '../../theme/colors/Appcolors.dart';

enum AppAvatarSize { sm, md, lg, xl }

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  AppAvatar({
    super.key,
    this.imageUrl,
    Object? size,
    AppAvatarSize? avatarSize,
    this.backgroundColor,
    this.foregroundColor,
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
    const bg = AppColors.primaryBlue;
    final fg = foregroundColor ?? Colors.white;

    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: bg,
        backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
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
