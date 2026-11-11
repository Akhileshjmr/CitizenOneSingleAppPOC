import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:citizenone_app/modules/agrinet/app/data/provider/my_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/utils/user_prefs.dart';
import '../../../data/model/user/pal_res.dart';

class EditProfileController extends GetxController {
  final ProfileService profileService = ProfileService();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  Rx<PalRes?> pal = Rx<PalRes?>(null);

  final updateFormKey = GlobalKey<FormState>();

  final Rx<File?> pickedImage = Rx<File?>(null);
  final RxnString profileImageUrl = RxnString(null);

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// Load existing user data
  void loadData() {
    pal.value = UserPrefs.user?.palRes;

    nameCtrl.text = pal.value?.firstName ?? "";
    emailCtrl.text = pal.value?.email ?? "";

    final url = pal.value?.documents?.imgUrl;
    if (url != null && url.isNotEmpty) {
      profileImageUrl.value = url;
    }
  }

  /// Pick image
  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: source, imageQuality: 80);
      if (file != null) {
        pickedImage.value = File(file.path);
      }
    } catch (e) {
      log("Image pick error: $e");
    }
  }

  /// Update Profile
  Future<void> updateProfile() async {
    if (!updateFormKey.currentState!.validate()) return;

    try {
      isLoading(true);

      String? base64;

      if (pickedImage.value != null) {
        final imgFile = pickedImage.value!;
        final bytes = imgFile.readAsBytesSync();
        base64 = base64Encode(bytes);
      }

      await profileService.updateProfile(
        firstName: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        imageBase64: base64,
      );
    } catch (e) {
      log("Profile update error: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.onClose();
  }
}
