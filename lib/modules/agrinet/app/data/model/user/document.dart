class Documents {
  dynamic key;
  dynamic fileBytes;
  String? name;
  String? extn;
  String? type;
  String? imgUrl;
  dynamic fileDataStr;
  dynamic canDelete;
  dynamic isAddedInThisProc;

  Documents({
    this.key,
    this.fileBytes,
    this.name,
    this.extn,
    this.type,
    this.imgUrl,
    this.fileDataStr,
    this.canDelete,
    this.isAddedInThisProc,
  });

  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(
      key: json['key'],
      fileBytes: json['fileBytes'],
      name: json['name'],
      extn: json['extn'],
      type: json['type'],
      imgUrl: json['imgUrl'],
      fileDataStr: json['fileDataStr'],
      canDelete: json['canDelete'],
      isAddedInThisProc: json['isAddedInThisProc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'fileBytes': fileBytes,
      'name': name,
      'extn': extn,
      'type': type,
      'imgUrl': imgUrl,
      'fileDataStr': fileDataStr,
      'canDelete': canDelete,
      'isAddedInThisProc': isAddedInThisProc,
    };
  }
}
