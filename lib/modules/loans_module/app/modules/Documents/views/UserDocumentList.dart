import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:citizenone_app/modules/loans_module/app/data/constants/app_assets.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/user/documents/Documents.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import '../../../app_environment.dart';
import '../../../widget/user_document_list.dart';

typedef DeleteCallback = void Function(int index);
typedef LinkCallback = void Function(int index);

class UserDocumentList extends StatelessWidget {
  String type;
  String docName;
  int index;
  bool isUploaded;
  Documents? doc;
  final UploadCallback onPressedUpload;
  final DeleteCallback onPressedDelete;
  final LinkCallback onPressedlink;

  UserDocumentList(
    this.type,
    this.docName,
    this.index,
    this.isUploaded,
    this.doc,
    this.onPressedUpload,
    this.onPressedDelete,
    this.onPressedlink,
  );

  @override
  Widget build(BuildContext context) => Card(
    margin: REdgeInsets.fromLTRB(20, 16, 20, 0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
    child: Container(
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (doc?.originalDocName?.isNotEmpty == true)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.black,
                    size: 20,
                  ),
                ),

              // Title text
              Expanded(
                child: Text(
                  doc?.documentName?.type ?? '',
                  style: kTitleMetropolis16.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (doc?.originalDocName?.isEmpty == true ||
                  doc?.originalDocName == null)
                GestureDetector(
                  onTap: () {
                    onPressedUpload(index);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    child: SvgPicture.asset(
                      AppAssets.ic_doc_upload,
                      width: 30,
                      height: 30,
                      package: AppEnvironment.packageName,
                    ),
                  ),
                ),
            ],
          ),

          /// Show uploaded document details only if doc is uploaded
          if (doc?.originalDocName?.isNotEmpty == true) ...[
            10.verticalSpace,
            Stack(
              children: [
                GestureDetector(
                  onTap: () => onPressedDelete(index),
                  child: Container(
                    width: double.infinity,
                    padding: REdgeInsets.fromLTRB(12, 12, 52, 12),
                    decoration: BoxDecoration(
                      color: AppColors.grey,
                      border: Border.all(color: AppColors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.ic_document,
                          package: AppEnvironment.packageName,
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                docName,
                                style: kSubTitleMetropolis12.copyWith(
                                  color: AppColors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              4.verticalSpace,
                              const Text(
                                '25-11-2024',
                                style: kSubTitleMetropolis12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: GestureDetector(
                    onTap: () => onPressedDelete(index),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppAssets.ic_reupload_doc,
                        width: 20,
                        height: 20,
                        package: AppEnvironment.packageName,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}
