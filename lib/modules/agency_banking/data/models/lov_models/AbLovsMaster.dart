import 'AbLovs.dart';
import '../common_models/HeaderInfo.dart';
import '../common_models/ServerMessage.dart';

class AbLovsMaster {
  HeaderInfo _headerInfo;
  ServerMessage _resMessage;
  List<AbLovs> _abLovs;

  // Constructor
  AbLovsMaster({
    HeaderInfo? headerInfo,
    ServerMessage? resMessage,
    List<AbLovs>? abLovs,
  })  : _headerInfo = headerInfo ?? HeaderInfo(),
        _resMessage = resMessage ?? ServerMessage(),
        _abLovs = abLovs ?? [];

  // Getter and setter for headerInfo
  HeaderInfo get headerInfo => _headerInfo;
  set headerInfo(HeaderInfo value) => _headerInfo = value;

  // Getter and setter for resMessage
  ServerMessage get resMessage => _resMessage;
  set resMessage(ServerMessage value) => _resMessage = value;

  // Getter and setter for abLovs
  List<AbLovs> get abLovs => _abLovs;
  set abLovs(List<AbLovs> value) => _abLovs = value;

  // Named constructor for creating an instance from a JSON map
  factory AbLovsMaster.fromJson(Map<String, dynamic> json) {
    return AbLovsMaster(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : HeaderInfo(),
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : ServerMessage(),
      abLovs: (json['abLovs'] as List<dynamic>?)
          ?.map((item) => AbLovs.fromJson(item))
          .toList() ?? [],
    );
  }

  // Method to convert class instance into JSON map
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': _headerInfo.toJson(),
      'resMessage': _resMessage.toJson(),
      'abLovs': _abLovs.map((e) => e.toJson()).toList(),
    };
  }
}