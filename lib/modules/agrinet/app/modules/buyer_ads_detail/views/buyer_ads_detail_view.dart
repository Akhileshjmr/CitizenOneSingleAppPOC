import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_image.dart';
import '../../../components/ui/ag_loader.dart';
import '../controllers/buyer_ads_detail_controller.dart';

class BuyerAdsDetailView extends GetView<BuyerAdsDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Advertise", showLogout: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AgLoader());
        }

        final data = controller.adsDetail.value;
        if (data == null) {
          return const Center(child: Text("No Data Found"));
        }

        return Column(
          children: [
            /// Header Yellow Banner
            Container(
              height: 180,
              width: double.infinity,
              color: const Color(0xfff7cb4d),
              child:
                  (data.documents.isNotEmpty == true &&
                          data.documents.first.fileName?.isNotEmpty == true)
                      ? AgImage(
                        imageUrl: data.documents.first.fileName!.addBaseUrl,
                      )
                      : Center(
                        child: Text(
                          data.cropName.isNotEmpty == true
                              ? data.cropName.first.cropName[0]
                              : "",
                          style: const TextStyle(
                            fontSize: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
            ),

            /// ===================== DATA BLOCK =====================
            Container(
              width: double.infinity,
              color: const Color(0xffe5e3e3),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              child: Column(
                children: [
                  /// ---------- ROW 1 ----------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _infoColLeft(
                          "Min. price",
                          (data.minPrice != null && data.minPrice!.isNotEmpty)
                              ? "${data.minPrice}"
                              : "-",
                        ),
                      ),
                      Expanded(
                        child: _infoColLeft(
                          "Quantity",
                          data.totalQuantity ?? "-",
                          isRed: true,
                        ),
                      ),
                      Expanded(
                        child: _infoColLeft(
                          "Ready by",
                          _formatDate(data.readyBy),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// ---------- ROW 2 ----------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _infoColLeft(
                          "Bidding Closes",
                          _formatDate(data.bidClose),
                        ),
                      ),
                      Expanded(
                        child: _infoColLeft("District", data.state ?? "-"),
                      ),
                      Expanded(
                        child: _infoColLeft(
                          "Pal",
                          data.username ?? "-",
                          isBold: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffeb5428),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(Routes.BUYER_PLACE_BID);
                      },
                      child: const Text(
                        "PLACE A BID",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffa06a1b),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(Routes.BUYER_MY_BIDS);
                      },
                      child: const Text(
                        "SEE ALL BIDS",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  /// ---------- LEFT ALIGNED COLUMN WIDGET ----------
  Widget _infoColLeft(
    String title,
    String value, {
    bool isRed = false,
    bool isBold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.bold,
            color: isRed ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }

  String _formatDate(String? raw) {
    if (raw == null) return "-";
    return raw.split(" ").first;
  }
}
