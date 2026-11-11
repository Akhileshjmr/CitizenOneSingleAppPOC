import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_dropdown_option.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_textfield.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/publish_ads/controllers/publish_ads_variables.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../components/ui/ag_date_field.dart';
import '../../../theme/ag_text_styles.dart';
import '../controllers/publish_ads_controller.dart';

class PublishAdsView extends GetView<PublishAdsController> {
  const PublishAdsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: 'Advertise Products'),
      body: _body(context),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _body(context) {
    return Obx(
      () => BaseScreen(
        isLoading: controller.isLoading.value,
        child: SingleChildScrollView(
          child: Container(
            width: Get.width,
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AgColors.kEFFFF2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(),
            ),
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _formFields(),
                AgDateField(
                  name: 'Ready By',
                  label: 'Ready By',
                  rxDate: controller.readyByDate,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: controller.bidingCloseDate.value ?? DateTime(2100),
                  onSelect: (d) {
                    controller.readyByDate.value = d;

                    if (controller.bidingCloseDate.value != null &&
                        controller.bidingCloseDate.value!.isBefore(d)) {
                      controller.bidingCloseDate.value = null;
                    }
                  },
                ),
                AgDateField(
                  name: 'Biding Closes',
                  label: 'Biding Closes',
                  rxDate: controller.bidingCloseDate,
                  initialDate: controller.readyByDate.value ?? DateTime.now(),
                  firstDate: controller.readyByDate.value ?? DateTime.now(),
                  lastDate: DateTime(2100),
                  onSelect: (d) => controller.bidingCloseDate.value = d,
                ),
                _transportationField(),
                _addImageWidget(),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        AgDropDownOption(
          name: "Farm Plan",
          label: "Farm Plan",
          items: controller.farmerPlanList,
          value: controller.selectedFarmPlan.value,
          onChanged: (planOption) async {
            controller.selectedFarmPlan.value = planOption!;
            await controller.getFarmPlanDetails(planOption);
          },
          hintText: "Select Group",
        ),

        SizedBox(height: 5),
        _planDetails(),
        AgTextField(
          name: 'minimumpriceperkg',
          controller: controller.minimumPricePerKgController,
          inputType: AgInputType.numberOnly,
          label: 'Minimum price (${AgConstants.currency}) per kilogram',
          maxLength: 8,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[1-9][0-9]*')),
          ],
        ),
        SizedBox(height: 5),
        AgTextField(
          name: 'Total Quantity',
          controller: controller.totalQuantity,
          inputType: AgInputType.numberOnly,
          label: 'Total Quantity (${AgConstants.quantity})',
          maxLength: 6,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[1-9][0-9]*')),
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _planDetails() {
    buildField(title, value) {
      return Row(children: [Text(title), Text('  :  '), Text(value)]);
    }

    return Obx(() {
      final detail = controller.cropDetailResponse.value;

      if (controller.isPlanDetailLoading.value && detail == null) {
        return const Center(child: AgLoader());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          buildField('Group Id', detail?.groupID ?? 'NA'),
          buildField('Group Name', detail?.username ?? 'NA'),
          buildField(
            'Crop Name',
            detail?.cropName?.isNotEmpty == true
                ? detail?.cropName![0].cropName
                : 'NA',
          ),
        ],
      );
    });
  }

  Widget _transportationField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 12),
      Text('Transportation Provided'),
      const SizedBox(width: 12),
      Obx(
        () => Row(
          children: [
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: controller.isTransportationProvided.value,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    controller.isTransportationProvided(value);
                  },
                ),
                const Text('Yes'),
              ],
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                Radio<bool>(
                  value: false,
                  groupValue: controller.isTransportationProvided.value,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    controller.isTransportationProvided(value);
                  },
                ),
                const Text('No'),
              ],
            ),
          ],
        ),
      ),
    ],
  );

  Widget _addImageWidget() {
    return Obx(() {
      if (controller.imageItems.isEmpty) {
        controller.imageItems.add(ImageDocItem());
      }

      final item = controller.imageItems.first;
      final nameController = TextEditingController(
        text: item.documentName ?? '',
      );

      final hasImage = item.imageFile != null;
      final hasName = (item.documentName ?? '').trim().isNotEmpty;
      final showError = item.showError && (!hasImage || !hasName);

      if (item.saved) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AgColors.kEFFFF2,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              if (item.imageFile != null)
                Image.file(
                  item.imageFile!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              else
                const Icon(Icons.image),
              const SizedBox(width: 8),
              Expanded(
                child: Text(item.documentName ?? '', style: kw600Primary14),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  controller.imageItems.first.saved = false;
                  controller.imageItems.refresh();
                },
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              SizedBox(width: 10),
              Icon(Icons.image, color: AgColors.k297B33, size: 30),
              SizedBox(width: 20),
              Text('Add Image', style: k297B33FS16w600),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AgColors.kEFFFF2,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: showError ? Colors.red : Colors.grey),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        var status = await Permission.camera.request();
                        if (!status.isGranted) {
                          agSnackbar(title: "Permission", msg: "Camera denied");
                          return;
                        }

                        final file = await controller.pickFromCamera();

                        if (file != null) {
                          controller.imageItems.first.imageFile = file;
                          controller.imageItems.first.showError = false;
                          controller.imageItems.refresh();
                        }
                      },
                      child:
                          hasImage
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.file(
                                  item.imageFile!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                              : const Icon(Icons.add, size: 32),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: "Enter Document Name",
                          border: UnderlineInputBorder(),
                        ),
                        onChanged: (v) {
                          controller.imageItems.first.documentName = v;
                          controller.imageItems.first.showError = false;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon:
                          item.isUploading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : Icon(
                                Icons.check_circle,
                                color:
                                    item.uploaded
                                        ? AgColors.colorPrimary
                                        : AgColors.kHintText,
                              ),
                      onPressed: () async {
                        final validImage = item.imageFile != null;
                        final validName =
                            (item.documentName ?? '').trim().isNotEmpty;

                        if (!validImage || !validName) {
                          controller.imageItems.first.showError = true;
                          controller.imageItems.refresh();
                          return;
                        }

                        FocusScope.of(Get.context!).unfocus();

                        await controller.uploadSingleDocument(0);
                      },
                    ),
                  ],
                ),
                if (showError)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      "Image and document name are required",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildBottomNavigationBar() => Obx(
    () =>
        controller.isLoading.value
            ? SizedBox.shrink()
            : Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: AgButton(
                onTap: () async {
                  controller.publishAdvertise();
                },
                backgroundColor: AgColors.FF4500,
                title: 'Publish',
                width: Get.width,
              ),
            ),
  );
}
