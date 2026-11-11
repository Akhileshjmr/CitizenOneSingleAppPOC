class AbCommJntAccDetails {
  String jntCustomerId;
  String jntCustomerName;

  // Constructor
  AbCommJntAccDetails({
    this.jntCustomerId = '',
    this.jntCustomerName = '',
  });

  // Factory method to create an instance from JSON
  factory AbCommJntAccDetails.fromJson(Map<String, dynamic> json) {
    return AbCommJntAccDetails(
      jntCustomerId: json['jntCustomerId'] ?? '',
      jntCustomerName: json['jntCustomerName'] ?? '',
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'jntCustomerId': jntCustomerId,
      'jntCustomerName': jntCustomerName,
    };
  }
}