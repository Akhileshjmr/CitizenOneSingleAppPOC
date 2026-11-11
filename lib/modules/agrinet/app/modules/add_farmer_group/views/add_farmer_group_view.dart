import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_image.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_textfield.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/farmer_group/farmer_list.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/add_farmer_group/controllers/add_farmer_group_controller.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFarmerGroupView extends GetView<AddFarmerGroupController> {
  const AddFarmerGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(
        title: controller.agApptranslation.farmerGroup,
        showSearch: true,
        onSearchChanged: controller.filterFarmers,
      ),
      body: Obx(
        () =>
            controller.isLoading.value
                ? Center(child: AgLoader())
                : Container(
                  margin: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AgColors.kEFFFF2,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Column(
                    children: [
                      Expanded(child: _body(context)),
                      _buildBottomNavigationBar(),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _body(context) {
    return Column(
      children: [
        _buildInputField('Group Name', controller.groupNameController),
        const SizedBox(height: 10),
        _buildInputField(
          'Group Description',
          controller.groupDescriptionController,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: controller.farmerList.length,
            itemBuilder: (context, index) {
              FarmerDetail farmer = controller.farmerList[index];
              return _farmerListView(farmer);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String title, TextEditingController controller) {
    return AgTextField(
      name: title,
      title: title,
      controller: controller,
      titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget _buildBottomNavigationBar() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 15),
    child: AgButton(
      onTap: () async {
        controller.onSaveFarmerGroup();
      },
      backgroundColor: AgColors.FF4500,
      title: 'Save',
      width: Get.width,
    ),
  );

  Widget _farmerListView(FarmerDetail farmerDetail) {
    return Card(
      color: AgColors.kffffff,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AgImage(
              imageUrl: farmerDetail.imageUrl?.docUrl.addBaseUrl,
              isCircular: true,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(farmerDetail.farmer!.type!, style: kw600Primary14),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Radio<int>(
                        value: farmerDetail.farmer!.id!,
                        groupValue: controller.selectedLeaderId?.value,
                        activeColor: AgColors.k027212,
                        onChanged: (value) {
                          controller.selectLeader(value!);
                        },
                      ),
                      const Text("Is Leader"),
                    ],
                  ),
                ],
              ),
            ),

            Obx(
              () => AgButton(
                width: 90,
                height: 30,
                isOutlined:
                    !controller.selectedFarmerList.contains(
                      farmerDetail.farmer!.id,
                    ),
                title:
                    controller.selectedFarmerList.contains(
                          farmerDetail.farmer!.id,
                        )
                        ? 'Added'
                        : 'Add',
                onTap: () => controller.toggleFarmer(farmerDetail.farmer!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
