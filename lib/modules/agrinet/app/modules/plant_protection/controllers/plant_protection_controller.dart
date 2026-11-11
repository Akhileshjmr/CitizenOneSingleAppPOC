import 'dart:developer';

import 'package:citizenone_app/modules/agrinet/app/data/provider/plant_protection_service.dart';
import 'package:get/get.dart';

import '../../../data/model/plant_protection/crop_model.dart';
import '../../../data/model/plant_protection/damage_model.dart';
import '../../../data/model/plant_protection/insect_model.dart';
import '../../../data/model/plant_protection/stage_model.dart';

class PlantProtectionController extends GetxController {
  // reactive state
  final RxList<CropModel> crops = <CropModel>[].obs;
  final RxList<SeedModel> seeds = <SeedModel>[].obs;
  final RxList<DamageModel> pests = <DamageModel>[].obs;
  final RxList<InsectModel> insects = <InsectModel>[].obs;
  final Rx<InsectModel?> details = Rx<InsectModel?>(null);

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final selectedCrop = Rx<CropModel?>(null);
  final selectedSeed = Rx<SeedModel?>(null);
  final selectedPests = Rx<DamageModel?>(null);
  final selectedInsecs = Rx<InsectModel?>(null);

  final PlantProtectionService service = PlantProtectionService();

  @override
  void onInit() {
    super.onInit();
    fetchCrops();
  }

  //---------------------------------------------------------------------------
  // 1) CROPS
  //---------------------------------------------------------------------------
  Future<void> fetchCrops() async {
    try {
      isLoading.value = true;
      final list = await service.fetchCropList();
      crops.assignAll(list);
    } catch (e, s) {
      error.value = e.toString();
      print(e);
      print(s);
    } finally {
      isLoading.value = false;
    }
  }

  //---------------------------------------------------------------------------
  // 2) STAGES
  //---------------------------------------------------------------------------
  Future<void> fetchSeeds(String serialNum) async {
    try {
      isLoading.value = true;
      final list = await service.fetchSeeds(serialNum);
      seeds.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  //---------------------------------------------------------------------------
  // 3) DAMAGE TYPES
  //---------------------------------------------------------------------------
  Future<void> fetchPests(String damageId) async {
    try {
      isLoading.value = true;
      final list = await service.fetchPests(damageId);
      pests.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  //---------------------------------------------------------------------------
  // 4) INSECTS
  //---------------------------------------------------------------------------
  Future<void> fetchInsects(String pestId, String damageName) async {
    try {
      isLoading.value = true;
      final list = await service.fetchInsects(pestId, damageName);
      insects.assignAll(list);
      log(list.toString());
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  //---------------------------------------------------------------------------
  // 5) INSECT DETAILS  (Corrected)
  //---------------------------------------------------------------------------
  Future<void> fetchDetails(String insNum) async {
    try {
      isLoading.value = true;

      final result = await service.fetchDetails(insNum);

      if (result != null) {
        details.value = result;
      } else {
        details.value = null;
        error.value = "No details found";
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
