import 'dart:io';
import 'dart:typed_data';

import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/common/option.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/user/main_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:xml/xml.dart';

import '../../../components/ui/ag_snackbar.dart';
import '../../../components/utils/user_prefs.dart';
import '../../../data/model/common/ch_message.dart';
import '../../../data/model/onboarding/file_upload_response.dart';
import '../../../data/provider/onboard_service.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/ag_colors.dart';

class AddFarmerController extends GetxController {
  // State
  final isLoading = false.obs;
  final isBlocklisted = 'No'.obs;

  /// Dropdown selections
  final language = Rx<Option?>(null);
  final maritalStatus = Rx<Option?>(null);
  final nationality = Rx<Option?>(null);
  final stateOfOrigin = Rx<Option?>(null);
  final countryOfBirth = Rx<Option?>(null);
  final gender = Rx<Option?>(null);

  final mainResponse = Rx<MainResponse?>(null);

  final rxDueDate = Rxn<DateTime>();
  final rxAge = RxnInt();

  final filteredStates = <Option>[].obs;

  /// Text inputs
  final fullName = "".obs;
  final fatherName = "".obs;
  final dob = "".obs;
  final address = "".obs;
  String uid = "";

  /// Upload
  final profileDocId = 0.obs;
  final signatureDocId = 0.obs;
  final profilePhoto = Rx<File?>(null);
  final profilePhotoUrl = Rx<String?>(null);

  final RxInt docId = 0.obs;
  RxBool isUpdate = false.obs;

  /// Signature
  final showSignature = false.obs;
  final isSignatureDisabled = false.obs;

