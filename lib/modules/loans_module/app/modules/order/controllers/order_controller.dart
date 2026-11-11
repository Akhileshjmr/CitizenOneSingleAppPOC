import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/local/store/user_provider.dart';
import '../../../data/model/loan/common_paging_req.dart';
import '../../../data/model/loan/order/order_basic_resp.dart';
import '../../../data/model/loan/order/order_history_resp.dart';
import '../../../data/model/loan/order/order_sub_item_info.dart';
import '../../../data/model/loan/paging_req.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../data/remote/provider/order_service.dart';

class OrderController extends GetxController {
  ScrollController scrollControllerOrder = ScrollController();
  ScrollController scrollControllerInProcess = ScrollController();

  RxList<OrderInfo> arrOrders = <OrderInfo>[].obs;
  RxList<OrderInfo?>? arrInProcessOrders = <OrderInfo>[].obs;

  List<String> arrType = ['Consumer Goods', 'Auto', 'Real Estate'];
  RxString searchText = ''.obs;
  bool isVisible(int index) =>
      arrOrders()[index].itemsInfo?.any(
        (OrderSubItemsInfo e) =>
            e.name?.toLowerCase().startsWith(searchText().toLowerCase()) ??
            false,
      ) ??
      false;
  RxString selectedOrderType = 'Consumer Goods'.obs;
  RxBool isLoading = false.obs;
  int pageNumOrder = 0;
  int totalpage = 0;
  int pageNumInProcessOrder = 1; // Assuming you have something like this
  var filteredOrders = RxList<OrderInfo>([]);
  RxBool isReverse = false.obs;

  final count = 0.obs;

