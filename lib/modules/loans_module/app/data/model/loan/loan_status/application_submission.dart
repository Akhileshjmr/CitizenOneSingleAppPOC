class ApplicationSubmitted {
  ApplicationSubmitted({
      this.application, 
      this.date, 
      this.time, 
      this.value, 
      this.appReview,});

  ApplicationSubmitted.fromJson(dynamic json) {
    application = json['application'];
    date = json['date'];
    time = json['time'];
    value = json['value'];
    appReview = json['appReview'];
  }
  bool? application;
  String? date;
  String? time;
  String? value;
  dynamic appReview;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['application'] = application;
    map['date'] = date;
    map['time'] = time;
    map['value'] = value;
    map['appReview'] = appReview;
    return map;
  }

}