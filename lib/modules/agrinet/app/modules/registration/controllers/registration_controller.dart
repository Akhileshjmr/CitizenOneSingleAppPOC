import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_alert_dialogue.dart';
import '../../../components/ui/ag_snackbar.dart';
import '../../../data/model/common/option.dart';
import '../../../data/provider/my_profile_service.dart';
import '../../../routes/app_pages.dart';

class RegistrationController extends GetxController {
  RxBool isLoading = false.obs;
  String type = 'Buyer';

  // TextEditingControllers for all text fields
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  // Reactive variables for gender and date of birth
  Rxn<DateTime> dob = Rxn<DateTime>();
  Rx<Option?> gender = Rx<Option?>(null);

  List<Option> genderList = [
    Option(id: 1, type: "MALE", friendlyType: "Male"),
    Option(id: 2, type: "FEMALE", friendlyType: "Female"),
  ];

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }

  // VALIDATION
  void validateForm() {
    if (firstNameCtrl.text.trim().isEmpty) {
      return agSnackbar(
        title: "Missing information",
        msg: "Please enter first name",
      );
    }

    if (lastNameCtrl.text.trim().isEmpty) {
      return agSnackbar(
        title: "Missing information",
        msg: "Please enter last name",
      );
    }

    if (dob.value == null) {
      return agSnackbar(
        title: "Missing information",
        msg: "Please select date of birth",
      );
    }

    if (gender.value == null) {
      return agSnackbar(
        title: "Missing information",
        msg: "Please select gender",
      );
    }

    if (mobileCtrl.text.trim().isEmpty) {
      return agSnackbar(
        title: "Missing information",
        msg: "Please enter mobile number",
      );
    }

    if (passwordCtrl.text.trim().isEmpty) {
      return agSnackbar(
        title: "Missing information",
        msg: "Please enter password",
      );
    }

    if (passwordCtrl.text.trim() != confirmPasswordCtrl.text.trim()) {
      return agSnackbar(title: "Error", msg: "Passwords do not match");
    }

    registerUser();
  }

  // API CALL
  Future<void> registerUser() async {
    try {
      isLoading(true);

      final response = await ProfileService.userRegister(
        request: buildRequestObject(),
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return;
      }

      final chMsg = response.message;

      if (chMsg == null) {
        agSnackbar(title: "Error", msg: "Invalid server response");
        return;
      }

      // SUCCESS
      if (!(chMsg.isError ?? true)) {
        getMobileConfirmation();
        return;
      }

      if (chMsg.type == "USER_NAME_ALREADY_EXIST") {
        agSnackbar(title: "User Exists", msg: "This username already exists");
        return;
      }

      agSnackbar(title: "Error", msg: chMsg.message ?? "Something went wrong");
    } catch (e) {
      agSnackbar(title: "Exception", msg: e.toString());
    } finally {
      isLoading(false);
    }
  }

  // BUILD API REQUEST OBJECT
  Map<String, dynamic> buildRequestObject() {
    return {
      "comReq": {},
      "dob": formatDob(dob.value),
      "firstName": firstNameCtrl.text.trim(),
      "gender": gender.value?.type ?? "",
      "lastName": lastNameCtrl.text.trim(),
      "loginSocialType": type,
      "mailId": emailCtrl.text.trim(),
      "mobNum": mobileCtrl.text.trim(),
      "secParam": {
        "confPword": confirmPasswordCtrl.text.trim(),
        "pwd": passwordCtrl.text.trim(),
      },
    };
  }

  String formatDob(DateTime? date) {
    if (date == null) return "";
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  void getMobileConfirmation() {
    AgAlertDialog.confirm(
      title: "Verify Details",
      message: "Please confirm your mobile number ${mobileCtrl.text.trim()}",
      cancelText: "Cancel",
      okText: "Proceed",
      onConfirm: () {
        getOtp();
      },
    );
  }

  Future<void> getOtp() async {
    try {
      isLoading(true);

      final response = await ProfileService.getOtp(
        request: {
          "comReq": {},
          "secParam": {"userName": mobileCtrl.text.trim()},
        },
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to get OTP");
        return;
      }

      final otp = response.reqSecureKey;

      if (otp == null || otp.isEmpty) {
        agSnackbar(title: "Error", msg: "Invalid OTP received");
        return;
      }

      Get.toNamed(
        Routes.OTP,
        arguments: {"mobile": mobileCtrl.text.trim(), "otp": otp},
      );
    } catch (e) {
      agSnackbar(title: "Error", msg: e.toString());
    } finally {
      isLoading(false);
    }
  }

  void initData() {
    final args = Get.arguments;
    type = args['type'] ?? 'Buyer';
  }
}
