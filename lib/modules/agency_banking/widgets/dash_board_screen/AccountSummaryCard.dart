import 'package:citizenone_app/modules/agency_banking/theme/app_gradients.dart';
import 'package:flutter/material.dart';
import '../../theme/colors/Appcolors.dart';

class AccountSummaryCard extends StatefulWidget {
  final String? title;
  final String? accountType;
  final String? accountNumber;
  final String? viewBalanceText;
  final String? createUpiText;
  final String? option1;
  final String? option2;
  final String? option3;
  final String? balance;

  const AccountSummaryCard({
    super.key,
    this.title,
    this.accountType,
    this.accountNumber,
    this.viewBalanceText,
    this.createUpiText,
    this.option1,
    this.option2,
    this.option3,
    this.balance,
  });

  @override
  State<AccountSummaryCard> createState() => _AccountSummaryCardState();
}

class _AccountSummaryCardState extends State<AccountSummaryCard> {
  bool showBalance = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppBackgrounds.cardBackground,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and bank logo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title ?? '',
                  style: const TextStyle(
                    color: AppColors.cardTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  'assets/images/jmr_logo.png',
                  height: 24,
                ),
              ],
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  if (widget.accountType != null)
                    Text(
                      widget.accountType!,
                      style: const TextStyle(color: AppColors.cardTextColor, fontSize: 14),
                    ),
                  const SizedBox(height: 4),
                  if (widget.accountNumber != null)
                    Text(
                      widget.accountNumber!,
                      style: const TextStyle(
                        color: AppColors.cardTextColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // View Balance or balance + close icon
            if (widget.viewBalanceText != null)
              Center(
                child: showBalance
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '₹${widget.balance ?? '0.00'}',
                      style: const TextStyle(
                        color: AppColors.cardTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showBalance = false;
                        });
                      },
                      child: const Icon(Icons.close, color: AppColors.cardTextColor),
                    ),
                  ],
                )
                    : OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.cardTextColor),
                    foregroundColor: AppColors.cardTextColor,
                  ),
                  onPressed: () {
                    setState(() {
                      showBalance = true;
                    });
                  },
                  child: Text(widget.viewBalanceText!),
                ),
              ),

            const SizedBox(height: 8),

            if (widget.createUpiText != null)
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    widget.createUpiText!,
                    style: const TextStyle(
                      color: AppColors.cardTextColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

            if (widget.option1 != null ||
                widget.option2 != null ||
                widget.option3 != null)
              const Divider(color: AppColors.cardTextColor, height: 32),

            if (widget.option1 != null ||
                widget.option2 != null ||
                widget.option3 != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (widget.option1 != null)
                    Text(widget.option1!, style: const TextStyle(color: AppColors.cardTextColor)),
                  if (widget.option1 != null && widget.option2 != null)
                    _dividerLine(),
                  if (widget.option2 != null)
                    Text(widget.option2!, style: const TextStyle(color: AppColors.cardTextColor)),
                  if (widget.option2 != null && widget.option3 != null)
                    _dividerLine(),
                  if (widget.option3 != null)
                    Text(widget.option3!, style: const TextStyle(color: AppColors.cardTextColor)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _dividerLine() => Container(
    height: 16,
    width: 1,
    color: AppColors.cardTextColor,
  );
}