import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_snackbar.dart';
import '../../../components/utils/location_service.dart';
import '../../../data/provider/onboard_service.dart';
import '../../../routes/app_pages.dart';
import '../../add_farmer/controllers/add_farmer_controller.dart';

class CommunicationDetailsController extends GetxController {
  RxInt docId = 0.obs;
  RxString address = "".obs;
  RxString phone = "".obs;
  RxBool isLoading = false.obs;

  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    readMainResponse();
  }

  void readMainResponse() {
    final ctrl = Get.find<AddFarmerController>();
    docId.value = ctrl.docId.value;
  }

  Future<void> saveContactInfo(String requestType) async {
    try {
      final phoneNumber = phone.value.trim();

      if (address.value.isEmpty) {
        _showError("Please enter address");
        return;
      }

      if (phone.value.isEmpty) {
        _showError("Please enter contact number");
        return;
      }

      if (!RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber)) {
        _showError("Please enter a valid 10-digit phone number");
        return;
      }

      isLoading(true);
      Map<String, dynamic> req = {
        "filterVal": UserPrefs.user?.userId,
        "communDetails": {
          "phoneDetails": [
            {"number": phone.value},
          ],
          "residenceAddress": [
            {"address": address.value},
          ],
        },
        "id": docId.value,
        "mobileScreen": "LOAN_ACCOUNT_CONTACT_INFO",
      };

      final response = await OnboardService.saveFarmerData(request: req);

      if (!(response.message?.isError ?? false)) {
        if (requestType == 'saveAsDraft') {
          Get.offAllNamed(Routes.HOME);
          agSnackbar(title: "Success", msg: "Contact info saved as draft");
        } else {
          Get.toNamed(Routes.FIN_DETAILS);
        }
      }
    } finally {
      isLoading(false);
    }
  }

  void _showError(String msg) {
    agSnackbar(title: "Missing Information", msg: msg);
  }

  Future<void> getAddress() async {
    try {
      isLoading(true);

      final resAddress = await LocationService.getUserAddress();

      if (resAddress == "Permission denied" ||
          resAddress == "Address not found" ||
          resAddress.trim().isEmpty) {
        agSnackbar(title: "Location Error", msg: resAddress);
        return;
      }

      addressController.text = resAddress;
      address.value = resAddress;
    } catch (err) {
      agSnackbar(
        title: "Error",
        msg: "Something went wrong while fetching address",
      );
    } finally {
      isLoading(false);
    }
  }
}
