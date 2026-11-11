import '../common/option.dart';

class RecommendationModel {
  Option? category;
  Option? product;

  List<Option> productOptions = [];
  String comments = "";

  RecommendationModel();

  Map<String, dynamic> toJson() => {
    if (category != null) "category": category!.toJson(),
    if (product != null) "serviceList": product!.toJson(),
    "comments": comments,
  };
}
