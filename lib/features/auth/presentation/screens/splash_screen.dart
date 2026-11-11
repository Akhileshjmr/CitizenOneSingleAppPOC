import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/tokens/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Scaffold(
      backgroundColor: tokens.background,
      body: Center(
        child: SizedBox(
          height: 86,
          width: 212,
          child: Image.asset(AppAssets.citizenOneLogo, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
