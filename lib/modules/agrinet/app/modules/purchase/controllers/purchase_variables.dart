import 'package:citizenone_app/modules/agrinet/app/data/model/purchase/purchase_main.dart';
import 'package:get/get.dart';

mixin PurchaseVariables {
  RxList categoryLists =
      [
        {
          'image':
              'https://static.vecteezy.com/system/resources/previews/030/928/412/non_2x/rice-grain-and-paddy-bunch-logo-circle-frame-free-vector.jpg',
          'category_name': 'Havillah',
        },
        {
          'image':
              'https://as2.ftcdn.net/jpg/06/28/72/81/1000_F_628728186_UBJ1rk4InmXOiKyKM3IZRMjLGrTC2Bf8.jpg',
          'category_name': 'Farm',
        },
        {
          'image':
              'https://as2.ftcdn.net/jpg/06/28/72/81/1000_F_628728186_UBJ1rk4InmXOiKyKM3IZRMjLGrTC2Bf8.jpg',
          'category_name': 'Rice',
        },
      ].obs;
  RxBool isLoading = false.obs;

  RxList<String> bannerImageList = <String>[].obs;
  RxList<Category> categoryList = <Category>[].obs;
  // RxList<ImageSliders> = <ImageSliders> [].obs;
}
