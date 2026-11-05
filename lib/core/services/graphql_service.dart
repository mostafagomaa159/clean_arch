import 'dart:async';

import 'package:clean_arch/core/constants/app_api.dart';
import 'package:clean_arch/core/constants/pref_keys.dart';
import 'package:clean_arch/core/injection/locator.dart';
import 'package:clean_arch/core/services/network_logger_service.dart';
import 'package:clean_arch/core/services/shared_prefs_services.dart';
import 'package:graphql/client.dart';

class GraphQLServiceException implements Exception {
  final String message;

  const GraphQLServiceException(this.message);

  @override
  String toString() => message;
}

class _LoggedCall {
  const _LoggedCall(this.label, this.stopwatch);

  final String label;
  final Stopwatch stopwatch;
}

class GraphQLService {
  late final GraphQLClient _client;

  final _loggerService = sl<NetworkLoggerService>();

  GraphQLService() {
    _client = GraphQLClient(
      link: HttpLink(ApiConstants.graphqlUrl),
      cache: GraphQLCache(),
    );
  }

  Future<Map<String, dynamic>> query(
    String document, {
    Map<String, dynamic> variables = const {},
    Map<String, String> headers = const {},
  }) async {
    final _LoggedCall call = _logRequest('QUERY', document, variables, headers);

    final QueryResult result = await _client.query(
      QueryOptions(
        document: gql(document),
        variables: variables,
        fetchPolicy: FetchPolicy.noCache,
        context: _contextFor(headers),
      ),
    );

    return _resolve(result, call);
  }

  Map<String, String> _headersWith(Map<String, String> headers) {
    final String token = _customerToken;

    if (token.isEmpty) return headers;

    return <String, String>{...headers, 'Authorization': 'Bearer $token'};
  }

  Context _contextFor(Map<String, String> headers) {
    final Map<String, String> all = _headersWith(headers);

    if (all.isEmpty) return const Context();

    return const Context().withEntry(HttpLinkHeaders(headers: all));
  }

  String get _customerToken =>
      sl<SharedPrefsServices>().getString(PrefKeys.customerToken).trim();

  void _forgetTokenIfRejected(String message) {
    if (_customerToken.isEmpty) return;

    final String lower = message.toLowerCase();

    final bool isAuthFailure =
        lower.contains("isn't authorized") ||
        lower.contains('is not authorized') ||
        lower.contains('token is expired') ||
        lower.contains('current customer');

    if (!isAuthFailure) return;

    unawaited(sl<SharedPrefsServices>().remove(PrefKeys.customerToken));
  }

  Future<Map<String, dynamic>> mutate(
    String document, {
    Map<String, dynamic> variables = const {},
  }) async {
    final _LoggedCall call = _logRequest(
      'MUTATION',
      document,
      variables,
      const {},
    );

    final QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(document),
        variables: variables,
        fetchPolicy: FetchPolicy.noCache,
        context: _contextFor(const {}),
      ),
    );

    return _resolve(result, call);
  }

  _LoggedCall _logRequest(
    String kind,
    String document,
    Map<String, dynamic> variables,
    Map<String, String> headers,
  ) {
    final String label =
        '$kind ${NetworkLoggerService.operationName(document) ?? 'anonymous'}';

    _loggerService.open('GRAPHQL $label');

    if (headers.isNotEmpty) {
      _loggerService.line('headers:');
      headers.forEach(_loggerService.keyValue);
    }

    if (variables.isNotEmpty) {
      _loggerService.section('variables', variables);
    }

    _loggerService.close();

    return _LoggedCall(label, Stopwatch()..start());
  }

  Map<String, dynamic> _resolve(QueryResult result, _LoggedCall call) {
    final String elapsed = ' (${call.stopwatch.elapsedMilliseconds}ms)';

    if (result.hasException) {
      final String message = _extractMessage(result.exception!);

      _loggerService.open('GRAPHQL ERROR ${call.label}$elapsed');
      _loggerService.line(message.isEmpty ? '${result.exception}' : message);

      if (result.data != null) {
        _loggerService.section('partial data', result.data);
      }

      _loggerService.close();

      _forgetTokenIfRejected(message);

      throw GraphQLServiceException(message);
    }

    final Map<String, dynamic>? data = result.data;

    _loggerService.open('GRAPHQL REPLY ${call.label}$elapsed');
    _loggerService.section('data', data);
    _loggerService.close();

    if (data == null) {
      throw const GraphQLServiceException('');
    }

    return data;
  }

  String _extractMessage(OperationException exception) {
    if (exception.graphqlErrors.isNotEmpty) {
      final String message = exception.graphqlErrors.first.message;

      if (message.trim().isNotEmpty) {
        return message;
      }
    }

    final LinkException? linkException = exception.linkException;

    if (linkException != null) {
      final dynamic originalException = linkException.originalException;

      if (originalException != null) {
        return originalException.toString();
      }

      return linkException.toString();
    }

    return '';
  }
}
