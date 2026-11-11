import 'AbGenLovs.dart';

class AbLovs {
  String _module;
  List<AbGenLovs>? _genLovs;

  // Constructor
  AbLovs({
    required String module,
    List<AbGenLovs>? genLovs,
  })  : _module = module,
        _genLovs = genLovs;

  // Getter and setter for module
  String get module => _module;
  set module(String value) => _module = value;

  // Getter and setter for genLovs
  List<AbGenLovs>? get genLovs => _genLovs;
  set genLovs(List<AbGenLovs>? value) => _genLovs = value;

  // Named constructor for creating an instance from a JSON map
  factory AbLovs.fromJson(Map<String, dynamic> json) {
    return AbLovs(
      module: json['module'] ?? '',
      genLovs: (json['genLovs'] as List<dynamic>?)
          ?.map((item) => AbGenLovs.fromJson(item))
          .toList(),
    );
  }

  // Method to convert class instance into JSON map
  Map<String, dynamic> toJson() {
    return {
      'module': _module,
      'genLovs': _genLovs?.map((e) => e.toJson()).toList(),
    };
  }
}