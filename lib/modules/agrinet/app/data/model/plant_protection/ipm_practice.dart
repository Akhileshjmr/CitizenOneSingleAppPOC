class IPMPractice {
  final String heading;
  final String desc;

  IPMPractice({required this.heading, required this.desc});

  factory IPMPractice.fromJson(Map<String, dynamic> j) =>
      IPMPractice(heading: j['heading'] as String, desc: j['desc'] as String);
}
