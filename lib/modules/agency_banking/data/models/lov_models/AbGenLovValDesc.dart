class AbGenLovValDesc {
  String? val;
  String? desc;

  // Constructora
  AbGenLovValDesc({
    this.val,
    this.desc,
  });

  // Named constructor for creating an instance from a JSON map
  factory AbGenLovValDesc.fromJson(Map<String, dynamic> json) {
    return AbGenLovValDesc(
      val: json['val'],
      desc: json['desc'],
    );
  }

  // Method to convert class instance into JSON map
  Map<String, dynamic> toJson() {
    return {
      'val': val,
      'desc': desc,
    };
  }

  // Getters and Setters
  String? get getVal => val;
  set setVal(String? value) => val = value;

  String? get getDesc => desc;
  set setDesc(String? value) => desc = value;

  // toString method (similar to the Java class)
  @override
  String toString() {
    return desc ?? '';
  }
}