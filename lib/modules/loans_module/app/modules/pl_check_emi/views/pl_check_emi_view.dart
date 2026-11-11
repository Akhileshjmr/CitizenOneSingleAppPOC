import 'package:donut_chart/donut_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';

import '../../../components/ui/app_loader.dart';
import '../../../components/utils/common_utilities.dart';
import '../../../utils/app_colors.dart';
import '../controllers/pl_check_emi_controller.dart';

enum EmiFieldType { loanAmount, interestRate, tenure }

class PlCheckEmiView extends GetView<PlCheckEmiController> {
  PlCheckEmiView({super.key});

  TextEditingController _getController(EmiFieldType type) {
    switch (type) {
      case EmiFieldType.loanAmount:
        return controller.loanEmiController;
      case EmiFieldType.interestRate:
        return controller.interestController;
      case EmiFieldType.tenure:
        return controller.tenureController;
    }
  }

  final FocusNode _loanFocus = FocusNode();
  final FocusNode _interestFocus = FocusNode();
  final FocusNode _tenureFocus = FocusNode();

  FocusNode _getFocusNode(EmiFieldType type) {
    switch (type) {
      case EmiFieldType.loanAmount:
        return _loanFocus;
      case EmiFieldType.interestRate:
        return _interestFocus;
      case EmiFieldType.tenure:
        return _tenureFocus;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: AppColors.kF8FAFC,
    appBar: AgAppbar(title: 'EMI Calculator'),
    body: Obx(
      () => Visibility(
        replacement: const Center(child: AppLoader()),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600), 
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal:kIsWeb? 6.w: 20.w, vertical: kIsWeb? 8.h:10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  15.verticalSpace,
                  _sliderSection(
                    title: 'Loan Amount',
                    value:
                        '${CommonUtilities.AppCurrency}${controller.loanEMI().toInt()}',
                    minValue: "1K",
                    maxValue: "2000K",
                    maxLength: 7,
                    type: EmiFieldType.loanAmount,
                    slider: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: CustomThumbShape(),
                        thumbColor: Colors.white,
                      ),
                      child: Slider(
                        padding: EdgeInsets.fromLTRB(0, 5.sp, 0, 5.sp),
                        thumbColor: AppColors.white,
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.grey,
                        min: 0.0,
                        max: 2000000.0,
                        divisions: 1000,
                        value: controller.loanEMI.toDouble(),
                        onChanged: (value) {
                          controller.loanEMI(value);
                          controller.loanEmiController.text =
                              value.toInt().toString();
                        },
                        onChangeEnd: (value) {
                          controller.loanEMI(value);
                          controller.getCalculatedEmi(
                            controller.loanEMI.value,
                            controller.interestRate.value,
                            controller.loanTenure.value,
                          );
                        },
                      ),
                    ),
                  ),
                  15.verticalSpace,
            
                  _sliderSection(
                    title: 'Interest Rate (%)',
                    value: '${controller.interestRate().toInt()} %',
                    minValue: "1%",
                    maxValue: "30%",
                    maxLength: 4,
                    type: EmiFieldType.interestRate,
                    slider: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                        thumbShape: CustomThumbShape(),
                        thumbColor: Colors.white,
                      ),
                      child: Slider(
                        padding: EdgeInsets.fromLTRB(0, 5.sp, 0, 5.sp),
                        thumbColor: AppColors.white,
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.grey,
                        min: 1.0,
                        max: 30.0,
                        value: controller.interestRate.toDouble(),
                        onChanged: (value) {
                          controller.interestRate(value);
                          controller.interestController.text =
                              value.toInt().toString();
                        },
                        onChangeEnd: (value) {
                          controller.interestRate(value);
                          controller.getCalculatedEmi(
                            controller.loanEMI.value,
                            controller.interestRate.value,
                            controller.loanTenure.value,
                          );
                        },
                      ),
                    ),
                  ),
                  15.verticalSpace,
            
                  _sliderSection(
                    title: 'Loan Tenure (Years)',
                    value: '${controller.loanTenure().toInt()} Y',
                    minValue: "1Y",
                    maxValue: "30Y",
                    maxLength: 2,
                    type: EmiFieldType.tenure,
                    slider: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                        thumbShape: CustomThumbShape(),
                        thumbColor: Colors.white,
                      ),
                      child: Slider(
                        padding: EdgeInsets.fromLTRB(0, 5.sp, 0, 5.sp),
                        thumbColor: AppColors.white,
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.grey,
                        min: 1.0,
                        max: 30.0,
                        value: controller.loanTenure.toDouble(),
                        onChanged: (value) {
                          controller.loanTenure(value);
                          controller.tenureController.text = value.toInt().toString();
                        },
                        onChangeEnd: (value) {
                          controller.loanTenure(value);
                          controller.getCalculatedEmi(
                            controller.loanEMI.value,
                            controller.interestRate.value,
                            controller.loanTenure.value,
                          );
                        },
                      ),
                    ),
                  ),
                  15.verticalSpace,
            
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    decoration: BoxDecoration(
                      color: AppColors.kffffff,
                      border: Border.all(color: AppColors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            DonutChartWidget(
                              size: kIsWeb? 90.sp: 200.sp,
                              strokeWidth: kIsWeb? 15.sp:20.sp,
                              tooltipRadius: 10,
                              tooltipBgColor: const Color.fromARGB(
                                154,
                                178,
                                178,
                                178,
                              ),
                              data: [
                                DonutSectionModel(
                                  label: "Principal Amount",
                                  value: controller.loanEMI().toDouble(),
                                  color: AppColors.k1D4ED8,
                                ),
                                DonutSectionModel(
                                  label: "Total Interest",
                                  value: controller.totalInterest.toDouble(),
                                  color: AppColors.kOrange,
                                ),
                              ],
                            ),
                            _infoItem(
                              'Monthly EMI',
                              '${CommonUtilities.AppCurrency} ${controller.formatAmount(controller.finalLoanEmi())}',
                            ),
                          ],
                        ),
                        15.verticalSpace,
                        Padding(
                          padding: EdgeInsets.all(17.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _indicatorItem(
                                color: AppColors.k1D4ED8,
                                title: "Principal Amount",
                                value:
                                    "${CommonUtilities.AppCurrency} ${controller.formatAmount(controller.loanEMI.toDouble())}",
                              ),
                              4.verticalSpace,
                              _indicatorItem(
                                color: AppColors.kOrange,
                                title: "Total Interest",
                                value:
                                    "${CommonUtilities.AppCurrency} ${controller.formatAmount(controller.totalInterest.toDouble())}",
                              ),
                            ],
                          ),
                        ),
            
                        Container(
                          height:kIsWeb? 110.h: 40.h,
                          width: double.infinity,
                          padding: EdgeInsets.all(8.sp),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.sp),
                            color: AppColors.black,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Total Payable",
                                style: TextStyle(
                                  fontSize: kIsWeb? 8.sp: 16.sp,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                "${CommonUtilities.AppCurrency} ${controller.formatAmount(controller.totalPayment())}",
                                style:  TextStyle(
                                  fontSize: kIsWeb? 8.sp :18.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        20.verticalSpace,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _infoItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: AppColors.darkGrey),
        ),
        5.verticalSpace,
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _sliderSection({
    required String title,
    required String value,
    required Widget slider,
    required String minValue,
    required String maxValue,
    required int maxLength,
    required EmiFieldType type,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: AppColors.grey),
        color: AppColors.kffffff,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal:kIsWeb? 8.w: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style:  TextStyle(
                      fontSize:kIsWeb? 5.sp: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () => _getFocusNode(type).requestFocus(),
                  child: Container(
                    height:kIsWeb? 40.h: 38.h,
                    width:kIsWeb? 70.w: 120.w,
                    padding: EdgeInsets.only(right: kIsWeb? 8.sp: 15.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.sp),
                      border: Border.all(color: AppColors.grey),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        8.horizontalSpace,
                        if (type == EmiFieldType.loanAmount)
                          Text(
                            '${CommonUtilities.AppCurrency} ',
                            style: TextStyle(
                              fontSize: kIsWeb? 5.sp: 14.sp,
                              color: AppColors.black,
                            ),
                          ),
                        IntrinsicWidth(
                          child: TextField(
                            controller: _getController(type),
                            maxLength: maxLength,
                            focusNode: _getFocusNode(type),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: kIsWeb? 5.sp : 14.sp,
                              color: AppColors.black,
                            ),
                            inputFormatters: [
                              if (type == EmiFieldType.loanAmount)
                                FilteringTextInputFormatter
                                    .digitsOnly, 
                              if (type == EmiFieldType.interestRate)
                                FilteringTextInputFormatter.allow(
                                  RegExp(
                                    r'^\d*\.?\d{0,2}',
                                  ), 
                                ),
                              if (type == EmiFieldType.tenure)
                                FilteringTextInputFormatter
                                    .digitsOnly, 
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              counterText: "",
                            ),
                            onChanged: (val) {
                              double? parsed = double.tryParse(val);
                              if (parsed == null) return;

                              double min, max;
                              switch (type) {
                                case EmiFieldType.loanAmount:
                                  min = 0;
                                  max = 2000000;
                                  break;
                                case EmiFieldType.interestRate:
                                  min = 1;
                                  max = 30;
                                  break;
                                case EmiFieldType.tenure:
                                  min = 1;
                                  max = 30;
                                  break;
                              }

                              double clamped = parsed.clamp(min, max);

                              if (parsed != clamped) {
                                final ctrl = _getController(type);
                                ctrl.text = clamped.toInt().toString();
                                ctrl.selection = TextSelection.fromPosition(
                                  TextPosition(offset: ctrl.text.length),
                                );
                              }

                              switch (type) {
                                case EmiFieldType.loanAmount:
                                  controller.loanEMI(clamped);
                                  break;
                                case EmiFieldType.interestRate:
                                  controller.interestRate(clamped);
                                  break;
                                case EmiFieldType.tenure:
                                  controller.loanTenure(clamped);
                                  break;
                              }

                              controller.getCalculatedEmi(
                                controller.loanEMI.value,
                                controller.interestRate.value,
                                controller.loanTenure.value,
                              );
                            },
                          ),
                        ),
                        if (type == EmiFieldType.interestRate)
                          Text(
                            '%',
                            style: TextStyle(
                              fontSize:kIsWeb? 5.sp: 14.sp,
                              color: AppColors.black,
                            ),
                          )
                        else if (type == EmiFieldType.tenure)
                          Text(
                            'Y',
                            style: TextStyle(
                              fontSize:kIsWeb? 5.sp: 14.sp,
                              color: AppColors.black,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            10.verticalSpace,

            /// Slider
            slider,
            10.verticalSpace,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(minValue, style: TextStyle(fontSize: kIsWeb? 5.sp:14.sp)),
                Text(maxValue, style: TextStyle(fontSize: kIsWeb? 5.sp:14.sp)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _indicatorItem({
    required Color color,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        // Dot indicator
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),

        // Title
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),

        // Value
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class CustomThumbShape extends SliderComponentShape {
  final double radius;

  CustomThumbShape({this.radius = 10});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

  
    final fillPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

   
    final borderPaint =
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    canvas.drawCircle(center, radius, fillPaint);
    canvas.drawCircle(center, radius, borderPaint);
  }
}
