import 'package:dio/dio.dart';

/// API response Extension
extension APIResExt on Response<dynamic> {
  /// Checks if the status of the API call is 200
  bool get isOk => statusCode == 200 || statusCode == 201 ;

  /// Checks if the data exists
  bool get hasData => data != null;

  /// Checks if the status is 200 / 201 and the data is not empty
  bool get allIzzWell => isOk && hasData;
}
