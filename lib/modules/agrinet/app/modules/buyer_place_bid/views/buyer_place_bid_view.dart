import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_textfield.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/agrinet/app/data/config/ag_dimens.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_image.dart';
import '../../../components/ui/ag_loader.dart';
import '../controllers/buyer_place_bid_controller.dart';

class BuyerPlaceBidView extends GetView<BuyerPlaceBidController> {
  const BuyerPlaceBidView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0EE),
      appBar: const AgAppbar(title: "Place Bid"),
      bottomNavigationBar: _bottomButton(),
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(child: AgLoader())
                : _body(),
      ),
    );
  }

  // ------------------------ MAIN BODY ------------------------
  Widget _body() {
    final d = controller.data;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ---------------- IMAGE + CROP NAME ----------------
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
                child:
                    (d?.documents.isNotEmpty == true &&
                            d?.documents.first.fileName?.isNotEmpty == true)
                        ? ClipOval(
                          child: AgImage(
                            imageUrl: d?.documents.first.fileName!.addBaseUrl,
                          ),
                        )
                        : Icon(
                          Icons.image,
                          size: 36,
                          color: Colors.grey.shade600,
                        ),
              ),
              const SizedBox(width: 16),

              Text(
                (d?.cropName.isNotEmpty == true)
                    ? (d?.cropName.first.cropName ?? "Wheat")
                    : "Wheat",
                style: kw500Primary18,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ---------------- 3 COLUMN ROW ----------------
          Row(
            children: [
              _detailColumn("Min. price", d?.minPrice ?? "-"),
              _detailColumn("Quantity", d?.totalQuantity ?? "-", orange: true),
              _detailColumn("Ready by", (d?.readyBy ?? "").split(" ").first),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _detailColumn(
                "Biding Closes",
                (d?.bidClose ?? "").split(" ").first,
              ),
              _detailColumn("District", d?.state ?? "-"),
              _detailColumn("Pal", d?.username ?? "-", bold: true),
            ],
          ),

          const SizedBox(height: 40),

          // ---------------- INPUT FIELD ----------------
          AgTextField(
            name: "pricePerKg",
            label: "Price offered per kg",
            onChanged: (_) => controller.validatePrice(),
            controller: controller.priceController,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 10),

          // ---------------- MIN PRICE ERROR ----------------
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Min. price : \$${controller.minPrice}",
              style: const TextStyle(
                color: AgColors.orange,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ------------------------ BOTTOM BUTTON ------------------------
  Widget _bottomButton() {
    return SafeArea(
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: AgButton(
            title:
                controller.isSubmitting.value ? "Submitting..." : "PLACE A BID",
            onTap:
                controller.isSubmitting.value
                    ? null
                    : () {
                      controller.submitBid();
                    },
            backgroundColor:
                controller.isSubmitting.value
                    ? AgColors.k4F4F4F
                    : AgColors.orange,
          ),
        ),
      ),
    );
  }

  // ------------------------ 1 COLUMN BOX ------------------------
  Widget _detailColumn(
    String title,
    String value, {
    bool orange = false,
    bool bold = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(title, style: kw400Secondary12),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              color: orange ? AgColors.orange : AgColors.kPrimaryText,
            ),
          ),
        ],
      ),
    );
  }
}
