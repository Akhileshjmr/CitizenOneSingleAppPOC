class AbFcWarningType {
  String wcode = '';
  String wdesc = '';
  AbFcWarningType({required this.wcode, required this.wdesc});

  // Getters and Setters
  String get getWcode => wcode;
  set setWcode(String wcode) => this.wcode = wcode;

  String get getWdesc => wdesc;
  set setWdesc(String wdesc) => this.wdesc = wdesc;

  // Factory method to create an instance from JSON
  factory AbFcWarningType.fromJson(Map<String, dynamic> json) {
    return AbFcWarningType(
      wcode: json['wcode'] ?? '',
      wdesc: json['wdesc'] ?? '',
    );
  }

  // Method to convert instance to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'wcode': wcode,
      'wdesc': wdesc,
    };
  }
}
