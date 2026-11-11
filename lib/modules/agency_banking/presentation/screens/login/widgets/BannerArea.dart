/*
import 'package:flutter/material.dart';

class BannerArea extends StatelessWidget {
  const BannerArea({
    super.key,
    required this.page,
    required this.current,
    required this.onChanged,
    required this.banners,
    required this.isMobile,
  });

  final PageController page;
  final int current;
  final ValueChanged<int> onChanged;
  final List<String> banners;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Images
        Positioned.fill(
          child: PageView.builder(
            controller: page,
            itemCount: banners.length,
            onPageChanged: onChanged,
            itemBuilder: (_, i) => Image.asset(
              banners[i],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),

        // Soft gradient
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.05),
                    Colors.black.withOpacity(0.10),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Caption
        Positioned(
          left: 0,
          right: 0,
          bottom: isMobile ? 28 : 40,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'Your digital banking starts here\nlog in to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF111827),
                  height: 1.35,
                ),
              ),
            ),
          ),
        ),

        // Dots
        Positioned(
          bottom: isMobile ? 10 : 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
                  (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == current ? 8 : 6,
                height: i == current ? 8 : 6,
                decoration: BoxDecoration(
                  color: i == current ? Colors.white : Colors.white70,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
*/

import 'package:flutter/material.dart';

class BannerArea extends StatelessWidget {

  const BannerArea({

    super.key,

    required this.page,

    required this.current,

    required this.onChanged,

    required this.banners,

    required this.isMobile,

  });

  final PageController page;

  final int current;

  final ValueChanged<int> onChanged;

  final List<String> banners;

  final bool isMobile;

  @override

  Widget build(BuildContext context) {

    return Stack(

      children: [

        // Images

        Positioned.fill(

          child: PageView.builder(

            controller: page,

            itemCount: banners.length,

            onPageChanged: onChanged,

            itemBuilder: (_, i) => Image.asset(

              banners[i],

              fit: BoxFit.cover,

              width: double.infinity,

              height: double.infinity,

            ),

          ),

        ),

        // Soft gradient

        Positioned.fill(

          child: IgnorePointer(

            child: DecoratedBox(

              decoration: BoxDecoration(

                gradient: LinearGradient(

                  begin: Alignment.topCenter,

                  end: Alignment.bottomCenter,

                  colors: [

                    Colors.transparent,

                    Colors.black.withOpacity(0.05),

                    Colors.black.withOpacity(0.10),

                  ],

                ),

              ),

            ),

          ),

        ),

        // Caption

        /* Positioned(

          left: 0,

          right: 0,

          bottom: isMobile ? 28 : 40,

          child: Center(

            child: Container(

              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius: BorderRadius.circular(14),

                boxShadow: const [

                  BoxShadow(

                    color: Color(0x1A000000),

                    blurRadius: 12,

                    offset: Offset(0, 4),

                  ),

                ],

              ),

              child: const Text(

                'Your digital banking starts here\nlog in to continue',

                textAlign: TextAlign.center,

                style: TextStyle(

                  fontSize: 16,

                  color: Color(0xFF111827),

                  height: 1.35,

                ),

              ),

            ),

          ),

        ),*/

        // Dots

        /*Positioned(

          bottom: isMobile ? 10 : 16,

          left: 0,

          right: 0,

          child: Row(

            mainAxisAlignment: MainAxisAlignment.center,

            children: List.generate(

              banners.length,

                  (i) => AnimatedContainer(

                duration: const Duration(milliseconds: 250),

                margin: const EdgeInsets.symmetric(horizontal: 4),

                width: i == current ? 8 : 6,

                height: i == current ? 8 : 6,

                decoration: BoxDecoration(

                  color: i == current ? Colors.white : Colors.white70,

                  shape: BoxShape.circle,

                ),

              ),

            ),

          ),

        ),*/

      ],

    );

  }
}


