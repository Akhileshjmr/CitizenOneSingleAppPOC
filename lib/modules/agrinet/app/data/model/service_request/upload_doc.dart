import '../common/ch_message.dart';

class UploadResponse {
  Docs? docs;
  ChMessage? chMessage;

  UploadResponse({this.docs, this.chMessage});

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      docs: json["docs"] != null ? Docs.fromJson(json["docs"]) : null,
      chMessage:
          json["chMessage"] != null
              ? ChMessage.fromJson(json["chMessage"])
              : null,
    );
  }
}

class Docs {
  List<DocDet>? docDet;

  Docs({this.docDet});

  factory Docs.fromJson(Map<String, dynamic> json) {
    return Docs(
      docDet:
          json["docDet"] != null
              ? List<DocDet>.from(json["docDet"].map((x) => DocDet.fromJson(x)))
              : null,
    );
  }
}

class DocDet {
  int? docId;
  String? fileName;

  DocDet({this.docId, this.fileName});

  factory DocDet.fromJson(Map<String, dynamic> json) {
    return DocDet(docId: json["docId"], fileName: json["fileName"]);
  }
}
