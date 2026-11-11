import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../utils/app_colors.dart';

class BottomSheetWidget extends StatelessWidget {
  final String data;

  const BottomSheetWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: MediaQuery.of(context).size.height,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          // Text(data),
          Html(data: data),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.primary,
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
