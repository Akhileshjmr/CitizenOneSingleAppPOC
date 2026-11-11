import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_image.dart';
import '../../../components/ui/ag_loader.dart';
import '../../../data/model/plant_protection/insect_model.dart';
import '../../../theme/ag_text_styles.dart';
import '../controllers/plant_protection_controller.dart';

class DetailsView extends StatelessWidget {
  final PlantProtectionController controller = Get.find();

  DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments as InsectModel?;

    return Scaffold(
      appBar: AgAppbar(title: "Details", showLogout: true),
      body: Obx(() {
        final details = controller.details.value ?? arg;

        if (controller.isLoading.value && details == null) {
          return const Center(child: AgLoader());
        }

        if (details == null) {
          return const Center(child: Text('No details'));
        }

        final ipm = details.ipmPractice ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Insect: Symptom, Description and IPM Practices',
                style: kw400Primary12,
              ),

              const SizedBox(height: 12),

              /// TOP IMAGE CARD
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: AgImage(
                    imageUrl: details.insDocument?.addBaseUrl,
                    fit: BoxFit.cover,

                    /// Fallback when image fails
                    errorWidget: Container(
                      color: Colors.teal.shade300,
                      alignment: Alignment.center,
                      child: Text(
                        details.insName.isNotEmpty
                            ? details.insName[0].toUpperCase()
                            : "?",
                        style: const TextStyle(
                          fontSize: 88,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// DETAILS CARDS
              infoCard(title: 'Name', subtitle: details.insName),

              if (details.insType != null)
                infoCard(title: 'Symptom', subtitle: details.insType ?? ''),

              infoCard(title: 'Insect Stage', subtitle: details.insStage ?? ''),

              const SizedBox(height: 24),

              /// IPM SECTION
              Text('IPM Practices', style: kw600Green18),

              const SizedBox(height: 12),

              Column(
                children:
                    ipm.map((p) {
                      return infoCard(title: p.heading, subtitle: p.desc);
                    }).toList(),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// REUSABLE INFO CARD
  Widget infoCard({required String title, required String subtitle}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(title, style: kw500Green14),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
