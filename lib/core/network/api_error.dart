import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

String errorMessage(Object error) {
  if (error is ApiException) {
    return error.message;
  }

  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'The request timed out. Please try again.';

      case DioExceptionType.connectionError:
        return 'Unable to connect. Check your internet connection.';

      default:
        final data = error.response?.data;

        if (data is Map && data['message'] is String) {
          return data['message'] as String;
        }

        return 'The request failed. Please try again.';
    }
  }

  return 'Something went wrong. Please try again.';
}
