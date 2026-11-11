import 'dart:developer';

import 'package:citizenone_app/modules/agrinet/app/models/HomeResp/HomeImageResp.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';

import '../../../components/utils/user_prefs.dart';
import '../../../data/model/user/pal_res.dart';
import '../../../data/provider/my_profile_service.dart';

class MyProfileController extends GetxController {
  final ProfileService service = ProfileService();

  RxBool isLoading = false.obs;
  Rx<PalRes?> pal = Rx<PalRes?>(null);

  RxList<Slideimages> sliderImages = <Slideimages>[].obs;

  /// Carousel index
  RxInt currentIndex = 0.obs;

  /// Carousel controller
  final CarouselSliderController carouselController =
      CarouselSliderController();

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  /// Load both profile and images together
  Future<void> loadProfileData() async {
    try {
      isLoading(true);

      // Load profile data
      pal.value = UserPrefs.user?.palRes;

      // Load images
      final images = await ProfileService.fetchSliderImages();
      sliderImages.value = images;
    } catch (e) {
      log('Error loading profile data: $e');
    } finally {
      isLoading(false);
    }
  }
}
