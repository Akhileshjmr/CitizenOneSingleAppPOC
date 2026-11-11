class Mentor {
  String? mentorName;

  Mentor({this.mentorName});

  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(mentorName: json['mentorName']);
  }

  Map<String, dynamic> toJson() {
    return {'mentorName': mentorName};
  }
}
