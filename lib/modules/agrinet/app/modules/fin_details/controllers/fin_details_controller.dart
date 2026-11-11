import 'dart:io';

import 'package:citizenone_app/modules/agrinet/app/data/model/user/main_response.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/add_farmer/controllers/add_farmer_controller.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/ui/ag_snackbar.dart';
import '../../../components/utils/user_prefs.dart';
import '../../../data/model/common/option.dart';
import '../../../data/model/fin_details/document_model.dart';
import '../../../data/model/fin_details/expense_model.dart';
import '../../../data/model/fin_details/income_model.dart';
import '../../../data/model/onboarding/file_upload_response.dart';
import '../../../data/provider/onboard_service.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../routes/app_pages.dart';

class FinDetailsController extends GetxController {
  /// tabs: 0=Income, 1=Expense, 2=Document
  var selectedTab = 0.obs;

  /// Expand/Collapse panel
  var isPanelOpen = false.obs;

  RxBool isLoading = false.obs;

  /// Dropdown sources
  List<Option> incomeTypeList = [];
  List<Option> expenseTypeList = [];
  List<Option> documentNameList = [];

  final profileDocId = 0.obs;
  final profilePhoto = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();

  /// Income fields (single entry form)
  final incomeType = Rx<Option?>(null);
  var incomeAmount = "".obs;

  /// Expense fields (single entry form)
  var expenseType = Rx<Option?>(null);
  var expenseAmount = "".obs;

  /// Document fields (single entry form)
  final docName = Rx<Option?>(null);
  Rxn<DateTime> issueDate = Rxn<DateTime>();
  Rxn<DateTime> expireDate = Rxn<DateTime>();

  /// Lists holding multiple items
  final RxList<IncomeModel> incomeList = <IncomeModel>[].obs;
  final RxList<ExpenseModel> expenseList = <ExpenseModel>[].obs;
  final RxList<DocumentModel> docList = <DocumentModel>[].obs;

  /// Optional ID field
  Rxn<int> someId = Rxn<int>();

  // ----------------- helpers -----------------

  bool get hasIncome => incomeList.isNotEmpty;
  bool get hasExpense => expenseList.isNotEmpty;
  bool get hasDocuments => docList.isNotEmpty;
  RxInt docId = 0.obs;

  @override
  void onInit() {
    readMainResponse();
    super.onInit();
  }

  void readMainResponse() {
    final controller = Get.find<AddFarmerController>();
    incomeTypeList =
        controller.mainResponse.value?.getOptionsByKey('INCOME_TYPE') ?? [];
    expenseTypeList =
        controller.mainResponse.value?.getOptionsByKey('EXPENSE_TYPE') ?? [];
    documentNameList =
        controller.mainResponse.value?.getOptionsByKey('DOCUMENT_NAMES') ?? [];
    docId.value = controller.docId.value;
  }

  void changeTab(int index) {
    selectedTab.value = index;
    isPanelOpen.value = false;
  }

  void togglePanel() {
    isPanelOpen.value = !isPanelOpen.value;
  }

  void setIssueDate(DateTime date) {
    issueDate.value = date;

    if (expireDate.value != null && expireDate.value!.isBefore(date)) {
      issueDate.value = null;
      agSnackbar(
        title: "Invalid Date",
        msg: "Expiry date cannot be earlier than issue date",
      );
    }
  }

  void setExpiryDate(DateTime date) {
    if (issueDate.value != null && date.isBefore(issueDate.value!)) {
      expireDate.value = null;
      agSnackbar(
        title: "Invalid Date",
        msg: "Expiry date cannot be earlier than issue date",
      );
      return;
    }
    expireDate.value = date;
  }

  // ---------------- add items ----------------

  void addIncome() {
    if (incomeType.value == null || incomeAmount.value.trim().isEmpty) {
      agSnackbar(title: "Missing", msg: "Please select income type and amount");
      return;
    }

    final amount = double.tryParse(incomeAmount.value) ?? 0.0;

    incomeList.add(IncomeModel(type: incomeType.value, amount: amount));

    // reset form
    incomeType.value = null;
    incomeAmount.value = "";
    isPanelOpen.value = false;
  }

  void addExpense() {
    if (expenseType.value == null || expenseAmount.value.trim().isEmpty) {
      agSnackbar(
        title: "Missing",
        msg: "Please select expense type and amount",
      );
      return;
    }

    final amount = double.tryParse(expenseAmount.value) ?? 0.0;

    expenseList.add(ExpenseModel(type: expenseType.value, amount: amount));

    expenseType.value = null;
    expenseAmount.value = "";
    isPanelOpen.value = false;
  }