  ///
  RxBool isFromOrderScreen = false.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      if (Get.arguments is bool) {
        isFromOrderScreen(Get.arguments as bool);
      }
    }
    getOrderHistory();
    // getInProcessOrderHistory();
    addPageListener();
    filteredOrders.value = arrOrders.value;
    // addPageListener();
    // scrollControllerOrder.addListener(addPageListener);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onWillPop() async {
    getOrders(selectedOrderType.value);
    // getOrdersProcess(selectedOrderType.value);
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void addPageListener() {
    scrollControllerOrder.addListener(() async {
      if (scrollControllerOrder.position.pixels ==
          scrollControllerOrder.position.maxScrollExtent) {
        // Scroll has reached the bottom
        if (!isLoading.value && pageNumOrder < totalpage - 1) {
          pageNumOrder += 1;
          await Future.delayed(Duration(seconds: 1));
          getOrderHistory();
        }
      } else if (scrollControllerOrder.position.pixels == 0) {
        // Scroll has reached the top
        if (!isLoading.value && pageNumOrder > 0) {
          pageNumOrder -= 1;
          await Future.delayed(Duration(seconds: 1));
          getOrderHistory();
        }
      }
      // if (scrollControllerOrder.position.maxScrollExtent ==
      //     scrollControllerOrder.position.pixels) {
      //   if (!isLoading.value && pageNumOrder < totalpage) {
      //     isLoading(!isLoading.value);
      //     // Perform event when user reach at the end of list (e.g. do Api call)
      //     pageNumOrder += 1;
      //     getOrderHistory();
      //   }
      // }
    });

    // scrollControllerInProcess.addListener(
    //       () {
    //     if (scrollControllerInProcess.position.maxScrollExtent ==
    //         scrollControllerInProcess.position.pixels) {
    //       if (isLoading.value == false) {
    //         isLoading(!isLoading.value);
    //         // Perform event when user reach at the end of list (e.g. do Api call)
    //         pageNumInProcessOrder += 1;
    //         getOrdersInProcess(selectedOrderType.value);
    //       }
    //     }
    //   },
    // );
  }

  void getOrders(String data) {
    selectedOrderType(data);
    if (data == arrType[0]) {
      getOrderHistory();
      // getInProcessOrderHistory();
    } else if (data == arrType[1]) {
      getOrder(ApiEndPoints.autoOrder);
      // getInProcessOrder(ApiEndPoints.autoInProcessOrder);
    } else if (data == arrType[2]) {
      getOrder(ApiEndPoints.realEstateOrder);
      // getInProcessOrder(ApiEndPoints.realEstateInProcessOrder);
    }
  }

  void getOrdersProcess(String data) {
    isLoading(true);
    try {
      selectedOrderType(data);
      if (data == arrType[0]) {
        getOrderHistory();
        getInProcessOrderHistory();
      } else if (data == arrType[1]) {
        getOrder(ApiEndPoints.autoOrder);
        getInProcessOrder(ApiEndPoints.autoInProcessOrder);
      } else if (data == arrType[2]) {
        getOrder(ApiEndPoints.realEstateOrder);
        getInProcessOrder(ApiEndPoints.realEstateInProcessOrder);
      }
    } finally {
      isLoading(false);
    }
  }

  void getOrdersInProcess(String data) {
    selectedOrderType(data);
    if (data == arrType[0]) {
      getInProcessOrderHistory();
    } else if (data == arrType[1]) {
      getInProcessOrder(ApiEndPoints.autoInProcessOrder);
    } else if (data == arrType[2]) {
      getInProcessOrder(ApiEndPoints.realEstateInProcessOrder);
    }
  }

  Future<void> getOrder(String url) async {
    Map<String, dynamic> req = {
      'reqSecureKey':
          ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
              ? (UserProvider.currentUser?.addiParams[0] ?? '')
              : '',
      'paging': pageNumOrder,
    };
    // orderHistoryResp(await OrderService.getOrderHistory(url, req));
    OrderHistoryList? resp = await OrderService.getOrderHistory(url, req);
    if (arrOrders!.isNotEmpty) {
      arrOrders!.clear();
    }
    arrOrders.addAll(resp?.orders ?? <OrderInfo>[]);
  }

  Future<void> getInProcessOrder(String url) async {
    Map<String, dynamic> req = {
      'reqSecureKey':
          ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
              ? (UserProvider.currentUser?.addiParams[0] ?? '')
              : '',
      'paging': pageNumInProcessOrder,
    };
    // inProcessOrderHistoryResp(await OrderService.getInProcessOrderHistory(url, req));
    // OrderHistoryResp? resp = await OrderService.getOrderHistory(url, req);
    // arrInProcessOrders?.addAll(resp?.orders ?? <OrderBasicResp>[]);
    if (arrInProcessOrders!.isNotEmpty) {
      arrInProcessOrders!.clear();
    }

    arrInProcessOrders?.addAll(
      await OrderService.getInProcessOrderHistory(url, req),
    );
  }

  Future<void> getOrderHistory() async {
    isLoading(true);

    try {
      isLoading(true);
      // CommonPagingReq commonPagingReq = CommonPagingReq();
      // PagingReq paging = PagingReq();
      // paging.pageNum = pageNumOrder;
      // paging.recsPerPage = 10;
      // commonPagingReq.paging = paging;
      // commonPagingReq.reqSecureKey = UserProvider.currentUser?.addiParams?[0] ??
      //     ''; //StaticValueConstant.UserFilterVal;
      // commonPagingReq.filterVal = '';
      // print(commonPagingReq.toJson());

      final requestParams = {
        'paging': <String, dynamic>{
          'pageNum': pageNumOrder,
          'recsPerPage': 10,
          'sortByType': 'ASC',
          'totalPages': 0,
          'totalRecs': 0,
        },
        'reqSecureKey':
            ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams[0] ?? '')
                : '',
      };

      // Map<String, dynamic> req = {"paging":{"pageNum":1,"recsPerPage":0,"sortByType":"ASC","totalPages":0,"totalRecs":0},"reqSecureKey":"3577"};
      final OrderHistoryList? resp = await OrderService.getOrderHistory(
        ApiEndPoints.orderHistoryOnline,
        requestParams,
      );
      /*for (var data in (resp?.orders ?? <OrderBasicResp>[])) {
        arrOrders?.add(data);
      }*/
      totalpage = resp?.paging?.totalPages ?? 0;
      if (arrOrders!.isNotEmpty) {
        arrOrders!.clear();
      }
      searchText('');
      filteredOrders.clear();
      arrOrders.call(resp?.orders ?? <OrderInfo>[]);
    } finally {
      isLoading(false);
    }
    // arrOrders?.value?.addAll(resp?.orders ?? <OrderBasicResp>[]);
  }

  Future<void> getInProcessOrderHistory() async {
    arrInProcessOrders = <OrderInfo>[].obs;

    final CommonPagingReq commonPagingReq = CommonPagingReq();
    final PagingReq paging = PagingReq();
    paging.pageNum = pageNumInProcessOrder;
    paging.recsPerPage = 10;
    commonPagingReq.paging = paging;
    commonPagingReq.reqSecureKey =
        ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
            ? (UserProvider.currentUser?.addiParams[0] ?? '')
            : '';
    ''; //StaticValueConstant.UserFilterVal;
    commonPagingReq.filterVal = '';
    isLoading(true);
    arrInProcessOrders?.addAll(
      await OrderService.getInProcessOrderHistory(
        ApiEndPoints.inProcessOrderHistoryOnline,
        commonPagingReq.toJson(),
      ),
    );
    isLoading(false);
  }

  Future<void> filterOrders(String searchTerm) async {
    // isReverse(true);
    final requestParams = {
      'paging': <String, dynamic>{
        'pageNum': pageNumOrder,
        'recsPerPage': 10,
        'sortByType': searchTerm,
        'totalPages': 0,
        'totalRecs': 0,
      },
      'reqSecureKey':
          ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
              ? (UserProvider.currentUser?.addiParams[0] ?? '')
              : '',
    };

    // Map<String, dynamic> req = {"paging":{"pageNum":1,"recsPerPage":0,"sortByType":"ASC","totalPages":0,"totalRecs":0},"reqSecureKey":"3577"};
    final OrderHistoryList? resp = await OrderService.getOrderHistory(
      ApiEndPoints.orderHistoryOnline,
      requestParams,
    );
    /*for (var data in (resp?.orders ?? <OrderBasicResp>[])) {
        arrOrders?.add(data);
      }*/
    totalpage = resp?.paging?.totalPages ?? 0;
    if (arrOrders!.isNotEmpty) {
      arrOrders!.clear();
    }
    searchText('');
    filteredOrders.clear();
    arrOrders.clear();
    arrOrders.call(resp?.orders ?? <OrderInfo>[]).reversed.toList();
    update();
  }

  Future<void> searchChanged(String value) async {
    if (value.isNotEmpty) {
      print('SearchText: ${value}');

      filteredOrders.value =
          arrOrders.value.where((OrderInfo? p0) {
            bool status = false;
            if ((p0?.itemsInfo?.length ?? 0) > 0) {
              for (int i = 0; i < (p0?.itemsInfo?.length ?? 0); i++) {
                if ((p0?.itemsInfo?[i].name ?? '').toLowerCase().contains(
                  value.toLowerCase(),
                )) {
                  status = true;
                } else {
                  status = false;
                }
              }
            } else {
              status = false;
            }
            return status;
          }).toList();
    }
  }
}
