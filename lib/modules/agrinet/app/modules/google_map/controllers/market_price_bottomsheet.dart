import 'package:flutter/material.dart';

class MarketPriceBottomSheet extends StatelessWidget {
  final String title;

  const MarketPriceBottomSheet({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          _singleItem("Jambusar", "Cotton", 6300, 6500, 6700),
          _singleItem("Jambusar", "Maize", 2000, 2200, 2400),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _singleItem(String city, String crop, int min, int modal, int max) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            city,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Min : $min", style: const TextStyle(color: Colors.green)),
            Text("Model : $modal"),
            Text("Max : $max", style: const TextStyle(color: Colors.orange)),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
