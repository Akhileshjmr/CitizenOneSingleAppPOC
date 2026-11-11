import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';

class StepPlaceholder extends StatelessWidget {
  final String title;
  const StepPlaceholder({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "$title Form Coming Soon...",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class FormButtons {
  static Widget navigation({
    required BuildContext context,
    GlobalKey<FormState>? formKey,
    VoidCallback? onPrevious,
    VoidCallback? onNext,
    VoidCallback? onSubmit,
  }) {
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 8),
        child: _buildButtons(
          context: context,
          formKey: formKey,
          onPrevious: onPrevious,
          onNext: onNext,
          onSubmit: onSubmit,
        ),
      ),
    );
  }

  static Widget _buildButtons({
    required BuildContext context,
    GlobalKey<FormState>? formKey,
    VoidCallback? onPrevious,
    VoidCallback? onNext,
    VoidCallback? onSubmit,
  }) {
    // Only Next button
    if (onPrevious == null && onSubmit == null && onNext != null) {
      return Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.btnBackground,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (formKey?.currentState?.validate() ?? false) {
              onNext!();
            } else {
              showCustomBottomPopup(
                context,
                "Please Fill all mandatory Fields ",
              );
            }
          },
          child: const Text("Next"),
        ),
      );
    }

    // Previous + Submit
    if (onPrevious != null && onSubmit != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.black,
            ),
            onPressed: onPrevious,
            child: const Text("Previous"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.btnBackground,
              foregroundColor: Colors.white,
            ),
            onPressed: onSubmit,
            child: const Text("Submit"),
          ),
        ],
      );
    }

    // Default: Previous + Next
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black,
          ),
          onPressed: onPrevious,
          child: const Text("Previous"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.btnBackground,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (formKey?.currentState?.validate() ?? false) {
              onNext!();
            } else {
              showCustomBottomPopup(
                context,
                "Please Fill all mandatory Fields ",
              );
            }
          },
          child: const Text("Next"),
        ),
      ],
    );
  }
}

