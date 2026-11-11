import 'AbFcErrorType.dart';
import 'AbFcWarningType.dart';

class ServerMessage {
  // Private variables, similar to private fields in Java
  String _errorCode = '';
  String _errorDescription = '';
  List<AbFcErrorType>? _fcError;
  List<AbFcWarningType>? _fcWarning;

  // Constructor
  ServerMessage({
    String errorCode = '',
    String errorDescription = '',
    List<AbFcErrorType>? fcError,
    List<AbFcWarningType>? fcWarning,
  })  : _errorCode = errorCode,
        _errorDescription = errorDescription,
        _fcError = fcError,
        _fcWarning = fcWarning;

  // Getters and Setters
  String get errorCode => _errorCode;
  set errorCode(String errorCode) => _errorCode = errorCode;

  String get errorDescription => _errorDescription;
  set errorDescription(String errorDescription) => _errorDescription = errorDescription;

  List<AbFcErrorType>? get fcError => _fcError;
  set fcError(List<AbFcErrorType>? fcError) => _fcError = fcError;

  List<AbFcWarningType>? get fcWarning => _fcWarning;
  set fcWarning(List<AbFcWarningType>? fcWarning) => _fcWarning = fcWarning;

  // Factory method to create an instance from JSON
 factory ServerMessage.fromJson(Map<String, dynamic> json) {
  return ServerMessage(
    errorCode: json['errorCode'] ?? '',
    errorDescription: json['errorDescription'] ?? '',
    fcError: json['fcError'] is List
        ? (json['fcError'] as List)
            .map((item) => AbFcErrorType.fromJson(item))
            .toList()
        : null,
    fcWarning: json['fcWarning'] is List
        ? (json['fcWarning'] as List)
            .map((item) => AbFcWarningType.fromJson(item))
            .toList()
        : null,
  );
}

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'errorCode': _errorCode,
      'errorDescription': _errorDescription,
      'fcError': _fcError?.map((e) => e.toJson()).toList(),
      'fcWarning': _fcWarning?.map((w) => w.toJson()).toList(),
    };
  }
}
