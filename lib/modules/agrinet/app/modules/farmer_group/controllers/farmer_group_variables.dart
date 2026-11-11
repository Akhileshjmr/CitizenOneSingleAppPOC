import 'package:citizenone_app/modules/agrinet/app/data/model/farmer_group/farmer_group_list.dart';
import 'package:citizenone_app/modules/agrinet/app/data/provider/farmer_group_service.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_apptranslation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

mixin FarmerGroupVariables {
  AgApptranslation agApptranslation = AgApptranslation();
  FarmerGroupService farmerService = FarmerGroupService();
  TextEditingController searchController = TextEditingController();
  RxBool isLoading = false.obs;
  RxList<AgriFormerGroup> allFarmerGroups = <AgriFormerGroup>[].obs;
  RxList<AgriFormerGroup> farmerGroupList = <AgriFormerGroup>[].obs;
}
