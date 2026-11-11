import 'package:get/get.dart';

import '../controllers/crop_suggestion_controller.dart';

class CropSuggestionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CropSuggestionController>(
      () => CropSuggestionController(),
    );
  }
}
