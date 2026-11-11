import 'package:citizenone_app/modules/agency_banking/constants/AppStrings.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/BannerContent.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletTransaction.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_transaction_bloc/wallet_transaction_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_transaction_bloc/wallet_transaction_event.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/utils/ResponsiveLeftBanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../../../theme/app_gradients.dart';
import '../../../../../../../utils/RandomNumberGenerator.dart';

class ReceiveMoney extends StatefulWidget {
  final dynamic itemKey;
  final LoginUserReqResInfo loginResponse;
  final String transaction;

  const ReceiveMoney(
      {required this.loginResponse,
      required this.itemKey,
      required this.transaction});

  @override
  _ReceiveMoney createState() => _ReceiveMoney();
}

class _ReceiveMoney extends State<ReceiveMoney> {
  final Color primaryColor = const Color(0xff5c7d33);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  bool isSearchPerformed = false;

  String txnRefNo = RandomNumberGenerator.generateId('AGB', 13);

  void checkUniqueId(BuildContext context) {
    if (widget.transaction == 'Wallet') {
      CommWalletTransaction req = CommWalletTransaction();
      req.headerInfo = widget.loginResponse.headerInfo;
      req.uniqueId = mobileNumberController.text;
      req.moduleType = "RM";
      req.transId = txnRefNo;
      context.read<WalletTransactionBloc>().add(
            WalletTransactionSubmitted(req),
          );
    }
    if (widget.transaction == 'Account') {}
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    // Optional: your banner image list
    final List<BannerContent> banners = [
      BannerContent(
        imagePath: "assets/images/home_loan.jpg",
        title: AppStrings.bannerTitle,
        headline: AppStrings.bannerHeading,
        subtitle: AppStrings.bannerSubtitle,
        ctaText: AppStrings.bannerCreateText,
        onCtaPressed: () {
          AppLogger.debug('Banner CTA clicked');
        },
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.transaction == "Wallet"
            ? "Wallet Receive Money"
            : "Receive Money",
      ),
      body: Row(
        children: [
          // Left banner (only on non-mobile)
          if (!isMobile) ResponsiveLeftBanner(banners: banners),

          // Right main content (your existing layout)
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search Card
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "Enter Your Unique ID",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.fbLiteDark,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: mobileNumberController,
                                    decoration: InputDecoration(
                                      labelText: 'Unique ID',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.search),
                                        onPressed: () {
                                          checkUniqueId(context);
                                          setState(() {
                                            isSearchPerformed = true;
                                            nameController.text = "Likitha";
                                            mobileNumberController.text =
                                                "998877006";
                                            amountController.text = "1";
                                            remarksController.text = "gh";
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          if (isSearchPerformed)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildInfoCard("Transaction initiate by Agent", {
                                  "Name": "Likitha",
                                }),
                                buildInfoCard("From Information", {
                                  "Name": "Likitha",
                                  "Mobile Number": "998877006",
                                  "Amount": "1",
                                  "Remarks": "hhhh"
                                }),
                                const SizedBox(height: 12),
                                buildInfoCard("To Information", {
                                  "Name": "Bindu",
                                  "Mobile Number": "998800774",
                                }),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Proceed Button
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Opacity(
                    opacity: true
                        ? 1.0
                        : 0.5, // Set to false if you want it disabled visually
                    child: Container(
                      decoration: BoxDecoration(
                        gradient:
                            AppBackgrounds.widgetsBackground, // same gradient
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          "Check",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard(String title, Map<String, String> details) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                // fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            ...details.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    Text(
                      entry.value,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
