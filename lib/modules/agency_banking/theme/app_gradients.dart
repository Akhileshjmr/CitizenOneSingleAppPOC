import 'package:flutter/cupertino.dart';
import 'colors/Appcolors.dart';

class AppBackgrounds {
  static Gradient get widgetsBackground => LinearGradient(
    colors: [
      AppColors.widgetsBackgroundGradientOne,
      AppColors.widgetsBackgroundGradientTwo,
      AppColors.widgetsBackgroundGradientThree,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Gradient cardBackground = LinearGradient(
    colors: [
      AppColors.cardBackgroundGradientOne,
      AppColors.cardBackgroundGradientTwo,
      AppColors.cardBackgroundGradientThree,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient topBottomToolbarBackground = LinearGradient(
    colors: [
      AppColors.toolbarGradientTop,
      AppColors.toolbarGradientBottom,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static BoxDecoration screenBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.bgColorScreen,
          AppColors.bgColorScreen,
          AppColors.bgColorScreen,
        ],
      ),
    );
  }
}
