import 'package:citizenone_app/modules/agrinet/app/data/model/farmer_group/farmer_list.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_apptranslation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

mixin AddFarmerGroupVariables {
  AgApptranslation agApptranslation = AgApptranslation();
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();

  RxBool isLoading = false.obs;

  RxList<FarmerDetail> farmerList = <FarmerDetail>[].obs;

  List<FarmerDetail> allFarmers = [];

  RxList selectedFarmerList = [].obs;
}
