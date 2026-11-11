import 'package:dio/dio.dart';

enum ErrorType {
  nointernet,
  badrequest,
  unauthorised,
  forbidden,
  success,
  other
}

class ServerException implements Exception {
  late DioException dioException;
  late String? message;
  late ErrorType? errorType;

  ServerException({required this.dioException, this.message, this.errorType});

}