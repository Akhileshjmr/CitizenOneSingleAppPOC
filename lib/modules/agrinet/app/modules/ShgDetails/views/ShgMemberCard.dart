// shg_member_card.dart
import 'package:flutter/material.dart';

import '../../../data/model/shgDetails/shgDetailsResp.dart';

class ShgMemberCard extends StatelessWidget {
  final GroupDetail? member;

  const ShgMemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(member?.custName ?? '', style: const TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Row(
            children: [
              const Text("Contribution", style: TextStyle(fontSize: 15)),
              const Spacer(),
              Text(
                '${member?.contribution ?? ''}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
