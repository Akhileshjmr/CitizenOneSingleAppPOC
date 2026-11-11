import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../components/ui/ag_button.dart';
import '../data/extension/document_extension.dart';
import '../data/model/user/documents/Documents.dart';
import '../utils/app_colors.dart';

typedef UploadCallback = void Function(int index);

class UserDocumentList extends StatelessWidget {
  final int index;
  final Documents doc;
  final UploadCallback onPressedUpload;

  const UserDocumentList({
    super.key,
    required this.index,
    required this.doc,
    required this.onPressedUpload,
  });

  @override
  Widget build(BuildContext context) {
    final uploaded = doc.isUploaded;
    final mandatory = doc.isRequired;

    return GestureDetector(
      onTap: () => onPressedUpload(index),
      child: Container(
        margin: REdgeInsets.fromLTRB(20, 16, 20, 0),
        padding: REdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: mandatory && !uploaded ? Colors.red : Colors.grey.shade300,
          ),
        ),
        child: uploaded ? _uploadedView() : _uploadView(mandatory),
      ),
    );
  }

  Widget _uploadView(bool mandatory) {
    return Column(
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.upload_outlined, color: Colors.black54),
        ),

        16.verticalSpace,

        Text(
          "${doc.documentName?.type ?? ""}${mandatory ? " *" : ""}",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),

        8.verticalSpace,

        Text(
          "PNG • PDF • JPG",
          style: TextStyle(color: Colors.grey, fontSize: 13.sp),
        ),

        if (mandatory) ...[
          10.verticalSpace,
          Text(
            "Required",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ],
    );
  }

  Widget _uploadedView() {
    return Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.description, color: AppColors.k4B5563),
        ),

        12.horizontalSpace,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${doc.documentName?.type ?? ""}${doc.isRequired ? " *" : ""}",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
              ),

              4.verticalSpace,

              Text(
                doc.originalDocName ?? "",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey, fontSize: 13.sp),
              ),
            ],
          ),
        ),

        const Icon(Icons.check_circle, color: AppColors.k10B981),

        12.horizontalSpace,

        SizedBox(
          height: 36.h,
          width: Get.width * .26,
          child: AgButton(
            title: "Replace",
            isOutlined: true,
            onTap: () => onPressedUpload(index),
          ),
        ),
      ],
    );
  }
}
