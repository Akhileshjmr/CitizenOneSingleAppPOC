import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/market/market_item.dart';
import '../controllers/market_price_controller.dart';

class MarketPriceView extends GetView<MarketPriceController> {
  const MarketPriceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AgAppbar(title: "Market Prices"),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = controller.marketResponse.value?.resp ?? [];

        if (items.isEmpty) {
          return const Center(child: Text("No Data Found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _priceCard(item);
          },
        );
      }),
    );
  }

  Widget _priceCard(MarketItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Commodity & Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.commodity ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
              Text(
                item.arrivalDate ?? "",
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Market Name
          Text(
            item.market ?? "",
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          // District + State
          Text(
            "${item.district}, ${item.state}",
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),

          const SizedBox(height: 14),

          // Prices Row (Min / Modal / Max)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Min : ${item.minPrice}",
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Model : ${item.modalPrice}",
                style: TextStyle(
                  color: Colors.green.shade900,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Max : ${item.maxPrice}",
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
