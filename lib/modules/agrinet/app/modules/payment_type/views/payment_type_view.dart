import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/payment_type/views/payment_option_view.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_environment.dart';
import '../controllers/payment_type_controller.dart';

class PaymentTypeView extends GetView<PaymentTypeController> {
  const PaymentTypeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AgAppbar(title: 'Product View'), body: _body());
  }

  Widget _body() => Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Text('Payment Options', style: kw400Primary20),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...controller.paymentOptions.map((option) {
              return InkWell(
                onTap:
                    () => Get.to(
                      () => PaymentOptionView(
                        paymentType: option['name'],
                        title: option['name'],
                      ),
                    ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(color: AgColors.colorPrimary),
                  child: Column(
                    children: [
                      Image.asset(
                        option['icon'],
                        width: 30,
                        height: 30,
                        package: AppEnvironment.packageName,
                      ),
                      SizedBox(height: 10),
                      Text(option['name'], style: kw500White16),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    ),
  );
}
