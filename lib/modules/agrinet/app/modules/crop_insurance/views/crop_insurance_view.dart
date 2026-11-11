import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_textfield.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/agrinet/app/data/config/ag_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_date_field.dart';
import '../controllers/crop_insurance_controller.dart';

class CropInsuranceView extends GetView<CropInsuranceController> {
  const CropInsuranceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Crop Insurance"),
      body: Obx(() {
        return BaseScreen(
          isLoading: controller.isLoading.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller.sumInsuredController,
                    "Sum Insured",
                  ),
                  _buildTextField(
                    controller.govtShareController,
                    "Government Share (%)",
                  ),
                  _buildTextField(
                    controller.govtPrmAmtController,
                    "Government Premium Amt",
                  ),
                  _buildTextField(
                    controller.grpShareController,
                    "Group Share (%)",
                  ),
                  _buildTextField(
                    controller.grpPrmAmtController,
                    "Group Premium Amt",
                  ),
                  AgDateField(
                    name: "from_date",
                    label: "From Date",
                    rxDate: controller.fromDate,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    onSelect: controller.validateFromDate,
                  ),

                  AgDateField(
                    name: "to_date",
                    label: "To Date",
                    rxDate: controller.toDate,
                    initialDate: controller.fromDate.value ?? DateTime.now(),
                    firstDate: controller.fromDate.value ?? DateTime(2000),
                    lastDate: DateTime(2100),
                    onSelect: controller.validateToDate,
                  ),

                  SizedBox(height: 20),
                  /*Text(
                  "Documents",
                  // style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 10),
                _buildImageGrid(),
                SizedBox(height: 80), */
                ],
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildTextField(TextEditingController tec, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AgTextField(
        controller: tec,
        validator: (value) => value!.isEmpty ? "Field cannot be empty" : null,
        name: label,
        title: label,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget _buildImageGrid() {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: controller.documents.length,
        itemBuilder: (context, index) {
          final doc = controller.documents[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child:
                doc.file != null
                    ? Image.file(doc.file!, fit: BoxFit.cover)
                    : Image.network(doc.fileUrl!, fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        children: [
          /* Expanded(
            child: AgButton(title: "Add Image", onTap: controller.pickImage),
          ),
          const SizedBox(width: 16),*/
          Expanded(
            child: AgButton(title: "Submit", onTap: controller.onFinalSubmit),
          ),
        ],
      ),
    );
  }
}
