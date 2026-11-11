import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:flutter/material.dart';

import '../../../../components/utils/date_utils.dart';
import '../../../../data/model/buyer_demand/buyer_demand_item.dart';

class BuyerDemandTile extends StatelessWidget {
  final BuyerDemandItem item;

  const BuyerDemandTile({super.key, required this.item});

  /// ----------------------------------------
  /// Local formatter for:
  ///  Key (grey) + Value (bold)
  /// ----------------------------------------
  Widget _labelValue(String label, String value) {
    return RichText(
      text: TextSpan(
        text: "$label ",
        style: kw400Secondary14,
        children: [TextSpan(text: value, style: kw400Primary14)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ID + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.buyerCommodityId.toString(), style: kw600Green18),
              Text(item.buyerStatus, style: kw600Primary14),
            ],
          ),

          const SizedBox(height: 4),

          /// Crop Name
          Text(item.cropName, style: kw700Primary16),

          const SizedBox(height: 8),

          /// Price + Total Qty (formatted using helper)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _labelValue("Price per Kg", item.pricePerKg.toString()),
              _labelValue("Total Qty", item.totalQuantity.toString()),
            ],
          ),

          const SizedBox(height: 6),

          /// Required On (formatted using helper)
          _labelValue("Required On", DateFormatter.ddMMyyyy(item.requestedOn)),
        ],
      ),
    );
  }
}
