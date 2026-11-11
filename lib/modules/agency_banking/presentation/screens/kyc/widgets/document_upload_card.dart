import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/button/kyc_custom_button.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocumentUploadCard extends StatelessWidget {
  final String title;
  final bool isUploaded;
  final VoidCallback onTap;
  final bool isRequired;
  final String fileName;

  const DocumentUploadCard(
      {super.key,
      required this.title,
      required this.isUploaded,
      required this.onTap,
      this.isRequired = false,
      this.fileName = ""});

  @override
  Widget build(BuildContext context) {
    {
      return GestureDetector(
        onTap: onTap,
        child: Container(
            height: isUploaded ? 80.h : 105.h,
            width: double.infinity,
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10.sp),
              border: Border.all(
                  color: const Color(0xFFC6C6C6),)
            ),
            child: (isUploaded)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          color: AppColors.teal1,
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        child: Icon(
                          Icons.cloud_upload,
                          color: AppColors.white,
                          size: 15.sp,
                        ),
                      ),
                      3.horizontalSpace,
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                3.horizontalSpace,
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.green,
                                  size: 14.sp,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              fileName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppButton(
                        title: "Replace",
                        onTap: onTap,
                        backgroundColor: AppColors.white,
                        isOutlined: true,
                        outlineColor: AppColors.teal1,
                        width: 98.w,
                        height: 30.h,
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.lightGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        icon: const Icon(
                          Icons.upload,
                          color: AppColors.black, // icon color
                        ),
                        iconSize: 20.sp,
                        onPressed: onTap,
                      ),
                      RichText(
                        text: TextSpan(
                          text: title,
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
                            fontSize: 12.sp, color: AppColors.darkGray),
                      )
                    ],
                  )),
      );
    }
  }
}
