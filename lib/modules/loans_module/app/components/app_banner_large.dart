import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/image_hendle.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';

import '../data/model/common/banners.dart';

/// Home main banner

class AppBannerLarge extends StatefulWidget {
  ///AppBannerLarge
  const AppBannerLarge({
    required this.bannerImage,
    required this.onTap,
    required this.arrBanner,
    Key? key,
  }) : super(key: key);

  /// Banner image path
  final String bannerImage;

  /// Callback when the button is pressed
  final VoidCallback onTap;

  final List<Banners> arrBanner;

  @override
  State<AppBannerLarge> createState() => _AppBannerLargeState();
}

class _AppBannerLargeState extends State<AppBannerLarge> {
  int _current = 0;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          viewportFraction: 1,
          aspectRatio: 2,
          enlargeCenterPage: false,
          enableInfiniteScroll: false,
          clipBehavior: Clip.none,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        ),
        items:
            widget.arrBanner
                .map(
                  (item) => ImageHandle(
                    url: item.imageUrl?.addBaseUrl ?? '',
                    radius: 1.r,
                    size: Size(1.sw, 200.h),
                  ),
                )
                .toList(),
      ),
    ],
  );
}
