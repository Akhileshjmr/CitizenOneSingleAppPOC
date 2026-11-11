import 'package:citizenone_app/modules/agrinet/app/data/model/view_bids/adverise_history_list.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/view_bids/one_advertise_history.dart';
import 'package:get/get.dart';

mixin ViewBidsVariables {
  RxList<BidPlan> bidList = <BidPlan>[].obs;
  RxList<AdvertiseProduce> advertiseHistoryList = <AdvertiseProduce>[].obs;
  RxBool isLoading = false.obs;
  AdvertiseProduce? selectedAdvertiseProduce;
  RxList<AdvertiseProduce> allAdvertiseHistoryList = <AdvertiseProduce>[].obs;
}
