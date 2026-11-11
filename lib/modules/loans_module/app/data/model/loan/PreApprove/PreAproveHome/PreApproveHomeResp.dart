import 'Categories.dart';
import 'ComResp.dart';

class PreApproveHomeResp {
  PreApproveHomeResp({
      this.categories, 
      this.paging, 
      this.comResp,});

  PreApproveHomeResp.fromJson(dynamic json) {
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories?.add(Categories.fromJson(v));
      });
    }
    paging = json['paging'];
    comResp = json['comResp'] != null ? ComResp.fromJson(json['comResp']) : null;
  }
  List<Categories>? categories;
  dynamic paging;
  ComResp? comResp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (categories != null) {
      map['categories'] = categories?.map((v) => v.toJson()).toList();
    }
    map['paging'] = paging;
    if (comResp != null) {
      map['comResp'] = comResp?.toJson();
    }
    return map;
  }

}