  /// Option A: Controller manages file picking internally.
  /// Implement `_pickFileBytes()` to open file picker and return bytes.
  Future<void> addDocument() async {
    if (docName.value == null || issueDate.value == null) {
      agSnackbar(
        title: "Missing",
        msg: "Please select document name and issue date",
      );
      return;
    }

    // pick the file bytes (implement this):
    final bytes = await getProfileImageArray();
    if (bytes == null || bytes.isEmpty) {
      agSnackbar(title: "File", msg: "No file selected");
      return;
    }

    final doc = DocumentModel(
      name: docName.value,
      issueDate: issueDate.value,
      expiryDate: expireDate.value,
      fileBytes: bytes,
    );

    int docId = await uploadUserDoc(doc.toJson());
    doc.docId = docId;
    docList.add(doc);

    // reset form
    docName.value = null;
    issueDate.value = null;
    expireDate.value = null;
    isPanelOpen.value = false;
    profilePhoto(null);
  }

  // ---------------- remove items ----------------

  void removeIncome(IncomeModel item) => incomeList.remove(item);
  void removeExpense(ExpenseModel item) => expenseList.remove(item);
  void removeDocument(DocumentModel item) => docList.remove(item);

  // ---------------- save ----------------

  /// action can be 'saveAsDraft' or 'next' etc.
  Future<void> saveFinDetails(String action) async {
    if (incomeList.isEmpty) {
      agSnackbar(
        title: "Income Missing",
        msg: "Income list is empty. Please add at least one income.",
        backgroundColor: AgColors.warning,
      );
      return;
    }

    if (expenseList.isEmpty) {
      agSnackbar(
        title: "Expense Missing",
        msg: "Expense list is empty. Please add at least one expense.",
        backgroundColor: AgColors.warning,
      );
      return;
    }

    if (docList.isEmpty) {
      agSnackbar(
        title: "Document Missing",
        msg: "Document list is empty. Please upload at least one document.",
        backgroundColor: AgColors.warning,
      );
      return;
    }

    final request = {
      "filterVal": UserPrefs.user?.userId?.toString(),

      // Multiple documents
      "docDet": docList.map((doc) => doc.toJson()).toList(),

      // Multiple expenses
      "expDetails": expenseList.map((exp) => exp.toJson()).toList(),

      // ID only if needed
      "id": docId.value,

      // Multiple incomes
      "incDetails": incomeList.map((inc) => inc.toJson()).toList(),

      "mobileScreen": "LOAN_INCOME_FINANCIAL",
    };

    try {
      isLoading(true);
      final response = await OnboardService.saveFarmerData(request: request);
      if (!(response.message?.isError ?? false)) {
        if (action == 'saveAsDraft') {
          Get.offAllNamed(Routes.HOME);
          agSnackbar(title: "Success", msg: "Dependent details saved as draft");
        } else {
          Get.toNamed(Routes.LAND_AND_CORP_DETAILS);
        }
      } else {
        agSnackbar(
          title: "Error",
          msg: response.message?.message ?? "Unknown error",
        );
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: e.toString());
    } finally {
      isLoading(false);
    }
  }

  // --------------------------------------
  // PICK FROM CAMERA
  // --------------------------------------
  Future<void> pickFromCamera() async {
    try {
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        preferredCameraDevice: CameraDevice.front,
      );

      if (picked != null) {
        profilePhoto.value = File(picked.path);
      } else {
        agSnackbar(title: "Camera", msg: "No image captured");
      }
    } catch (e, s) {
      agSnackbar(msg: "Error", title: "Failed to capture image");
    }
  }

  // --------------------------------------
  // UPLOAD USER DOCUMENT
  // --------------------------------------
  Future<int> uploadUserDoc(Map<String, dynamic> docData) async {
    try {
      isLoading(true);
      final response = await APIService.post(
        path: ApiEndPoints.farmerOnBoardDocUpload,
        data: {
          "docDet": [docData],
        },
      );

      final upload = FileUploadResponse.fromJson(response?.data ?? {});
      return upload.docs?.docDet?.first.docId ?? 0;
    } catch (e, s) {
      agSnackbar(title: "Upload Failed", msg: "Unable to upload the document");
      return 0;
    } finally {
      isLoading(false);
    }
  }

  // --------------------------------------
  // CONVERT PROFILE IMAGE TO BYTE ARRAY
  // --------------------------------------
  Future<List<int>?> getProfileImageArray() async {
    try {
      final photo = profilePhoto.value;

      if (photo == null) {
        agSnackbar(title: "Photo Missing", msg: "No image selected");
        return null;
      }

      return await photo.readAsBytes();
    } catch (e, s) {
      agSnackbar(title: "Error", msg: "Failed to read image data");
      return null;
    }
  }
}
