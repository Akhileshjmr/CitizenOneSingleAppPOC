import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_constants.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_string_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_image.dart';
import '../../../data/model/user/expense_details.dart';
import '../../../data/model/user/income_details.dart';
import '../../../data/model/user/land_holding.dart';
import '../../../data/model/user/yeild_details.dart';
import '../../../routes/app_pages.dart';
import '../controllers/farmer_profile_controller.dart';

class FarmerProfileView extends GetView<FarmerProfileController> {
  const FarmerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7ECEB),
      appBar: AgAppbar(
        title: 'Farmer Profile',
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(
                Routes.ADD_FARMER,
                arguments: {
                  'farmerId': controller.farmerId,
                  'docId': controller.docId.value,
                },
              );
            },
            child: const Text('Edit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),

      body: Obx(() {
        return BaseScreen(
          isLoading: controller.isLoading.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _profileCard(),
                const SizedBox(height: 16),

                _section(
                  title: 'Dependent Details',
                  child: _dependentDetails(),
                ),

                const SizedBox(height: 16),

                _section(
                  title: 'Communication Details',
                  child: _communicationDetails(),
                ),

                const SizedBox(height: 16),

                _section(
                  title: 'Income and Financial Details',
                  child: _incomeExpenseDetails(),
                ),

                const SizedBox(height: 16),

                _section(
                  title: 'Land and Crop Details',
                  child: _landAndCropDetails(),
                ),

                const SizedBox(height: 16),

                _section(
                  title: 'Crop Yield Details',
                  child: _cropYieldDetails(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ================= PROFILE CARD =================
  Widget _profileCard() {
    return Obx(() {
      final general = controller.farmer.value.docs?.generalDetails;
      if (general == null) return const SizedBox();

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          children: [
            AgImage(
              width: 100,
              height: 100,
              isCircular: true,
              imageUrl:
                  controller
                      .farmer
                      .value
                      .docs
                      ?.generalDetails
                      ?.custPhoto
                      ?.docUrl
                      ?.addBaseUrl,
            ),

            const SizedBox(height: 8),
            Text(
              general.name ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    });
  }

  // ================= DEPENDENT DETAILS =================
  Widget _dependentDetails() {
    return Obx(() {
      final members = controller.farmer.value.docs?.memberDetails;
      if (members == null || members.isEmpty) {
        return const Text('No dependent details available');
      }

      final m = members.first;

      return Column(
        children: [
          _row('Name', '${m.firstName} ${m.lastName}'),
          _row('Date of Birth', m.dob ?? ''),
          _row('Relationship', m.relationship?.type ?? ''),
          _row('Occupation', m.occupation ?? ''),
          _row('Contact Number', m.contactNo ?? ''),
          _row('ID Type', m.idType?.type ?? ''),
          _row('ID Number', m.idNumber ?? ''),
        ],
      );
    });
  }

  // ================= COMMUNICATION DETAILS =================
  Widget _communicationDetails() {
    return Obx(() {
      final comm = controller.farmer.value.docs?.communDetails;
      if (comm == null) {
        return const Text('No communication details available');
      }

      final address =
          comm.residenceAddress?.isNotEmpty == true
              ? comm.residenceAddress!.first.address
              : '';

      final phone =
          comm.phoneDetails?.isNotEmpty == true
              ? comm.phoneDetails!.first.number
              : '';

      return Column(
        children: [
          _iconRow(Icons.location_on, address ?? ''),
          _iconRow(Icons.call, phone ?? ''),
        ],
      );
    });
  }

  // ================= INCOME & EXPENSE =================
  Widget _incomeExpenseDetails() {
    return Obx(() {
      final List<IncomeDetails> income =
          controller.farmer.value.docs?.incDetails ?? <IncomeDetails>[];

      final List<ExpenseDetails> expense =
          controller.farmer.value.docs?.expDetails ?? <ExpenseDetails>[];

      final doc =
          controller.farmer.value.cmOtherDocs?.isNotEmpty == true
              ? controller.farmer.value.cmOtherDocs!.first
              : null;

      if (income.isEmpty && expense.isEmpty && doc == null) {
        return const Text('No income details available');
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Income
          ...income.map(
            (e) => _row(
              e.incomeType?.type ?? '',
              '${e.currency} ${e.incomeValue?.toString() ?? ''}',
            ),
          ),

          /// Expense
          ...expense.map(
            (e) => _row(
              e.expenseType?.type ?? '',
              '${e.currency} ${e.expenseValue?.toString() ?? ''}',
            ),
          ),

          if (doc != null) const SizedBox(height: 12),

          /// Document Section
          if (doc != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// LEFT IMAGE
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFEDEDED),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: AgImage(
                    width: 70,
                    height: 70,
                    borderRadius: 8,
                    imageUrl:
                        (controller.farmer.value.cmOtherDocs ?? [])
                            .first
                            .docPhoto
                            ?.docUrl
                            .addBaseUrl,
                  ),
                ),

                const SizedBox(width: 12),

                /// RIGHT DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _row('Document Type', doc.docName?.friendlyType ?? ''),
                      _row('Issue Date', StringUtil.formatDate(doc.issueDate)),
                      _row(
                        'Expiry Date',
                        StringUtil.formatDate(doc.uploadDate),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      );
    });
  }

  // ================= LAND & CROP =================
  Widget _landAndCropDetails() {
    return Obx(() {
      final List<LandHolding> landList =
          controller.farmer.value.docs?.landHolding ?? <LandHolding>[];

      if (landList.isEmpty) {
        return const Text('No land details available');
      }

      final land = landList.first;

      return Column(
        children: [
          _row('Village', land.village ?? ''),
          _row('Area (sqm)', land.area?.toString() ?? ''),
          _row('Land Type', land.landType?.type ?? ''),
          _row(
            'Farm Value (${AgConstants.currency})',
            land.farmValue?.toString() ?? '',
          ),
          _row('Season', land.season?.type ?? ''),
          _row('Crop Name', land.cropName ?? ''),
        ],
      );
    });
  }

  // ================= CROP YIELD =================
  Widget _cropYieldDetails() {
    return Obx(() {
      final List<YieldDetails> yieldList =
          controller.farmer.value.docs?.yieldDetails ?? <YieldDetails>[];

      if (yieldList.isEmpty) {
        return const Text('No crop yield details available');
      }

      final yield = yieldList.first;

      return Column(
        children: [
          _row('Year', yield.year?.type ?? ''),
          _row('Season', yield.season?.friendlyType ?? ''),
          _row('Crop Name', yield.corpName ?? ''),
          _row('Yield (Kg/Acre)', yield.yieldQty?.toString() ?? ''),
          _row(
            'Yield Value (${AgConstants.currency})',
            yield.yieldValue?.toString() ?? '',
          ),
        ],
      );
    });
  }

  // ================= COMMON =================
  Widget _section({required String title, required Widget child}) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFC4CFBF),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: child,
        ),
      ],
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            flex: 5,
            child: Text(
              ': $value',
              style: const TextStyle(fontWeight: FontWeight.w600),
              softWrap: true,
              maxLines: null,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFDDE3E1),
            child: Icon(icon, color: const Color(0xFF3E5322)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    );
  }
}
