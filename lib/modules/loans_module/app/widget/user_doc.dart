import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../app_environment.dart';
import '../data/constants/app_assets.dart';
import '../utils/app_colors.dart';

typedef UploadDocCallback = void Function();
typedef DeleteDocCallback = void Function();

class UserDoc extends StatelessWidget {
  final UploadDocCallback onUploadDoc;
  final DeleteDocCallback onDeleteDoc;
  final XFile? file;
  PlatformFile? docsFile;

  UserDoc({
    required this.file,
    this.docsFile,
    required this.onUploadDoc,
    required this.onDeleteDoc,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if ((file?.path ?? "") != "") {
      Widget docImage =
          kIsWeb ? Image.network(file!.path) : Image.file(File(file!.path));
      return Container(
        margin: const EdgeInsets.only(top: 20),
        color: AppColors.black,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              width: screenWidth - 40,
              height: screenWidth - 40,
              child: docImage,
            ),
            IconButton(
              onPressed: onDeleteDoc,
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      );
    } else if (docsFile != null &&
        (docsFile!.path != null ||
            (kIsWeb && docsFile!.name.isNotEmpty && docsFile!.name != ""))) {
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        width: screenWidth - 40,
        height: screenWidth - 40,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: screenWidth - 30,
              height: screenWidth - 30,
              child: Column(
                children: [
                  Container(
                    width: screenWidth - 100,
                    height: screenWidth - 100,
                    child: Image.asset(
                      AppAssets.icDoc,
                      package: AppEnvironment.packageName,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(docsFile?.name ?? '', style: kw400Black14),
                ],
              ),
            ),
            IconButton(
              onPressed: onDeleteDoc,
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.all(20),
        width: screenWidth - 40,
        height: screenWidth - 40,
        child: MaterialButton(
          onPressed: onUploadDoc,
          // child: upload,
        ),
      );
    }
  }
}
