import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/ag_png_image.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D9363),
      body: Center(child: PngImage.agriLogo),
    );
  }
}
