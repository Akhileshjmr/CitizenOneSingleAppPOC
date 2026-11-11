class Document {
  int? docId;

  Document({this.docId});

  Document.fromJson(Map<String, dynamic> json) {
    docId = json['docId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['docId'] = docId;
    return data;
  }
}
