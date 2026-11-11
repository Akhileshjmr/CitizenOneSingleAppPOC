class AppReview {
  bool? documentVerification;
  bool? creditScoreReview;
  bool? clarification;

  AppReview({
    this.documentVerification,
    this.creditScoreReview,
    this.clarification,
  });

  AppReview.fromJson(Map<String, dynamic> json) {
    documentVerification = json['documentVerification'];
    creditScoreReview = json['creditScoreReview'];
    clarification = json['clarification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['documentVerification'] = this.documentVerification;
    data['creditScoreReview'] = this.creditScoreReview;
    data['clarification'] = this.clarification;
    return data;
  }
}
