import 'package:get/get.dart';

import '../../../data/local/store/user_provider.dart';
import '../../../data/model/loan/auto/Orders.dart';
import '../../../data/model/loan/common_paging_req.dart';
import '../../../data/model/loan/paging_req.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../data/remote/provider/order_service.dart';

class AutoOrdersController extends GetxController {
  final count = 0.obs;

  RxBool isLoading = false.obs;
  RxList<Orders?> arrOrders = <Orders>[].obs;
  RxList<Orders?> arrInProcessOrders = <Orders>[].obs;

  RxString searchText = ''.obs;

  int pageNumOrder = 1;
  int pageNumInProcessOrder = 1;
  String args = '';
  RxBool isFromOrderScreen = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments[0] != null) {
      if (Get.arguments[0] is bool) {
        isFromOrderScreen(Get.arguments[0] as bool);
      } else if (Get.arguments[1] is String) {
        args = Get.arguments[1] as String;
      }
    }
    getOrderHistory();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> getOrderHistory() async {
    isLoading(true);

    try {
      isLoading(true);
      final requestParams = {
        'paging': <String, dynamic>{
          'pageNum': 0,
          'recsPerPage': 0,
          'sortByType': 'ASC',
          'totalPages': 0,
          'totalRecs': 0,
        },
        'reqSecureKey': UserProvider.currentUser?.addiParams?[0] ?? '',
      };

      arrOrders(
        await OrderService.getAutoOrderHistory(
          Get.arguments[1].toString().toUpperCase() == 'AUTO'
              ? ApiEndPoints.autoOrder
              : ApiEndPoints.realEstateOrder,
          requestParams,
        ),
      );
    } finally {
      isLoading(false);
    }
    // arrOrders?.value?.addAll(resp?.orders ?? <OrderBasicResp>[]);
  }

  Future<void> getInProcessOrderHistory() async {
    arrInProcessOrders = <Orders>[].obs;

    final CommonPagingReq commonPagingReq = CommonPagingReq();
    final PagingReq paging = PagingReq();
    paging.pageNum = pageNumInProcessOrder;
    paging.recsPerPage = 10;
    commonPagingReq.paging = paging;
    commonPagingReq.reqSecureKey =
        UserProvider.currentUser?.addiParams?[0] ??
        ''; //StaticValueConstant.UserFilterVal;
    commonPagingReq.filterVal = '';
    isLoading(true);
    // arrInProcessOrders?.addAll(await OrderService.getInProcessOrderHistory(
    //     ApiEndPoints.autoInProcessOrder, commonPagingReq.toJson()));
    isLoading(false);
  }
}
