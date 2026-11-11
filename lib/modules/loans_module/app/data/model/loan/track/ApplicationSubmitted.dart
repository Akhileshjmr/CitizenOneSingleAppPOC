import 'app_review_resp.dart';

class ApplicationSubmitted {
  ApplicationSubmitted({
    this.application,
    this.date,
    this.time,
    this.value,
    this.appReview,
  });

  ApplicationSubmitted.fromJson(dynamic json) {
    application = json['application'];
    date = json['date'];
    time = json['time'];
    value = json['value'];
    appReview =
        json['appReview'] != null
            ? new AppReview.fromJson(json['appReview'])
            : null;
  }
  bool? application;
  String? date;
  String? time;
  String? value;
  AppReview? appReview;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['application'] = application;
    map['date'] = date;
    map['time'] = time;
    map['value'] = value;
    if (appReview != null) {
      map['appReview'] = appReview!.toJson();
    }
    return map;
  }
}
