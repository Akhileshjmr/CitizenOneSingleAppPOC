import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_image.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/view_bids/adverise_history_list.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/view_bids/one_advertise_history.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/view_bids/controllers/view_bids_controller.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/view_bids/views/bid_detail_view.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BidHistoryView extends GetView<ViewBidsController> {
  const BidHistoryView({super.key, required this.advertiseHistoryData});
  final AdvertiseProduce advertiseHistoryData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(
        title: 'History View',
        actions: const [Icon(Icons.search, color: AgColors.kE7E7E7)],
      ),
      body: _body(),
    );
  }

  Widget _body() =>
      Column(children: [_bidDetailCard(), Expanded(child: _bidListView())]);

  Widget _bidListView() {
    return Obx(
      () =>
          controller.bidList.isEmpty
              ? Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('There are no bids', style: kw400Primary20),
                    SizedBox(height: 5),
                    Text(
                      'When someone bids on your product, the information will appear here.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: controller.bidList.length,
                itemBuilder: (context, index) {
                  BidPlan bidPlan = controller.bidList[index];

                  return InkWell(
                    onTap: () => Get.to(() => BidDetailView(bidPlan: bidPlan)),
                    child: Container(
                      color: AgColors.kWhite,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AgImage(imageUrl: bidPlan.buyerImage),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bidPlan.cropName ?? "",
                                  style: kw500Primary16,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text('Bid Price : ', style: kw300Primary10),
                                    Text(
                                      bidPlan.minPrice ?? '',
                                      style: kw400Primary14,
                                    ),
                                    SizedBox(width: 20),
                                    Text('Quantity : ', style: kw300Primary10),
                                    Text(
                                      bidPlan.totalQuantity ?? "",
                                      style: kw400Primary14,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text('Total : ', style: kw300Primary10),
                                    Text(
                                      bidPlan.totalPrice ?? "",
                                      style: kw400Primary14,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      bidPlan.status!.friendlyType!,
                                      style: kw500Primary16.copyWith(
                                        color: AgColors.kFF4600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Widget _bidDetailCard() {
    final docs = advertiseHistoryData.documents;

    return Container(
      color: AgColors.kfffac3,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 172, 171, 171),
            ),
            child:
                (advertiseHistoryData.documents?.isNotEmpty == true &&
                        advertiseHistoryData
                                .documents!
                                .first
                                .fileName
                                ?.isNotEmpty ==
                            true)
                    ? AgImage(
                      imageUrl:
                          advertiseHistoryData
                              .documents!
                              .first
                              .fileName!
                              .addBaseUrl,
                    )
                    : const Icon(Icons.camera_alt, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bid price',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      advertiseHistoryData.minPrice!,
                      style: kA13D3Ffs16w500,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Bidding closes',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(controller.formatDate(advertiseHistoryData.bidClose!)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quantity',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      advertiseHistoryData.totalQuantity!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Ready by',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.formatDate(advertiseHistoryData.readyBy!),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
