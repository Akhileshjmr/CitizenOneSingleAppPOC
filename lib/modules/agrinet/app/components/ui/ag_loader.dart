import 'package:flutter/material.dart';

import '../../app_environment.dart';
import '../../utils/ag_assets.dart';

class AgLoader extends StatelessWidget {
  final double size;

  const AgLoader({super.key, this.size = 98});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        AgAssets.icLeafLoader,
        width: size,
        height: size,
        fit: BoxFit.contain,
        package: AppEnvironment.packageName,
      ),
    );
  }
}
