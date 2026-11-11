import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AgCarouselSlider extends StatelessWidget {
  final List<String> imageList;
  final double height;
  final bool autoPlay;
  final Function(int index)? onPageChanged;

  const AgCarouselSlider({
    super.key,
    required this.imageList,
    this.height = 180,
    this.autoPlay = true,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (imageList.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: height,
          width: double.infinity,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported_outlined, size: 50),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: height,
        autoPlay: autoPlay,
        viewportFraction: 1,
        enlargeCenterPage: false,
        onPageChanged: (index, _) {
          onPageChanged?.call(index);
        },
      ),
      items:
          imageList.map((item) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return Container(
                    height: height,
                    width: double.infinity,
                    alignment: Alignment.center,
                    color: Colors.grey.shade200,
                    child: const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: height,
                    width: double.infinity,
                    alignment: Alignment.center,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image_outlined, size: 50),
                  );
                },
              ),
            );
          }).toList(),
    );
  }
}
