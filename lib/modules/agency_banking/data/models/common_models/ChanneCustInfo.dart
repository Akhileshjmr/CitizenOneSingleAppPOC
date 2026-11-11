class ChanneCustInfo {
  String channelCustId = '';
  String channelCustName = '';
  String channelCustDesc = '';
  // Constructor
  ChanneCustInfo({
    required this.channelCustId,
    required this.channelCustName,
    required this.channelCustDesc,
  });
  // Getters and Setters
  String get getChannelCustId => channelCustId;
  set setChannelCustId(String channelCustId) => this.channelCustId = channelCustId;

  String get getChannelCustName => channelCustName;
  set setChannelCustName(String channelCustName) => this.channelCustName = channelCustName;

  String get getChannelCustDesc => channelCustDesc;
  set setChannelCustDesc(String channelCustDesc) => this.channelCustDesc = channelCustDesc;

  // Factory method to create an instance from JSON
  factory ChanneCustInfo.fromJson(Map<String, dynamic> json) {
    return ChanneCustInfo(
      channelCustId: json['channelCustId'] ?? '',
      channelCustName: json['channelCustName'] ?? '',
      channelCustDesc: json['channelCustDesc'] ?? '',
    );
  }

  // Method to convert instance to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'channelCustId': channelCustId,
      'channelCustName': channelCustName,
      'channelCustDesc': channelCustDesc,
    };
  }
}
