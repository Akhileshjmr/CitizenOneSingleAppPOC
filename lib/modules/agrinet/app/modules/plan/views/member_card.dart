import 'package:flutter/material.dart';

import '../../../components/ui/ag_textfield.dart';

class MemberCard extends StatefulWidget {
  final String name;
  final String land;
  final TextEditingController contributionCtrl;

  const MemberCard({
    super.key,
    required this.name,
    required this.land,
    required this.contributionCtrl,
  });

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.name, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Available Land"),
              Text(
                widget.land,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          AgTextField(
            controller: widget.contributionCtrl,
            inputType: AgInputType.decimal,
            name: 'contribution',
            label: "Contribution",
            onChanged: (value) {
              setState(() {});
            },
            validator: (value) {
              if (value == null || value.isEmpty) return null;

              final double contribution = double.tryParse(value) ?? 0;
              final double landValue = double.tryParse(widget.land) ?? 0;

              if (contribution > landValue) {
                return "Contribution must not be greater than available land (${widget.land})";
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}
