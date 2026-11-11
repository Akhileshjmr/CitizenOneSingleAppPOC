import 'package:flutter/material.dart';

class BannerContent {
  final String imagePath;
  final String? title;
  final String? headline;
  final String? subtitle;
  final String? ctaText;
  final VoidCallback? onCtaPressed;

  BannerContent({
    required this.imagePath,
    this.title,
    this.headline,
    this.subtitle,
    this.ctaText,
    this.onCtaPressed,
  });
}
