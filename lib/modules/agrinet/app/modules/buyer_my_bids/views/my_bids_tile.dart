import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_image.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:flutter/material.dart';

import '../../../data/model/view_bids/one_advertise_history.dart';
import '../../../theme/ag_text_styles.dart';
import '../../../utils/ag_colors.dart';

class MyBidsTile extends StatelessWidget {
  final BidPlan item;
  final VoidCallback? onTap;

  const MyBidsTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ), // reduced height
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- AD ID ----------------
            Align(
              alignment: Alignment.center,
              child: Text(item.adId ?? "", style: kw600Green16),
            ),

            const SizedBox(height: 6),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---------------- PLACEHOLDER IMAGE ----------------
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child:
                      (item.documents ?? []).isEmpty
                          ? Icon(
                            Icons.image_not_supported,
                            color: Colors.grey.shade600,
                            size: 22,
                          )
                          : AgImage(
                            imageUrl:
                                (item.documents ?? [])
                                    .first
                                    .fileName
                                    ?.addBaseUrl,
                            isCircular: true,
                          ),
                ),

                const SizedBox(width: 10),

                /// ---------------- MIDDLE DETAILS ----------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Crop Name
                      Text(item.cropName ?? "-", style: kw600Primary14),

                      const SizedBox(height: 4),

                      /// Min Price + Quantity
                      Row(
                        children: [
                          Text("Min price : ", style: kw400Primary12),
                          Text(item.minPrice ?? "-", style: kw500Primary14),

                          const SizedBox(width: 12),

                          Text("Quantity : ", style: kw400Primary12),
                          Text(
                            item.totalQuantity ?? "-",
                            style: kw500Primary14.copyWith(
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      /// Total Price
                      Row(
                        children: [
                          Text("Total Price : ", style: kw400Primary12),
                          Text(item.totalPrice ?? "-", style: kw600Primary14),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// ---------------- STATUS ----------------
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                item.status?.friendlyType ?? "",
                style: kw600Primary14.copyWith(
                  color:
                      (item.status?.friendlyType ?? "").toLowerCase().contains(
                            "accepted",
                          )
                          ? AgColors.kLightGreenText
                          : Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
