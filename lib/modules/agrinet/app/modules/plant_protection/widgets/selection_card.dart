import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:flutter/material.dart';

import '../../../components/ui/ag_image.dart';

class SelectionCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final int index;
  final String? image;

  const SelectionCard({
    super.key,
    required this.title,
    required this.index,
    this.onTap,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    // Auto-generate first letter
    final String bigLetter = title.isNotEmpty ? title[0].toUpperCase() : "?";

    // Auto-generate colors
    final MaterialColor base =
        Colors.primaries[index % Colors.primaries.length];

    final Color bodyColor = base.shade300;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        // ✅ Make card transparent
        color: Colors.transparent,
        elevation: 0,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

        clipBehavior: Clip.antiAlias,

        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: AgImage(
                imageUrl: image.addBaseUrl,
                fit: BoxFit.cover,

                errorWidget: Container(
                  color: bodyColor,
                  alignment: Alignment.center,
                  child: Text(
                    bigLetter,
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              color: Colors.black54,
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
