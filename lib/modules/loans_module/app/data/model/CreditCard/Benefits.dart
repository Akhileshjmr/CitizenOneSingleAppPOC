class Benefits {
  Benefits({
      this.title, 
      this.data,});

  Benefits.fromJson(dynamic json) {
    title = json['title'];
    data = json['data'] != null ? json['data'].cast<String>() : [];
  }
  String? title;
  List<String>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['data'] = data;
    return map;
  }

}