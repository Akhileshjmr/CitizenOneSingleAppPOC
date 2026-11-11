import 'dart:convert';

import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_alert_dialogue.dart';
import '../../../data/model/common/option.dart';
import '../../../data/model/farmPlan/PalCreationResp.dart';
import '../../../data/model/farmPlan/PalRequest.dart';
import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../data/provider/FarmPlanService.dart';

class PalCreationController extends GetxController {
  //TODO: Implement PalCreationController

  Rx<PalcreationResp?> palCreation = PalcreationResp().obs;
  List<SelectOptionList> get optionLists =>
      palCreation.value?.selectOptionList ?? [];

  // Text fields
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final userNameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final dobCtrl = TextEditingController(); // <- for AgTextField DOB

  final selectedBranch = RxnString();

  // Date of birth
  final dob = Rxn<DateTime>();

  final RxBool isLoading = false.obs;

  // Gender
  final gender = ''.obs; // "M" / "F"

  void onInit() {
    super.onInit();
    loadFarmData();
  }

  Future<void> pickDob(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: dob.value ?? DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF3E5A2F)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dob.value = picked;
      dobCtrl.text =
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';
    }
  }

  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    userNameCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    dobCtrl.dispose();
    super.onClose();
  }

  Future<void> loadFarmData() async {
    try {
      isLoading.value = true;

      final farmData = await FarmPlanService.getPalCreation();
      palCreation.value = farmData;
    } catch (e) {
      print("Error loading farm data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Extract Dropdown values
  List<String> getOptionNames(String key) {
    final list = optionLists.firstWhere(
      (e) => e.key == key,
      orElse: () => SelectOptionList(key: key, options: []),
    );

    return (list.options ?? [])
        .map((o) => o.friendlyType ?? o.type ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  /// Get selected option object (ID + name)
  Option? getOptionByFriendlyName(String key, String? selected) {
    if (selected == null) return null;

    final list = optionLists.firstWhere(
      (e) => e.key == key,
      orElse: () => SelectOptionList(key: key, options: []),
    );

    final options = list.options ?? [];

    return options.firstWhere(
      (o) => o.friendlyType == selected || o.type == selected,
      orElse: () => Option(type: selected, friendlyType: selected),
    );
  }

  Future<void> onSignUp() async {
    // Validate fields first
    if (!_validateFields()) {
      return;
    }

    // Check if password and confirm password match
    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      _showError('Password and Confirm Password do not match');
      return;
    }

    // Check if branch is selected
    if (selectedBranch.value!.isEmpty) {
      _showError('Please select a home branch');
      return;
    }

    // Check mobile number length
    String mobileNumber = mobileCtrl.text.trim().replaceAll(
      RegExp(r'[^\d]'),
      '',
    );
    if (mobileNumber.length < 10) {
      _showError('Please enter a valid 10-digit mobile number');
      return;
    }

    // Create request body
    final request = createRequestBody();

    // Convert to JSON for debugging
    print('Request Body: ${json.encode(request.toJson())}');
    final farmData = await FarmPlanService.palSignUp(
      formData: request.toJson(),
    );
    if (farmData?.chMessage?.isError == false) {
      AgAlertDialog.show(
        title: "Alert",
        message: "Registration completed successfully.",
        buttonText: "Okay",
        onOk: () {
          Get.back();
        },
      );
    } else {
      agSnackbar(
        title: farmData?.chMessage?.dispType ?? 'Alert',
        msg:
            farmData?.chMessage?.message ??
            'Something went wrong! Please try again later',
      );
    }
  }

  // Validation
  bool _validateFields() {
    if (firstNameCtrl.text.isEmpty) {
      _showError('Please enter first name');
      return false;
    }
    if (lastNameCtrl.text.isEmpty) {
      _showError('Please enter last name');
      return false;
    }
    if (dobCtrl.text.isEmpty) {
      _showError('Please select date of birth');
      return false;
    }
    if (emailCtrl.text.isEmpty || !GetUtils.isEmail(emailCtrl.text.trim())) {
      _showError('Please enter a valid email');
      return false;
    }

    String mobile = mobileCtrl.text.trim().replaceAll(RegExp(r'[^\d]'), '');
    if (mobile.isEmpty || mobile.length < 10) {
      _showError('Please enter a valid mobile number');
      return false;
    }

    if (userNameCtrl.text.isEmpty) {
      _showError('Please enter username');
      return false;
    }
    if (passwordCtrl.text.isEmpty || passwordCtrl.text.length < 6) {
      _showError('Password must be at least 6 characters');
      return false;
    }
    if (confirmPasswordCtrl.text.isEmpty) {
      _showError('Please confirm password');
      return false;
    }

    return true;
  }

  // Method to create request body
  MainRequest createRequestBody() {
    // Get the selected branch option
    GdbLookUpForm? selectedBranchForm;

    if (selectedBranch.value!.isNotEmpty) {
      final option = getOptionByFriendlyName(
        'HOME_BRANCH_LIST',
        selectedBranch.value,
      );
      if (option != null) {
        selectedBranchForm = GdbLookUpForm(
          friendlyType: option.friendlyType,
          id: option.id,
          type: option.type,
        );
      }
    }

    // Format gender - from 'M'/'F' to 'MALE'/'FEMALE'
    String formattedGender = 'MALE'; // Default
    if (gender.value == 'F') {
      formattedGender = 'FEMALE';
    }

    // Format mobile number - remove any non-digits
    String mobileNumber = mobileCtrl.text.trim().replaceAll(
      RegExp(r'[^\d]'),
      '',
    );

    return MainRequest(
      comReq: ComReq(reqSecureKey: UserPrefs.user?.userId.toString() ?? ""),
      dob: dobCtrl.text.trim(),
      firstName: firstNameCtrl.text.trim(),
      gdbLookUpForm: selectedBranchForm,
      gender: formattedGender,
      lastName: lastNameCtrl.text.trim(),
      mailId: emailCtrl.text.trim(),
      mobNum: mobileNumber,
      secParam: SecParam(
        confPword: confirmPasswordCtrl.text.trim(),
        pwd: passwordCtrl.text.trim(),
        userName: userNameCtrl.text.trim(),
      ),
    );
  }

  // Helper methods
  void _showError(String message) {
    agSnackbar(title: 'Error', msg: message, backgroundColor: AgColors.warning);
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
