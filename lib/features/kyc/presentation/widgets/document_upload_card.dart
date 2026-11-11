import 'package:citizenone_app/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/design_system/atoms/app_button.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:flutter/material.dart';

class DocumentUploadCard extends StatelessWidget {
  final String title;
  final bool isUploaded;
  final VoidCallback onTap;
  final bool isRequired;
  final String fileName;

  const DocumentUploadCard({
    super.key,
    required this.title,
    required this.isUploaded,
    required this.onTap,
    this.isRequired = false,
    this.fileName = "",
  });

  @override
  Widget build(BuildContext context) {
    {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: isUploaded ? 80 : 105,
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFC6C6C6)),
          ),
          child: (isUploaded)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.cloud_upload,
                        color: AppColors.surface,
                        size: 10,
                      ),
                    ),
                    HSpace(1),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                title,
                                style: AppTextStyle.bodySmall,
                                overflow: TextOverflow.clip,
                              ),

                              Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                                size: 14,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            fileName,
                            style: AppTextStyle.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    AppButton(
                      text: "Replace",
                      onPressed: onTap,
                      backgroundColor: AppColors.surface,
                      variant: AppButtonVariant.outline,
                      borderColor: AppColors.primary,
                      textColor: AppColors.black,
                      width: 80,
                      height: 30,
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      icon: const Icon(
                        Icons.upload,
                        color: AppColors.surface, // icon color
                      ),
                      iconSize: 20,
                      onPressed: onTap,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Upload $title",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          if (isRequired)
                            const TextSpan(
                              text: " *",
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      "png, jpg, doc, pdf accepted",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
        ),
      );
    }
  }
}
