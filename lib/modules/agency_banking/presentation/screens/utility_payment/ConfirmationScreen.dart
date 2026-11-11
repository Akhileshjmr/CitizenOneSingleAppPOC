import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/widgets/mobile_custom_tool_bar.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_app_bar.dart';

class ConfirmationScreen extends StatelessWidget {
  final String accountNumber;
  final String currency;
  final String branch;
  final String amount;
  final String customerName;
  final String billerName;
  final String billerNumber;
  final String mobileNumber;

  const ConfirmationScreen({
    super.key,
    required this.accountNumber,
    required this.currency,
    required this.branch,
    required this.amount,
    required this.customerName,
    required this.billerName,
    required this.billerNumber,
    required this.mobileNumber,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> transactionData = {
      'Customer Name': customerName,
      'Account Number': accountNumber,
      'Branch Code': branch,
      'Mobile Number': mobileNumber,
      'Currency': currency,
      'Biller Name': billerName,
      'Biller Number': billerNumber,
      'Amount': amount,
    };

    return Scaffold(
      appBar: const CustomAppBar(title: "Confirmation Screen"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;
          double padding = isMobile ? 16 : 32;
          double spacing = isMobile ? 12 : 16;
          double fontSize = isMobile ? 14 : 16;
          double amountFontSize = isMobile ? 24 : 32;
          double buttonHeight = isMobile ? 40 : 50;

          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Center(
              child: Container(
                width: isMobile ? double.infinity : 500,
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Details & Amount Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Customer Details
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: transactionData.entries
                                .where((e) => e.key != 'Amount') // Exclude amount
                                .map(
                                  (e) => Padding(
                                padding: EdgeInsets.only(bottom: spacing / 2),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        fontSize: fontSize, color: Colors.black),
                                    children: [
                                      TextSpan(
                                          text: '${e.key}\n',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.grey)),
                                      TextSpan(
                                          text: e.value,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ),
                            )
                                .toList(),
                          ),
                        ),
                        SizedBox(width: spacing),
                        // Right: Amount Box
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              transactionData['Amount'] ?? '',
                              style: TextStyle(
                                  fontSize: amountFontSize,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing * 2),
                    SizedBox(
                      height: buttonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.btnBackground,
                          textStyle: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          // Final confirmation action
                        },
                        child: const Text('Proceed',style: TextStyle(color: AppColors.white),),
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
