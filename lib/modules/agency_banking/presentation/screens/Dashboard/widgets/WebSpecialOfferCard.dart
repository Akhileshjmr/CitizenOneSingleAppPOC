import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/loans_module/app/loans_module.dart';

/// Promotional card matching the web dashboard mockup. Its "Apply Now"
/// action reuses the same real Personal Loan entry point already wired in
/// CustomDrawer, so this stays a real navigation rather than a dead button.
class WebSpecialOfferCard extends StatelessWidget {
  final LoginUserReqResInfo loginResponse;

  const WebSpecialOfferCard({super.key, required this.loginResponse});

  @override
  Widget build(BuildContext context) {
    final firstName = loginResponse.loginUserInfo.firstName;
    final greetingName =
        (firstName != null && firstName.isNotEmpty) ? firstName : "You";

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20, top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.k613AF5.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.k613AF5, size: 18),
              const SizedBox(width: 8),
              const Text(
                "Special Offer: Personal Loans",
                style: TextStyle(
                  color: AppColors.k613AF5,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "$greetingName, you qualify for a low-interest personal loan. Apply instantly today!",
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () {
              LoansModule.openPlHistoryByAgentPhone(
                phoneNumber:
                    (loginResponse.loginUserInfo.mobileno ?? '').toString(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.k613AF5,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Apply Now"),
          ),
        ],
      ),
    );
  }
}
