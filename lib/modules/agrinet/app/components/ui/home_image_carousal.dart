import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_image.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_environment.dart';
import '../../models/HomeResp/HomeImageResp.dart';
import '../../utils/ag_png_image.dart';

class HomeHeaderCarousel extends StatefulWidget {
  final List<Slideimages> images;
  final RxInt currentIndex;

  final CarouselSliderController? carouselController;
  final Function(int)? onPageChanged;

  final VoidCallback? onMenuTap;
  final VoidCallback? onLogoutTap;
  final double? carousalHeight;

  const HomeHeaderCarousel({
    super.key,
    required this.images,
    required this.currentIndex,
    this.carouselController,
    this.onPageChanged,
    this.onMenuTap,
    this.onLogoutTap,
    this.carousalHeight = 220.0,
  });

  @override
  State<HomeHeaderCarousel> createState() => _HomeHeaderCarouselState();
}

class _HomeHeaderCarouselState extends State<HomeHeaderCarousel> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentIndex.value;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.carousalHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // --- Carousel (Base Layer) ---
          if (widget.images.isEmpty)
            const Center(child: Icon(Icons.error, size: 150))
          else
            CarouselSlider(
              carouselController: widget.carouselController,
              options: CarouselOptions(
                height: widget.carousalHeight, // ✅ FIXED (removed fixed 220)
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 1.0,
                enableInfiniteScroll: widget.images.length > 1,
                pauseAutoPlayOnTouch: true,
                pauseAutoPlayOnManualNavigate: true,
                enlargeCenterPage: false,
                scrollDirection: Axis.horizontal,
                disableCenter: true,
                padEnds: false,
                initialPage: 0,
                onPageChanged: (index, reason) {
                  final actualIndex = index % widget.images.length;

                  setState(() {
                    _currentPage = actualIndex;
                  });

                  widget.currentIndex.value = actualIndex;

                  if (widget.onPageChanged != null) {
                    widget.onPageChanged!(actualIndex);
                  }
                },
              ),
              items:
                  widget.images.map((item) {
                    String imageUrl = item.fileName?.addBaseUrl ?? "";
                    imageUrl = imageUrl
                        .replaceAll('//', '/')
                        .replaceFirst(':/', '://');

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.zero,
                          child: AgImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.fill,
                            errorWidget: PngImage.agriLogo,
                          ),
                        ),
                        IgnorePointer(
                          child: Container(
                            color: Colors.black.withOpacity(0.15),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),

          // --- Menu + Logout ---
          if (widget.onMenuTap != null || widget.onLogoutTap != null)
            Positioned(
              top: 5,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.onMenuTap != null)
                        GestureDetector(
                          onTap: widget.onMenuTap,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 44),
                      if (widget.onLogoutTap != null &&
                          !AppEnvironment.isEmbeddedInHostApp)
                        GestureDetector(
                          onTap: widget.onLogoutTap,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 44),
                    ],
                  ),
                ),
              ),
            ),

          // --- Indicators ---
          if (widget.images.isNotEmpty && widget.images.length > 1)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.images.length, (index) {
                    final active = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: active ? 12 : 8,
                      height: active ? 12 : 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active ? Colors.white : Colors.grey,
                      ),
                    );
                  }),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
