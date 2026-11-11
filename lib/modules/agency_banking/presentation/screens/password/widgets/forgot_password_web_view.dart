import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Web-only (>=600px) view for the Forgot Password screen — desktop
/// (>=900px) shows the two-pane layout with the shared login banner image;
/// the 600-899px range shows the same form centered, no banner. Kept in its
/// own file/widget so mobile's layout can never be touched while editing
/// this. Same integration as the mobile flow: [mobileController] and
/// [onSendOtp] are wired to the exact same ForgotPasswordBloc dispatch used
/// there.
class ForgotPasswordWebView extends StatelessWidget {
  final TextEditingController mobileController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSendOtp;

  const ForgotPasswordWebView({
    super.key,
    required this.mobileController,
    required this.formKey,
    required this.onSendOtp,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    final Widget webForm = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/icons/citizenLogo.png",
              height: 90,
            ),
            const SizedBox(height: 32),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter your Mobile Number below — we'll verify your identity and guide you through resetting it.",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    "Mobile Number",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Decorative only — the backend request doesn't take
                      // a separate country code today.
                      Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderLight),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "+260",
                              style: TextStyle(
                                  fontSize: 15, color: AppColors.textPrimary),
                            ),
                            SizedBox(width: 4),
                            // Icon(Icons.keyboard_arrow_down,
                            //     size: 18, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: TextField(
                            controller: mobileController,
                            maxLength: 9,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style:
                                const TextStyle(color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              hintText: "Enter Mobile Number",
                              hintStyle:
                                  const TextStyle(color: AppColors.textHint),
                              counterText: "",
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.borderLight),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.borderLight),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: AppColors.k613AF5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.successBg,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield_outlined,
                            size: 18, color: AppColors.k613AF5),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Identity verified via your registered mobile number",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const StadiumBorder(),
                        backgroundColor: AppColors.k613AF5,
                      ),
                      onPressed: onSendOtp,
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Remember your password?  |  ",
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: AppColors.k613AF5,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
          ],
        ),
      ),
    );

    if (isDesktop) {
      return Row(
        children: [
          Expanded(
            child: Image.asset(
              "assets/web/image 88411.png",
              fit: BoxFit.fill,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(child: webForm),
            ),
          ),
        ],
      );
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: webForm,
        ),
      ),
    );
  }
}