  final signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: AgColors.kBlack,
    exportBackgroundColor: AgColors.kWhite,
  );

  final ImagePicker picker = ImagePicker();

  /// Options lists
  List<Option> languageList = [];
  List<Option> maritalList = [];
  List<Option> nationalityList = [];
  List<Option> stateList = [];
  List<Option> countryList = [];
  List<Option> genderList = [];
  List<Option> idTypeList = [];
  List<Option> relationTypeList = [];
  List<Option> areaUnitsList = [];

  // TextEditingControllers for binding to TextFields
  final addressController = TextEditingController();
  final fullNameController = TextEditingController();
  final fatherNameController = TextEditingController();

  String farmerId = "";

  @override
  void onInit() {
    super.onInit();
    ever(rxDueDate, (date) {
      if (date != null) {
        rxAge.value = calculateAge(date);
      } else {
        rxAge.value = null;
      }
    });

    final args = Get.arguments;
    if (args != null) {
      farmerId = args["farmerId"];
      docId.value = args["docId"];
      isUpdate(true);
    }
    fetchData();
  }

  @override
  void onClose() {
    // dispose controllers
    addressController.dispose();
    fullNameController.dispose();
    fatherNameController.dispose();
    signatureController.dispose();
    super.onClose();
  }

  Future pickFromCamera() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.front,
    );
    if (picked != null) {
      profilePhoto.value = File(picked.path);
      profilePhotoUrl.value = null;
    }
  }

  void updateDOB(DateTime date) {
    rxDueDate.value = date;
    rxAge.value = calculateAge(date);
  }

  int calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;

    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }

    return age;
  }

  void parseAadharData(String xmlString) {
    try {
      final document = XmlDocument.parse(xmlString);
      final data = document.findElements("PrintLetterBarcodeData").first;

      fullName.value = data.getAttribute("name") ?? "";
      address.value = [
        data.getAttribute("loc"),
        data.getAttribute("vtc"),
        data.getAttribute("dist"),
        data.getAttribute("state"),
        data.getAttribute("pc"),
      ].where((e) => e != null && e.isNotEmpty).join(", ");

      final genderCode = data.getAttribute("gender") ?? "";

      gender.value = genderList.firstWhereOrNull(
        (g) =>
            (g.type ?? "").toLowerCase().startsWith(genderCode.toLowerCase()),
      );

      uid = data.getAttribute("uid") ?? "";
      final dobStr = data.getAttribute("dob") ?? "";
      dob.value = dobStr;

      if (dobStr.isNotEmpty) {
        try {
          final parsedDOB = _parseIndianDate(dobStr);

          // Update your state
          rxDueDate.value = parsedDOB;
          rxAge.value = calculateAge(parsedDOB);
        } catch (e) {
          debugPrint("DOB parsing failed: $e");
        }
      }

      // sync controllers
      fullNameController.text = fullName.value;
      addressController.text = address.value;
    } catch (e) {
      debugPrint("Aadhar parsing failed: $e");
    }
  }

  DateTime _parseIndianDate(String input) {
    final parts = input.split("/");
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    return DateTime(year, month, day);
  }

  Future<void> fetchDropDownData() async {
    await _executeSafely(() async {
      final res = await OnboardService.getOnboardData();
      mainResponse(res);

      languageList = res?.getOptionsByKey('LANGUAGE') ?? [];
      maritalList = res?.getOptionsByKey('MARITAL_STATUS') ?? [];
      nationalityList = res?.getOptionsByKey('COUNTRIES') ?? [];
      stateList = res?.getOptionsByKey('STATES') ?? [];
      countryList = nationalityList;
      genderList = res?.getOptionsByKey("GENDER_TYPE") ?? [];
      idTypeList = res?.getOptionsByKey("UNIQUE_ID") ?? [];
      relationTypeList = res?.getOptionsByKey("RELATIONSHIP_TYPE") ?? [];
      areaUnitsList = res?.getOptionsByKey("AREA_UNIT") ?? [];
    });
  }

  Future<List<int>?> getProfileImageArray() async {
    final photo = profilePhoto.value;
    return photo?.readAsBytes();
  }

  List<Option> getStatesByCountry(int countryId) {
    return stateList.where((state) {
      return state.other?.id == countryId;
    }).toList();
  }

  void onCountryChanged(Option country) {
    countryOfBirth.value = country;

    filteredStates.value = getStatesByCountry(country.id!);

    // reset selected state
    stateOfOrigin.value = null;
  }

  Future<void> saveFarmerData() async {
    if (!validateFarmerData()) return;

    await _executeSafely(() async {
      final photoBytes = await getProfileImageArray();

      final request = {
        "filterVal": UserPrefs.user?.userId,
        "id": docId.value,

        "generalDetails": {
          "address": address.value,
          "country": countryOfBirth.toJson(),
          "custPhoto": {
            "docId": profileDocId.value,
            "file": photoBytes,
            "fileName": "SIGNATURE_PROOF.jpg",
          },
          "custSignature": {"docId": signatureDocId.value},
          "dateOfBirth": rxDueDate.value?.millisecondsSinceEpoch,
          "gender": {"friendlyType": gender.value?.type},
          "language": language.toJson(),
          "maritalStatus": maritalStatus.toJson(),
          "name": fullName.value,
          "nationality": nationality.toJson(),
          "state": stateOfOrigin.toJson(),
          "surName": fatherName.value,
        },

        if (uid.toString().trim().isNotEmpty)
          "uniqIdDetail": [
            {
              "idNumber": uid,
              "idType": {
                "friendlyType": "Aadhar Id",
                "id": "",
                "type": "AADHAR_ID",
              },
            },
          ],

        "mobileScreen": "GENERAL_DETAILS",
      };

      MainResponse response = await OnboardService.saveFarmerData(
        request: request,
      );

      docId.value = docId.value == 0 ? (response.docs?.id ?? 0) : docId.value;

      if (!(response.message?.isError ?? false)) {
        Get.toNamed(Routes.ADD_DEPENDENT);
      }
    });
  }

  Future<ChMessage> uploadSignature(Uint8List signature) async {
    return await _executeSafely(() async {
      final response = await APIService.post(
        path: ApiEndPoints.farmerOnBoardDocUpload,
        data: {
          "generalDetails": {
            "custSignature": {
              "file": signature,
              "fileName": "SIGNATURE_PROOF.jpg",
            },
          },
        },
      );

      if (profilePhoto.value != null) {
        await uploadProfile();
      }

      MainResponse mainResponse = MainResponse.fromJson(response?.data ?? {});
      signatureDocId.value =
          mainResponse.docs?.generalDetails?.custSignature?.docId ?? 0;
      return ChMessage.fromJson(response?.data?['message'] ?? {});
    });
  }

  Future readDraft() async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.farmerOnBoardSearch,
        data: {
          "farmId": farmerId,
          "generalDetails": {"name": farmerId},
        },
      );
      final res = MainResponse.fromJson(response?.data ?? {});
      populateDraftData(res);
      print(res.toJson());
    } catch (err) {
      print(err);
    }
  }

  void populateDraftData(MainResponse draft) {
    final general = draft.docs?.generalDetails;

    if (general == null) return;

    /// Text fields
    fullName.value = general.name ?? "";
    fatherName.value = general.surName ?? "";
    address.value = general.address ?? "";
    dob.value = general.dateOfBirth ?? "";

    // update TextEditingControllers so TextFields reflect the values
    fullNameController.text = fullName.value;
    fatherNameController.text = fatherName.value;
    addressController.text = address.value;

    /// Convert DOB to DateTime → rxDueDate & age
    if (general.dateOfBirth != null && general.dateOfBirth!.isNotEmpty) {
      try {
        final parsed = DateTime.parse(general.dateOfBirth!);
        rxDueDate.value = parsed;
        rxAge.value = calculateAge(parsed);
      } catch (_) {}
    }

    /// Dropdown assignments (match Option.id first, then friendlyType)
    language.value = findOptionByIdOrFriendly(
      languageList,
      general.language?.id,
      general.language?.friendlyType,
    );
    maritalStatus.value = findOptionByIdOrFriendly(
      maritalList,
      general.maritalStatus?.id,
      general.maritalStatus?.type,
    );
    nationality.value = findOptionByIdOrFriendly(
      nationalityList,
      general.nationality?.id,
      general.nationality?.type,
    );
    stateOfOrigin.value = findOptionByIdOrFriendly(
      stateList,
      general.state?.id,
      general.state?.friendlyType,
    );
    countryOfBirth.value = findOptionByIdOrFriendly(
      countryList,
      general.country?.id,
      general.country?.friendlyType,
    );
    gender.value =
        findOptionByIdOrFriendly(
          genderList,
          general.gender?.id,
          general.gender?.friendlyType,
        ) ??
        genderList.first;

    /// Prefill profile image if exists
    final photoUrl = general.custPhoto?.docUrl.addBaseUrl;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      profilePhotoUrl.value = photoUrl;
      profileDocId.value = general.custPhoto?.docId ?? 0;
    }
  }

  /// Finds Option by id first; if not found, matches by friendlyType (case-insensitive).
  Option? findOptionByIdOrFriendly(
    List<Option> list,
    int? id,
    String? friendly,
  ) {
    if (list.isEmpty) return null;

    if (id != null) {
      try {
        return list.firstWhere((e) => e.id == id);
      } catch (_) {}
    }

    if (friendly != null && friendly.trim().isNotEmpty) {
      final key = friendly.trim().toLowerCase();
      try {
        return list.firstWhere(
          (e) => (e.type ?? "").trim().toLowerCase() == key,
        );
      } catch (_) {}
    }

    return null;
  }

  Future<ChMessage> uploadProfile() async {
    return await _executeSafely(() async {
      final bytes = await getProfileImageArray();

      final response = await APIService.post(
        path: ApiEndPoints.farmerOnBoardDocUpload,
        data: {
          "generalDetails": {
            "custPhoto": {"file": bytes, "fileName": "PROFILE_PIC.jpg"},
          },
        },
      );

      final upload = FileUploadResponse.fromJson(response?.data ?? {});
      profileDocId(upload.docs?.generalDetails?.custPhoto?.docId ?? 0);

      return ChMessage.fromJson(response?.data?['message'] ?? {});
    });
  }

  Future<T> _executeSafely<T>(Future<T> Function() task) async {
    try {
      isLoading(true);
      return await task();
    } catch (e, stack) {
      debugPrint("Error: $e");
      debugPrint(stack.toString());
      agSnackbar(title: "Error", msg: "Something went wrong");
      if (T == ChMessage) {
        return ChMessage(isError: true, message: "Operation failed") as T;
      }
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  bool validateFarmerData() {
    // Required text fields
    if (fullName.value.isEmpty) {
      _showError("Full Name is required");
      return false;
    }
    if (fatherName.value.isEmpty) {
      _showError("Father Name is required");
      return false;
    }

    if (gender.value == null) {
      _showError("Please select Gender");
      return false;
    }

    // Required date
    if (rxDueDate.value == null) {
      _showError("Date of Birth is required");
      return false;
    }

    if (address.value.isEmpty) {
      _showError("Address is required");
      return false;
    }

    // Required dropdown fields
    if (language.value == null) {
      _showError("Please select a Language");
      return false;
    }
    if (maritalStatus.value == null) {
      _showError("Please select Marital Status");
      return false;
    }

    if (countryOfBirth.value == null) {
      _showError("Please select Country of Birth");
      return false;
    }

    if (stateOfOrigin.value == null) {
      _showError("Please select State of Origin");
      return false;
    }
    if (nationality.value == null) {
      _showError("Please select Nationality");
      return false;
    }

    // Required profile image
    if (profilePhoto.value == null && profilePhotoUrl.value == null) {
      _showError("Profile Photo is required");
      return false;
    }

    if (!isSignatureDisabled.value) {
      _showError("Please upload signature");
      return false;
    }

    return true;
  }

  void _showError(String msg) {
    agSnackbar(title: "Missing Information", msg: msg);
  }

  Future<void> fetchData() async {
    try {
      await fetchDropDownData();
      if (farmerId.isNotEmpty) {
        await readDraft();
      }
    } catch (err) {
      debugPrint("fetchData error: $err");
    } finally {}
  }
}
