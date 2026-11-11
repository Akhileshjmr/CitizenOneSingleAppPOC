class Doc {
  Doc({
      this.key, 
      this.fileBytes, 
      this.name, 
      this.extn, 
      this.type, 
      this.imgUrl, 
      this.fileDataStr, 
      this.canDelete, 
      this.isAddedInThisProc, 
      this.storage,});

  Doc.fromJson(dynamic json) {
    key = json['key'];
    fileBytes = json['fileBytes'];
    name = json['name'];
    extn = json['extn'];
    type = json['type'];
    imgUrl = json['imgUrl'];
    fileDataStr = json['fileDataStr'];
    canDelete = json['canDelete'];
    isAddedInThisProc = json['isAddedInThisProc'];
    storage = json['storage'];
  }
  String? key;
  String? fileBytes;
  String? name;
  String? extn;
  String? type;
  String? imgUrl;
  String? fileDataStr;
  bool? canDelete;
  bool? isAddedInThisProc;
  String? storage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['fileBytes'] = fileBytes;
    map['name'] = name;
    map['extn'] = extn;
    map['type'] = type;
    map['imgUrl'] = imgUrl;
    map['fileDataStr'] = fileDataStr;
    map['canDelete'] = canDelete;
    map['isAddedInThisProc'] = isAddedInThisProc;
    map['storage'] = storage;
    return map;
  }

}