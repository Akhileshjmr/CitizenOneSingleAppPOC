import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:flutter/material.dart';

import '../../../app_environment.dart';

class PerformanceStatItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String value;

  const PerformanceStatItem({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // WHITE CARD
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 40,
                right: 10,
                top: 12,
                bottom: 12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TITLE (Single line)
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // VALUE
                  Text(
                    value,
                    style: kw600Primary18,
                    // const TextStyle(
                    //   fontSize: 20,
                    //   fontWeight: FontWeight.bold,
                    //   color: Colors.black,
                    // ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // IMAGE OVERLAPPING
        Positioned(
          top: -5,
          left: 4,
          child: Image.asset(
            imagePath,
            width: 38,
            height: 38,
            fit: BoxFit.contain,
            package: AppEnvironment.packageName,
          ),
        ),
      ],
    );
  }
}
