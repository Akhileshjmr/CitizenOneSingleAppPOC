import 'DocumentName.dart';

class Documents {
  Documents({
      this.key, 
      this.documentName, 
      this.isMandatory, 
      this.document, 
      this.originalDocName, 
      this.canDelete, 
      this.isAttachedInProcess,
      this.LimitMode,});

  Documents.fromJson(dynamic json) {
    key = json['key'];
    documentName = json['documentName'] != null ? DocumentName.fromJson(json['documentName']) : null;
    isMandatory = json['isMandatory'];
    document = json['document'];
    originalDocName = json['originalDocName'];
    canDelete = json['canDelete'];
    isAttachedInProcess = json['isAttachedInProcess'];
  }
  dynamic key;
  DocumentName? documentName;
  bool? isMandatory;
  dynamic document;
  String? originalDocName;
  dynamic canDelete;
  bool? isAttachedInProcess;
  String? LimitMode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    if (documentName != null) {
      map['documentName'] = documentName?.toJson();
    }
    map['isMandatory'] = isMandatory;
    map['document'] = document;
    map['originalDocName'] = originalDocName;
    map['canDelete'] = canDelete;
    map['isAttachedInProcess'] = isAttachedInProcess;
    return map;
  }

}