import 'package:flutter/cupertino.dart';

import '../../theme/colors/Appcolors.dart';

class Backgroundcomponent extends StatelessWidget {
  final Widget child;
  const Backgroundcomponent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AppMobileColors.cBackground,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: AppMobileColors.cBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppMobileColors.cShadow,
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 4), // x, y
            ),
          ],
        ),
      child: child,
    );
  }
}