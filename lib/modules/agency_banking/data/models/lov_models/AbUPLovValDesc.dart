class AbUPLovValDesc {
  String? val;
  String? desc;
  String? upType;

  // Constructor
  AbUPLovValDesc({
    this.val,
    this.desc,
    this.upType,
  });

  // Named constructor for creating an instance from a JSON map
  factory AbUPLovValDesc.fromJson(Map<String, dynamic> json) {
    return AbUPLovValDesc(
      val: json['val'],
      desc: json['desc'],
      upType: json['upType'],
    );
  }

  // Method to convert class instance into JSON map
  Map<String, dynamic> toJson() {
    return {
      'val': val,
      'desc': desc,
      'upType': upType,
    };
  }

  // Getters and Setters
  String? get getVal => val;
  set setVal(String? value) => val = value;

  String? get getDesc => desc;
  set setDesc(String? value) => desc = value;

  String? get getUpType => upType;
  set setUpType(String? value) => upType = value;
}