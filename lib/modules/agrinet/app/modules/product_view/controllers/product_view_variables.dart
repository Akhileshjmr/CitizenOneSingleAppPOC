import 'package:citizenone_app/modules/agrinet/app/data/model/purchase/category_view_response.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/purchase/product_view_response.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/purchase/purchase_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

mixin ProductViewVariables {
  RxList<Product> productLists = <Product>[].obs;
  RxList productlists =
      [
        {
          "image":
              "https://plus.unsplash.com/premium_photo-1675237626334-5cf9d9d8b30c?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          "name": "Badam",
          "currency": "\$",
          "price": 1200.0,
          "oldPrice": 1600.0,
          "subtitle": "High quality nuts",
          "tag": "@Almonds Grade A",
          "description":
              "Premium almonds — rich in protein and healthy fats. Sourced from trusted growers and lightly roasted for natural flavour.",
          "options": [
            {"title": "Badam (250 g)", "shortTitle": "250 g", "badge": "S"},
            {"title": "Badam (500 g)", "shortTitle": "500 g", "badge": "M"},
            {"title": "Badam (1 Kg)", "shortTitle": "1 Kg", "badge": "L"},
          ],
        },
        {
          "image":
              "https://images.unsplash.com/photo-1726771517475-e7acdd34cd8a?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          "name": "Cashew",
          "currency": "\$",
          "price": 999.0,
          "oldPrice": 1299.0,
          "subtitle": "Premium whole cashews",
          "tag": "@Cashew W320",
          "description":
              "Whole premium cashews with a delicate crunch and buttery taste. Ideal for snacking and cooking — handpicked and sun-dried.",
          "options": [
            {"title": "Cashew (200 g)", "shortTitle": "200 g", "badge": "S"},
            {"title": "Cashew (500 g)", "shortTitle": "500 g", "badge": "M"},
            {"title": "Cashew (1 Kg)", "shortTitle": "1 Kg", "badge": "L"},
          ],
        },
        {
          "image":
              "https://media.gettyimages.com/id/514769957/photo/simply-nature-organic-wildflower-honey-bottle.jpg?s=1024x1024&w=gi&k=20&c=XQQG6Q92mcZtj7g_rqda2LFH32jL-ZtU14lRlhVbIFk=",
          "name": "Honey",
          "currency": "\$",
          "price": 450.0,
          "oldPrice": 599.0,
          "subtitle": "Pure organic honey",
          "tag": "@Pure Wildflower Honey",
          "description":
              "100% raw wildflower honey — unpasteurized and free from additives. Naturally sourced, retains enzymes and natural aroma.",
          "options": [
            {
              "title": "Honey Jar (250 g)",
              "shortTitle": "250 g",
              "badge": "250g",
            },
            {
              "title": "Honey Jar (500 g)",
              "shortTitle": "500 g",
              "badge": "500g",
            },
            {"title": "Honey Jar (1 Kg)", "shortTitle": "1 Kg", "badge": "1kg"},
          ],
        },
        {
          "image":
              "https://plus.unsplash.com/premium_photo-1675237626334-5cf9d9d8b30c?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          "name": "Rice",
          "currency": "\$",
          "price": 699.0,
          "oldPrice": 899.0,
          "subtitle": "Premium long grain",
          "tag": "@Basmati 1121",
          "description":
              "Aromatic long-grain basmati rice with a fluffy texture and distinct aroma. Ideal for biryani, pilaf and everyday meals.",
          "options": [
            {"title": "Rice (1 Kg)", "shortTitle": "1 Kg", "badge": "1kg"},
            {"title": "Rice (5 Kg)", "shortTitle": "5 Kg", "badge": "5kg"},
            {"title": "Rice (10 Kg)", "shortTitle": "10 Kg", "badge": "10kg"},
          ],
        },
      ].obs;
  RxList<String> bannerImageList = <String>[].obs;
  Category? productDetails;
  RxMap selectedProductDetails = {}.obs;
  RxInt selectedOptionIndex = 0.obs;
  RxBool isLoading = false.obs;
  CategoryViewResponse? categoryViewResponse;
  Rx<ProductViewResponse?> viewProductDetails = Rx<ProductViewResponse?>(null);
}
