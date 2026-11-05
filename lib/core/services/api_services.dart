import 'package:clean_arch/core/constants/app_api.dart';
import 'package:clean_arch/core/injection/locator.dart';
import 'package:clean_arch/core/services/api_logger_interceptor_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:clean_arch/core/constants/app_durations.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = _initializeDio();

  static Dio _initializeDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: AppDurations.networkTimeout,
        receiveTimeout: AppDurations.networkTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConstants.token}',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(sl<ApiLoggerInterceptorService>());
    }

    return dio;
  }

  Future<Response> post({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endPoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioError catch (e) {
      // Handle DioError
      _handleError(e);
      rethrow; // Re-throw the error after handling
    }
  }

  Future<Response> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endPoint,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioError catch (e) {
      // Handle DioError
      _handleError(e);
      rethrow; // Re-throw the error after handling
    }
  }

  void _handleError(DioError error) {
    // Log the error or handle it as needed
    if (error.response != null) {
      // Handle server errors
      debugPrint('Error: ${error.response?.data}');
    } else {
      // Handle other errors (e.g., network errors)
      debugPrint('Error: ${error.message}');
    }
  }
}
