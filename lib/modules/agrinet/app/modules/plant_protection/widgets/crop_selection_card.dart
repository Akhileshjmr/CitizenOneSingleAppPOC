import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_image.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:flutter/material.dart';

import '../../../data/model/plant_protection/crop_model.dart';

class CropSelectionCard extends StatelessWidget {
  final CropModel crop;
  final int index;
  final VoidCallback? onTap;

  const CropSelectionCard({
    super.key,
    required this.crop,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Compute color + letter inside card
    final String bigLetter =
        crop.name.isNotEmpty ? crop.name[0].toUpperCase() : "?";

    final MaterialColor baseColor =
        Colors.primaries[index % Colors.primaries.length];

    final Color bodyColor = baseColor.shade300;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Image / Body section (Full size)
            Positioned.fill(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: bodyColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                width: double.infinity,
                child: AgImage(
                  imageUrl: crop.documents.addBaseUrl,
                  errorWidget: Container(
                    width: double.infinity,
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
            ),

            // Top bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Text(
                crop.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
