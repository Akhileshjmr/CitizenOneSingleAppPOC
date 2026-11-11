import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:get/get.dart';

import '../../../data/provider/FarmPlanService.dart';

class AboutUsController extends GetxController {
  final isLoading = true.obs;
  final title = ''.obs;
  final paragraphs = <String>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    loadFarmData();
  }

  void increment() => count.value++;

  Future<void> loadFarmData() async {
    try {
      isLoading.value = true;

      // Get group list first
      final formData = _createFormDataFromResponse();
      final farmData = await FarmPlanService.aboutUS(formData: formData);
      if (farmData?.chMessage?.isError == false) {
        _parseHtml(farmData?.reqSecureKey ?? '');
      }
    } catch (e) {
      print('Error loading farm data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _createFormDataFromResponse() {
    return {"filterVal": "${UserPrefs.user?.userId}"};
  }

  void _parseHtml(String html) {
    // Extract <h2> as title
    final titleMatch = RegExp(r'<h2>(.*?)</h2>', dotAll: true).firstMatch(html);
    title.value = titleMatch?.group(1)?.trim() ?? 'About Us';

    // Extract all <p>...</p> as paragraphs
    final pMatches = RegExp(r'<p>(.*?)</p>', dotAll: true).allMatches(html);
    paragraphs.assignAll(
      pMatches
          .map((m) => m.group(1) ?? '')
          .map((t) => t.replaceAll('\n', ' ').trim())
          .where((t) => t.isNotEmpty),
    );

    isLoading.value = false;
  }
}
