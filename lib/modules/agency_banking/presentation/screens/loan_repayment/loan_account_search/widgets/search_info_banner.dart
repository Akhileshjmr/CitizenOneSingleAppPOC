import 'package:flutter/material.dart';

import 'package:citizenone_app/modules/agency_banking/theme/app_theme_style.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';


/// Blue info banner: "Please provide at least the Loan Account Number or
/// Mobile Number to fetch your details."
class SearchInfoBanner extends StatelessWidget {
  final String? errorText;

  const SearchInfoBanner({super.key, this.errorText});

  @override
  Widget build(BuildContext context) {
    final bool isError = errorText != null;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isError ? const Color(0xFFFDECEC) : AppColors.infoBannerBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isError ? const Color(0xFFF5B5B5) : AppColors.infoBannerBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.info_outline,
            size: 20,
            color: isError ? const Color(0xFFD64545) : AppColors.infoBannerIcon,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: isError
                ? Text(
              errorText!,
              style: AppThemeStyle.infoBannerText.copyWith(
                color: const Color(0xFF9A2E2E),
              ),
            )
                : RichText(
              text: TextSpan(
                style: AppThemeStyle.infoBannerText,
                children: const [
                  TextSpan(text: 'Please provide at least the '),
                  TextSpan(
                    text: 'Loan Account Number',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: ' or '),
                  TextSpan(
                    text: 'Mobile Number',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: ' to fetch your details.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}