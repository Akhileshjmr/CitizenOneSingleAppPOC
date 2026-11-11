class Reasons {
  Reasons({
      this.title, 
      this.data,});

  Reasons.fromJson(dynamic json) {
    title = json['title'];
    data = json['data'] != null ? json['data'].cast<String>() : [];
  }
  String? title;
  List<dynamic>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}