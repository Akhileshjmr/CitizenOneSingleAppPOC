import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/add_farmer/controllers/add_farmer_controller.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_snackbar.dart';
import '../../../data/model/common/option.dart';
import '../../../data/provider/onboard_service.dart';
import '../../../routes/app_pages.dart';

class AddDependentController extends GetxController {
  // Visibility of form
  RxBool showForm = true.obs;
  RxBool isLoading = false.obs;

  // List of added dependents
  RxList<Map<String, dynamic>> dependents = <Map<String, dynamic>>[].obs;

  // Form fields
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  Rx<Option?> gender = Rx<Option?>(null);
  Rx<Option?> relation = Rx<Option?>(null);
  Rx<Option?> idType = Rx<Option?>(null);
  Rxn<DateTime> dob = Rxn<DateTime>();
  RxString occupation = "".obs;
  RxString income = "".obs;
  RxString phone = "".obs;
  RxString idNumber = "".obs;

  List<Option> genderList = [];
  List<Option> relationTypeList = [];
  List<Option> idTypeList = [];

  List<Option> dependentList = [
    Option(id: 1, type: "yes", friendlyType: "Yes"),
    Option(id: 2, type: "no", friendlyType: "No"),
  ];

  Rx<Option?> selectedDependent = Rx<Option?>(null);

  RxInt docId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    readMainResponse();
  }

  void readMainResponse() {
    final ctrl = Get.find<AddFarmerController>();

    genderList = ctrl.genderList;
    idTypeList = ctrl.idTypeList;
    relationTypeList = ctrl.relationTypeList;
    docId.value = ctrl.docId.value;
  }

  void addDependent() {
    // --------------------------
    // VALIDATION
    // --------------------------
    if (firstName.value.isEmpty) {
      _showError("Please enter first name");
      return;
    }
    if (lastName.value.isEmpty) {
      _showError("Please enter last name");
      return;
    }
    if (gender.value == null) {
      _showError("Please select gender");
      return;
    }
    if (dob.value == null) {
      _showError("Please select DOB");
      return;
    }
    if (relation.value == null) {
      _showError("Please select relationship");
      return;
    }
    if (occupation.value.isEmpty) {
      _showError("Please enter occupation");
      return;
    }
    if (income.value.isEmpty) {
      _showError("Please enter monthly income");
      return;
    }
    if (phone.value.isEmpty) {
      _showError("Please enter contact number");
      return;
    }
    if (idType.value == null) {
      _showError("Please select ID type");
      return;
    }
    if (idNumber.value.isEmpty) {
      _showError("Please enter ID number");
      return;
    }

    String formattedDob =
        "${dob.value!.day.toString().padLeft(2, '0')}/"
        "${dob.value!.month.toString().padLeft(2, '0')}/"
        "${dob.value!.year}";

    final newMember = {
      "contactNo": phone.value,
      "dob": formattedDob,
      "firstName": firstName.value,
      "gender": gender.toJson(),
      "idNumber": idNumber.value,
      "idType": idType.toJson(),
      "lastName": lastName.value,
      "monthlyInc": income.value,
      "occupation": occupation.value,
      "relationship": relation.toJson(),
    };

    // Add to list for UI
    dependents.add(newMember);

    // Hide form
    showForm.value = false;

    // Clear fields
    clearForm();
  }

  void _showError(String msg) {
    agSnackbar(title: "Missing Information", msg: msg);
  }

  void clearForm() {
    firstName.value = "";
    lastName.value = "";
    gender.value = null;
    relation.value = null;
    idType.value = null;
    dob.value = null;
    occupation.value = "";
    income.value = "";
    phone.value = "";
    idNumber.value = "";
    selectedDependent.value = null;
  }

  void removeDependent(int index) {
    dependents.removeAt(index);
  }

  Map<String, dynamic> buildRequestObject() {
    return {
      "filterVal": UserPrefs.user?.userId ?? '',
      "id": docId.value,
      "memberDetails": dependents.toList(),
      "mobileScreen": "DEPENDENT_DETAILS",
    };
  }

  Future<void> saveDependent(String requestType) async {
    try {
      if (dependents.isEmpty) {
        return agSnackbar(
          title: "Missing Information",
          msg: "Please add at least one dependent",
        );
      }
      isLoading(true);

      final response = await OnboardService.saveFarmerData(
        request: buildRequestObject(),
      );

      if (!(response.message?.isError ?? false)) {
        if (requestType == 'saveAsDraft') {
          Get.offAllNamed(Routes.HOME);
          agSnackbar(title: "Success", msg: "Dependent details saved as draft");
        } else {
          Get.toNamed(Routes.COMMUNICATION_DETAILS);
        }
      }
    } finally {
      isLoading(false);
    }
  }
}
