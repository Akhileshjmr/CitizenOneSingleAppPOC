import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/contact_us_controller.dart';

class ContactUsView extends GetView<ContactUsController> {
  const ContactUsView({super.key});
  @override
  Widget build(BuildContext context) {
    const appBarColor = Color(0xFF33691E); // dark green
    const mapBgColor = Color(0xFFF3EBDD); // light cream
    const bodyBgColor = Color(0xFFF0F7F7); // very light blue/green
    const textColor = Color(0xFFB36A00); // brownish orange

    return Scaffold(
      backgroundColor: bodyBgColor,
      appBar: AgAppbar(title: 'Contact Us'),
      body: Column(
        children: [
          // ---------- Map placeholder ----------
          Container(
            height: 220,
            width: double.infinity,
            color: mapBgColor,
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Google',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),

          // ---------- Contact details ----------
          Expanded(
            child: Container(
              width: double.infinity,
              color: bodyBgColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'Contact Us',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          controller.companyName,
                          style: const TextStyle(
                            fontSize: 20,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...controller.addressLines.map(
                          (line) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              line,
                              style: const TextStyle(
                                fontSize: 18,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.phone,
                          style: const TextStyle(
                            fontSize: 18,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'E-mail: ${controller.email}.',
                          style: const TextStyle(
                            fontSize: 18,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),

                  // ---------- Floating call icon ----------
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        // controller.callNow();
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.phone,
                          size: 30,
                          color: appBarColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
