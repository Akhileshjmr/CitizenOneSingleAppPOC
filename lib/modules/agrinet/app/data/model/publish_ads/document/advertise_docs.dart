import '../../common/ch_message.dart';
import 'document.dart';

class AdvertiseDocs {
  List<Document>? documents;
  ChMessage? chMessage;

  AdvertiseDocs({this.documents, this.chMessage});

  AdvertiseDocs.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = <Document>[];
      json['documents'].forEach((v) {
        documents!.add(Document.fromJson(v));
      });
    }
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    if (chMessage != null) {
      data['chMessage'] = chMessage!.toJson();
    }
    return data;
  }
}
