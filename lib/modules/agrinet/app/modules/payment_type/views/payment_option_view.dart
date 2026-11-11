import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_textfield.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/payment_type/controllers/payment_type_controller.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/payment_type/views/payment_otp_view.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/payment_type/views/payment_transaction_view.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PaymentOptionView extends GetView<PaymentTypeController> {
  const PaymentOptionView({
    super.key,
    required this.paymentType,
    required this.title,
  });

  final dynamic paymentType;
  final dynamic title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: title == 'Loan' ? 'Account Details' : 'AgriNET'),
      body: _body(),
    );
  }

  Widget _body() => Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        paymentType == 'Online'
            ? _onlineTypeWidget()
            : paymentType == 'Offline'
            ? _offlineTypeWidget()
            : _accountDetailsWidget(),
      ],
    ),
  );

  Widget _headerWidget() => Container(
    color: AgColors.kWhite,
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Amount to Pay',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 2),
            Obx(
              () => Text(
                controller.price.value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Order Ref Number',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 2),
            Text(
              '536253',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    ),
  );
  Widget _onlineTypeWidget() => Obx(
    () =>
        controller.isLoading.value
            ? Center(child: AgLoader())
            : Column(
              children: [
                _headerWidget(),
                SizedBox(height: 25),
                Container(
                  color: AgColors.kWhite,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    children: [
                      _buildtextField(
                        fieldName: 'Card Holder Name',
                        controller: controller.cardHolderNameController,
                        isNumber: false,
                      ),
                      _buildtextField(
                        fieldName: 'Card Number',
                        controller: controller.cardNumberController,
                        isNumber: true,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildtextField(
                              fieldName: 'CCV',
                              controller: controller.ccvController,
                              isNumber: true,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: _buildtextField(
                              fieldName: 'Expiry Date',
                              controller: controller.expiryDateController,
                              isNumber: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => InkWell(
                    onTap: () {
                      controller.isSaveMyCardActive.value =
                          !controller.isSaveMyCardActive.value;
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: AgColors.colorPrimary,
                          value: controller.isSaveMyCardActive.value,
                          onChanged:
                              (value) =>
                                  controller.isSaveMyCardActive.value =
                                      value ?? false,
                        ),
                        const Text('Save My Card'),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
                AgButton(
                  onTap: () async {
                    if (controller.cardHolderNameController.text == "" ||
                        controller.cardNumberController.text == "" ||
                        controller.ccvController.text == "" ||
                        controller.expiryDateController.text == "") {
                      agSnackbar(
                        title: 'Error',
                        msg: 'Please fill all the fields',
                      );
                      return;
                    } else {
                      controller.isLoading(true);
                      await Future.delayed(Duration(seconds: 3));
                      Get.toNamed(
                        Routes.SUCCESS_INFO,
                        arguments: {
                          "title": "Success",
                          "message": "Payment Successful",
                          "onOk": () {
                            Get.offAllNamed(Routes.HOME);
                          },
                        },
                      );
                      controller.isLoading(false);
                    }
                  },
                  backgroundColor: AgColors.colorPrimary,
                  title: 'Pay Now',
                  width: Get.width * 0.5,
                ),
              ],
            ),
  );

  Widget _offlineTypeWidget() {
    Widget buildDetails(title, value) => Row(
      children: [Text(title, style: kw300Primary14), Text(' : '), Text(value)],
    );
    return Column(
      children: [
        Text('Bank Transfer'),
        SizedBox(height: 10),
        buildDetails('Bank', 'Citi Bank'),
        buildDetails('Account Number', '0212390060'),
        buildDetails('Account Name', 'JMR AgriNet pal'),
        SizedBox(height: 20),
        Text(
          'Once you have paud, Please enter your transaction ID below',
          style: kw300Primary10,
          textAlign: TextAlign.center,
        ),
        AgButton(
          width: Get.width * 0.7,
          title: 'Enter transaction ID',
          onTap: () {
            Get.to(() => PaymentTransactionIdView());
          },
        ),
      ],
    );
  }

  Widget _accountDetailsWidget() => Center(
    child: Column(
      children: [
        Text('Paying from Bank Account', style: kw400Primary20),
        TextButton(
          onPressed: () => Get.toNamed(Routes.FARM_PLANS),
          child: Text('Click Here to Choose Farm Plan', style: kA13D3Ffs14w400),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Form Plan ID  ', style: kw300Primary14),
            Text('SHG100518000000151', style: kw600Primary14),
          ],
        ),
        SizedBox(height: 20),
        Text('Account Nymber'),
        SizedBox(height: 20),
        Text('Balance'),
        SizedBox(height: 20),
        Text('Amount to pay'),
        SizedBox(height: 20),
        Text(controller.price.value, style: kw400Primary20),
        SizedBox(height: 20),
        AgButton(
          width: Get.width * 0.4,
          title: 'Pay Now',
          onTap: () {
            Get.to(() => PaymentOtpView());
          },
        ),
      ],
    ),
  );

  Widget _buildtextField({
    required String fieldName,
    required TextEditingController controller,
    required isNumber,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: AgTextField(
      controller: controller,
      name: fieldName,
      hasBorder: false,
      hasUnderLineBorder: true,
      label: fieldName,
      hintText: null,
      filled: false,
      contentPadding: EdgeInsets.only(bottom: 6),
      inputFormatters:
          isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
    ),
  );
}
