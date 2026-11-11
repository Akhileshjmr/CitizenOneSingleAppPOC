import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/model/loan/auto_loan/Order.dart';
import '../../../data/model/loan/offer/offer_letter_response.dart';
import '../../../data/remote/provider/order_service.dart';

class AutoLoanOrderStatusController extends GetxController {
  RxBool isLoading = true.obs;

  /// Store ONE selected Order item
  late Order loanItem;

  /// Adding Rx variable for offer letter
  Rx<OfferLetterResponse?> offerLetterResponse = Rx<OfferLetterResponse?>(null);
  RxBool isLoadingOfferLetter = false.obs;
  RxString pdfUrl = ''.obs;

  String orderKey = '';
  String categoryType = '';
  bool isLoanStatus = true;

  @override
  void onInit() {
    super.onInit();

    try {
      if (Get.arguments != null && Get.arguments is Order) {
        loanItem = Get.arguments as Order;

        /// ✅ derive values
        orderKey = loanItem.loanAppNum!;
        categoryType = loanItem.categoryType ?? '';
        isLoanStatus = true;
      } else {
        loanItem = Order(
          bankLogo: '',
          bankName: 'Unknown Bank',
          loanAppNum: '',
          loanAmount: 0.0,
        );

        orderKey = '';
        categoryType = '';
        isLoanStatus = true;
      }
    } catch (_) {
      orderKey = '';
      categoryType = '';
      isLoanStatus = true;
    }
    fetchOfferLetter();
    isLoading(false);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchOfferLetter() async {
    try {
      isLoadingOfferLetter(true);

      final String loanAppNum = loanItem.loanAppNum ?? '';

      if (loanAppNum.isEmpty) {
        appSnackbar(
          message: 'Order reference not found',
          snackbarState: SnackbarState.warning,
        );
        return;
      }

      final Map<String, dynamic> req = {"reqSecureKey": loanAppNum};

      offerLetterResponse.value = await OrderService.getOfferLetter(req);

      final String? relativeUrl =
          offerLetterResponse.value?.offerLetter?.urlAction?.url;

      if (relativeUrl != null && relativeUrl.isNotEmpty) {
        /// ✅ SAME AS IMAGE HANDLING
        pdfUrl.value = relativeUrl.addBaseUrl;
      } else {
        /*appSnackbar(
          message: 'Offer letter URL not found in response',
          snackbarState: SnackbarState.warning,
        );*/
        pdfUrl.value = '';
      }
    } catch (e) {
      /* appSnackbar(
        message: 'Error fetching offer letter',
        snackbarState: SnackbarState.warning,
      );*/
      pdfUrl.value = '';
    } finally {
      isLoadingOfferLetter(false);
    }
  }

  // Get the offer letter URL with base URL already added
  String? getOfferLetterUrl() {
    if (pdfUrl.value.isNotEmpty) {
      return pdfUrl.value;
    }
    return null;
  }

  // Check if offer letter is available
  bool get hasOfferLetter => getOfferLetterUrl()?.isNotEmpty ?? false;
}
