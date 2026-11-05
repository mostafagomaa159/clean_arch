import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import 'api_error.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Map<String, dynamic>> register({
    required Map<String, dynamic> body,
  }) {
    final token = ApiConstants.registrationBearerToken.trim();

    if (token.isEmpty) {
      throw const ApiException(
        'The registration bearer token is not configured.',
      );
    }

    return _post(
      ApiConstants.register,
      body: body,
      bearerToken: token,
    );
  }

  Future<Map<String, dynamic>> activateAccount({
    required Map<String, dynamic> body,
    required String registrationToken,
  }) {
    final token = ApiConstants.registrationBearerToken.trim();

    if (token.isEmpty) {
      throw const ApiException(
        'The activation bearer token is not configured.',
      );
    }

    return _post(
      ApiConstants.activateAccount,
      body: body,
      bearerToken: token,
    );
  }


  Future<Map<String, dynamic>> authenticateAfterOtp({
    required String mobile,
  }) {
    // Deliberately no Authorization header.
    return _post(
      ApiConstants.authAfterOtp,
      body: {'mobile': mobile},
    );
  }

  Future<Map<String, dynamic>> _post(
      String path, {
        required Map<String, dynamic> body,
        String? bearerToken,
      }) async {
    final token = bearerToken?.trim();

    try {
      final response = await _dio.post<dynamic>(
        path,
        data: body,
        options: Options(
          headers: {
            if (token != null)
              'Authorization': 'Bearer $token',
          },
        ),
      );

      final data = response.data;

      if (data is! Map) {
        throw const ApiException('Unexpected server response.');
      }

      return Map<String, dynamic>.from(data);
    } on DioException catch (e) {
      String? actualAuthorization;

      for (final entry in e.requestOptions.headers.entries) {
        if (entry.key.toLowerCase() == 'authorization') {
          actualAuthorization = entry.value?.toString();
          break;
        }
      }

      debugPrint('Failed endpoint: ${e.requestOptions.path}');
      debugPrint('HTTP status: ${e.response?.statusCode}');
      debugPrint(
        'Authorization present: '
            '${actualAuthorization?.isNotEmpty ?? false}',
      );

      if (token != null) {
        debugPrint(
          'Authorization matches intended token: '
              '${actualAuthorization == 'Bearer $token'}',
        );
      }

      rethrow;
    }
  }

}
