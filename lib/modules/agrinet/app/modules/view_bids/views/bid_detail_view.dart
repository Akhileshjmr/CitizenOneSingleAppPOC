import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_image.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/agrinet/app/data/config/ag_dimens.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/view_bids/one_advertise_history.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/view_bids/controllers/view_bids_controller.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_alert_dialogue.dart';

class BidDetailView extends StatelessWidget {
  BidDetailView({super.key, required this.bidPlan});

  final BidPlan bidPlan;

  final ViewBidsController controller = Get.put(ViewBidsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: 'Bid View'),
      backgroundColor: AgColors.kE7E7E7,
      body: _body(),
    );
  }

  Widget _body() => Obx(
    () => BaseScreen(
      isLoading: controller.isLoading.value,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _bidViewCardWidget(),
            const SizedBox(height: 15),
            _bottomSection(),
          ],
        ),
      ),
    ),
  );

  // ================= BUTTONS =================

  Widget _bottomSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        children: [
          if (bidPlan.status?.type == "PENDING_TO_ACCEPT") ...[
            /// ACCEPT
            AgButton(
              width: Get.width,
              title: 'Accept Bid',
              onTap:
                  () => _showConfirmDialog(
                    title: "Accept Bid",
                    message: "Are you sure you want to accept this bid?",
                    onConfirm: () {
                      controller.acceptBidPlan(
                        bidId: bidPlan.bidId ?? '',
                        advertiseId: bidPlan.adId ?? "",
                      );
                    },
                  ),
            ),

            SizedBox(height: 8),

            /// REJECT
            AgButton(
              width: Get.width,
              title: 'Reject Bid',
              backgroundColor: AgColors.orange,
              onTap:
                  () => _showConfirmDialog(
                    title: "Reject Bid",
                    message: "Are you sure you want to reject this bid?",
                    onConfirm: () {
                      controller.rejectBidPlan(
                        bidId: bidPlan.bidId ?? '',
                        advertiseId: bidPlan.adId ?? "",
                      );
                    },
                  ),
            ),
          ],

          SizedBox(height: 8),

          /// CHAT
          AgButton(
            width: Get.width,
            title: 'Chat',
            onTap: () {
              Get.toNamed(Routes.CHAT, arguments: {'bid_id': bidPlan.bidId!});
            },
          ),
        ],
      ),
    );
  }

  // ================= CARD =================

  Widget _bidViewCardWidget() {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        color: AgColors.kWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              children: [
                const TextSpan(text: 'Bid Placed:', style: kw400Grey20),
                TextSpan(text: ' ${bidPlan.cropName}', style: kw400Primary20),
              ],
            ),
          ),

          const SizedBox(height: 20),

          AgImage(
            imageUrl: bidPlan.buyerImage.addBaseUrl,
            width: 70,
            height: 70,
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _topInfoColumn(
                'Minimum',
                controller.selectedAdvertiseProduce?.minPrice ?? '',
              ),
              _topInfoColumn(
                'Total quantity',
                controller.selectedAdvertiseProduce?.totalQuantity ?? '',
              ),
              _topInfoColumn(
                'Bidding closes',
                controller.formatDate(
                  controller.selectedAdvertiseProduce?.bidClose ?? '',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _topInfoColumn(
            'Ready by',
            controller.formatDate(
              controller.selectedAdvertiseProduce?.readyBy ?? '',
            ),
            center: true,
          ),

          const Divider(height: 10),

          Row(
            children: [
              AgImage(
                imageUrl: bidPlan.buyerImage.addBaseUrl,
                width: 70,
                height: 70,
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bidPlan.buyerName ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  _bidInfoRow(
                    'Bid price',
                    '${AgConstants.currency} ${bidPlan.minPrice}',
                  ),

                  const SizedBox(height: 4),

                  _bidInfoRow(
                    'Total quantity',
                    '${bidPlan.totalQuantity} ${AgConstants.quantity}',
                    valueColor: Colors.red,
                  ),

                  const SizedBox(height: 4),

                  _bidInfoRow(
                    'Total',
                    '${AgConstants.currency} ${bidPlan.totalPrice}',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _topInfoColumn(String title, String value, {bool center = false}) {
    return SizedBox(
      width: Get.width * 0.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bidInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),

        const SizedBox(width: 4),

        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ================= DIALOG =================

  void _showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    AgAlertDialog.confirm(
      title: title,
      message: message,
      okText: 'Yes',
      cancelText: 'No',
      onConfirm: onConfirm,
      onCancel: () => Get.back(),
    );
  }
}
