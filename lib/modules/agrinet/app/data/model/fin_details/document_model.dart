import '../common/option.dart';

class DocumentModel {
  int? docId;
  Option? name;
  DateTime? issueDate;
  DateTime? expiryDate;
  List<int>? fileBytes;

  DocumentModel({
    this.name,
    this.issueDate,
    this.expiryDate,
    this.fileBytes,
    this.docId,
  });

  Map<String, dynamic> toJson() => {
    "docId": docId,
    "docName": name?.toJson(),
    "file": fileBytes,
    "issueDate": issueDate?.millisecondsSinceEpoch,
    "uploadDate": expiryDate?.millisecondsSinceEpoch,
  };
}
