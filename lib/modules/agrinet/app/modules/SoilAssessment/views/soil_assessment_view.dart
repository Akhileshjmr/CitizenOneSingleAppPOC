import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/farmPlan/SoilAssessment.dart';
import '../../../utils/ag_colors.dart';
import '../controllers/soil_assessment_controller.dart';

class SoilAssessmentView extends GetView<SoilAssessmentController> {
  const SoilAssessmentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgColors.kWhite,
      appBar: AgAppbar(title: 'Soil Assessment'),
      body: Column(
        children: [
          const SizedBox(height: 6),
          _buildHeaderRow(),
          const Divider(
            height: 1,
            thickness: 2,
            color: AgColors.colorPrimaryDark,
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.soilDetails.value?.soilAssessment?.length,
                itemBuilder: (ctx, index) {
                  final SoilAssessment? item =
                      controller.soilDetails.value?.soilAssessment?[index];
                  final bool alt = index.isOdd; // alternate row color
                  return _buildDataRow(item, alt);
                },
              ),
            ),
          ),
          _buildDownloadRow(),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: const Color(0xffE6F1F2),
      child: Row(
        children: const [
          Expanded(
            flex: 3,
            child: Text(
              'Parameter',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Test Value',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Original Value',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text('Unit', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Rating',
              style: TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(SoilAssessment? item, bool alt) {
    return Container(
      color: alt ? AgColors.buttonColor : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Parameter
          Expanded(
            flex: 3,
            child: Text(
              item?.parameter ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          ),

          // Test value
          Expanded(
            flex: 2,
            child: Text(
              item?.testValue ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          ),

          // Original value as a line
          const Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Divider(thickness: 1, color: Colors.grey),
            ),
          ),

          // Unit
          Expanded(
            flex: 2,
            child: Text(item?.unit ?? '', style: const TextStyle(fontSize: 14)),
          ),

          // Rating
          Expanded(
            flex: 2,
            child: Text(
              item?.rating ?? '',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadRow() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 12, 12),
      color: Colors.white,
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: controller.onDownloadReport,
            child: const Text(
              'Download Report',
              style: TextStyle(
                fontSize: 15,
                color: AgColors.colorPrimaryDark,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
