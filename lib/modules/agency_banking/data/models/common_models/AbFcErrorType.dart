class AbFcErrorType {
  String ecode = '';
  String edesc = '';
  AbFcErrorType({required this.ecode, required this.edesc});

  // Getters and Setters
  String get getEcode => ecode;
  set setEcode(String ecode) => this.ecode = ecode;

  String get getEdesc => edesc;
  set setEdesc(String edesc) => this.edesc = edesc;

  // Factory method to create an instance from JSON
  factory AbFcErrorType.fromJson(Map<String, dynamic> json) {
    return AbFcErrorType(
      ecode: json['ecode'] ?? '',
      edesc: json['edesc'] ?? '',
    );
  }
  // Method to convert instance to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'ecode': ecode,
      'edesc': edesc,
    };
  }
}
