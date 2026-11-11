import 'AbGenLovValDesc.dart';
import 'AbUPLovValDesc.dart';

class AbGenLovs {
  String _lovName;
  String _lovId;
  List<AbGenLovValDesc>? _valDes;
  List<AbUPLovValDesc>? _valUPDes;
  DateTime? _updatedDate;

  // Constructor
  AbGenLovs({
    required String lovName,
    required String lovId,
    List<AbGenLovValDesc>? valDes,
    List<AbUPLovValDesc>? valUPDes,
    DateTime? updatedDate,
  })  : _lovName = lovName,
        _lovId = lovId,
        _valDes = valDes,
        _valUPDes = valUPDes,
        _updatedDate = updatedDate;

  // Named constructor for creating an instance from a JSON map
  factory AbGenLovs.fromJson(Map<String, dynamic> json) {
    return AbGenLovs(
      lovName: json['lovName'] ?? '',
      lovId: json['lovId'] ?? '',
      valDes: (json['valDes'] as List<dynamic>?)
          ?.map((item) => AbGenLovValDesc.fromJson(item))
          .toList(),
      valUPDes: (json['valUPDes'] as List<dynamic>?)
          ?.map((item) => AbUPLovValDesc.fromJson(item))
          .toList(),
      updatedDate: json['updatedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedDate'])
          : null,
    );
  }

  // Method to convert class instance into JSON map
  Map<String, dynamic> toJson() {
    return {
      'lovName': _lovName,
      'lovId': _lovId,
      'valDes': _valDes?.map((e) => e.toJson()).toList(),
      'valUPDes': _valUPDes?.map((e) => e.toJson()).toList(),
      'updatedDate': _updatedDate?.millisecondsSinceEpoch,
    };
  }

  // Getters
  String get lovName => _lovName;
  String get lovId => _lovId;
  List<AbGenLovValDesc>? get valDes => _valDes;
  List<AbUPLovValDesc>? get valUPDes => _valUPDes;
  DateTime? get updatedDate => _updatedDate;

  // Setters
  set lovName(String lovName) => _lovName = lovName;
  set lovId(String lovId) => _lovId = lovId;
  set valDes(List<AbGenLovValDesc>? valDes) => _valDes = valDes;
  set valUPDes(List<AbUPLovValDesc>? valUPDes) => _valUPDes = valUPDes;
  set updatedDate(DateTime? updatedDate) => _updatedDate = updatedDate;
}