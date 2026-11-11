class AbTransactionMethod {
  String? transmethod;

  // Constructor
  AbTransactionMethod({this.transmethod});

  // Factory method to create object from JSON
  factory AbTransactionMethod.fromJson(Map<String, dynamic> json) {
    return AbTransactionMethod(
      transmethod: json['transmethod'],
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'transmethod': transmethod,
    };
  }
}