import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:flutter/material.dart';

import '../../../../data/model/plan/group_farming_plan.dart';

class FarmPlanListTile extends StatelessWidget {
  final FarmingPlanItem item;
  final VoidCallback? onTap;

  const FarmPlanListTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------- TOP GREY BAR ----------
            Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Group name
                    Text(item.groupName, style: kw500Secondary12),

                    /// Status (New)
                    Text(item.appStatus, style: kw500Green14),
                  ],
                ),
              ),
            ),

            /// ---------- BOTTOM PLAN ID ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(item.planId, style: kw400Primary16),
            ),
          ],
        ),
      ),
    );
  }
}
