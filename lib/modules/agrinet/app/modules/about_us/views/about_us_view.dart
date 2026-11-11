import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_appbar.dart';
import '../controllers/about_us_controller.dart';

class AboutUsView extends GetView<AboutUsController> {
  const AboutUsView({super.key});
  @override
  Widget build(BuildContext context) {
    const bodyBgColor = Color(0xFFF0F7F7);

    return Scaffold(
      backgroundColor: bodyBgColor,
      appBar: AgAppbar(title: "About Us", showSearch: false),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          color: bodyBgColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (big & bold)
                Text(
                  controller.title.value,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),

                // Paragraphs
                ...controller.paragraphs.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      p,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
