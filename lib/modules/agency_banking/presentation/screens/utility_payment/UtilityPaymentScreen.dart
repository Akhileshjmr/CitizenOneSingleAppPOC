import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/utility_payment/BillerDetailsScreen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/widgets/mobile_custom_tool_bar.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../utils/UICleanupHelper.dart';

class UtilityPaymentScreen extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
   UtilityPaymentScreen({ required this.loginResponse});

  @override
  State<UtilityPaymentScreen> createState() => _UtilityPaymentScreenState();
}

class _UtilityPaymentScreenState extends State<UtilityPaymentScreen> {
  final List<String> billers = [
    'Electricity Board',
    'Water Supply',
    'Gas Company',
    'Internet Provider',
    'Mobile Recharge',
    'Municipal Taxes'
  ];

  String? selectedBiller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Utility Payment"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          double padding = isMobile ? 16 : 32;
          double buttonHeight = isMobile ? 40 : 45;
          double fontSize = isMobile ? 14 : 16;

          return Center(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.all(padding),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Biller Name Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Biller Name',
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      items: billers
                          .map((biller) => DropdownMenuItem(
                        value: biller,
                        child: Text(biller),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBiller = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Pay by Cash Button
                    SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedBiller == null
                              ? AppColors.btnBackground.withOpacity(0.4)
                              : AppColors.btnBackground,
                          textStyle: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.bold),
                        ),
                        onPressed: selectedBiller == null
                            ? null
                            : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BillerDetailsScreen(loginResponse: widget.loginResponse,)),
                          );
                        },
                        child: Text(
                          'PAY BY CASH',
                          style: TextStyle(
                            color: selectedBiller == null
                                ? AppColors.white.withOpacity(0.5) // disabled
                                : AppColors.white, // enabled
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Pay by Account Button
                    SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedBiller == null
                              ? AppColors.btnBackground.withOpacity(0.4)
                              : AppColors.btnBackground,
                          textStyle: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.bold),
                        ),
                        onPressed: selectedBiller == null
                            ? null
                            : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BillerDetailsScreen(loginResponse:widget.loginResponse ,)),
                          );
                        },
                        child: Text(
                          'PAY BY ACCOUNT',
                          style: TextStyle(
                            color: selectedBiller == null
                                ? AppColors.white.withOpacity(0.5) // disabled
                                : AppColors.white, // enabled
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
