import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/data/config/ag_dimens.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/buyer_bid_view_controller.dart';

class BuyerBidViewView extends GetView<BuyerBidViewController> {
  const BuyerBidViewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Bid View"),
      backgroundColor: const Color(0xFFE8F0EE),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.bidDetail.value;
        if (data == null) {
          return const Center(child: Text("No data found"));
        }

        return Column(
          children: [
            // ================= HEADER BOX =================
            Container(
              color: const Color(0xFFE5E3E3),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------------- Column 0: Profile Placeholder --------------
                  _profilePlaceholder(),

                  const SizedBox(width: 12),

                  // -------------- Column 1 --------------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title("Bid price"),
                        _value(data.minPrice ?? "-", color: Colors.red),
                        const SizedBox(height: 8),
                        _title("Pal"),
                        _value(data.username ?? "-"),
                      ],
                    ),
                  ),

                  // -------------- Column 2 --------------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title("Quantity"),
                        _value(data.totalQuantity ?? "-"),
                        const SizedBox(height: 8),
                        _title("District"),
                        _value(data.state ?? "-"),
                      ],
                    ),
                  ),

                  // -------------- Column 3 --------------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title("Ready by"),
                        _value(data.readyBy?.split(" ").first ?? "-"),
                        const SizedBox(height: 8),
                        _title("Status"),
                        _value(data.status?.friendlyType ?? "-", bold: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ================= STATUS MESSAGE =================
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Center(
                child: Text(
                  _statusMessage(data.status?.type),
                  textAlign: TextAlign.center,
                  style: kw400Primary12,
                ),
              ),
            ),

            // ================= BUTTONS =================
            if (data.chMessage?.code == "SUCCESS")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    if (data.status?.type == "PENDING_TO_ACCEPT") ...[
                      AgButton(
                        width: double.infinity,
                        title: "Cancel Bid",
                        onTap: controller.showCancelDialog,
                      ),
                      const SizedBox(height: 14),
                    ],

                    AgButton(
                      title: "CHAT",
                      width: double.infinity,
                      onTap: controller.openChat,
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }

  // ================= Helper Widgets =================

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13, color: Colors.black54),
    );
  }

  Widget _value(String text, {Color? color, bool bold = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
        color: color ?? Colors.black,
      ),
    );
  }

  Widget _profilePlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: const Icon(Icons.person, size: 32, color: Colors.grey),
    );
  }

  String _statusMessage(String? status) {
    switch (status) {
      case "BID_ACCEPTED":
        return "You need to pay for this produce before";
      case "PENDING_TO_ACCEPT":
        return "Your offer is awaiting for the pal to approve or reject it.";
      default:
        return "";
    }
  }
}
