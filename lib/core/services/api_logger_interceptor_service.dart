import 'package:clean_arch/core/services/network_logger_service.dart';
import 'package:dio/dio.dart';

class ApiLoggerInterceptorService extends Interceptor {
  const ApiLoggerInterceptorService({
    this.logger = const NetworkLoggerService(),
    this.logHeaders = true,
  });

  final NetworkLoggerService logger;

  final bool logHeaders;

  static const String _startKey = 'api_logger_start';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startKey] = DateTime.now().millisecondsSinceEpoch;

    logger.open('REQUEST ${options.method} ${options.uri}');

    if (logHeaders && options.headers.isNotEmpty) {
      logger.line('headers:');
      options.headers.forEach(logger.keyValue);
    }

    if (options.queryParameters.isNotEmpty) {
      logger.section('query parameters', options.queryParameters);
    }

    if (options.data != null) {
      logger.section('body', options.data);
    }

    logger.close();

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final RequestOptions options = response.requestOptions;

    logger.open(
      'RESPONSE ${response.statusCode} ${options.method} ${options.uri}'
      '${_elapsed(options)}',
    );

    if (response.data != null) {
      logger.section('body', response.data);
    }

    logger.close();

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final RequestOptions options = err.requestOptions;

    logger.open(
      'ERROR ${err.response?.statusCode ?? err.type.name} '
      '${options.method} ${options.uri}${_elapsed(options)}',
    );
    logger.line(err.message ?? err.toString());

    if (err.response?.data != null) {
      logger.section('body', err.response!.data);
    }

    logger.close();

    handler.next(err);
  }

  String _elapsed(RequestOptions options) {
    final Object? start = options.extra[_startKey];

    if (start is! int) return '';

    return ' (${DateTime.now().millisecondsSinceEpoch - start}ms)';
  }
}
