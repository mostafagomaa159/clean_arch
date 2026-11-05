import 'package:clean_arch/core/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  final GoRouter _router = AppRouter.router;

  void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) {
    _router.goNamed(name, pathParameters: pathParameters, extra: extra);
  }

  void pushNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) {
    _router.pushNamed(name, pathParameters: pathParameters, extra: extra);
  }

  Future<Object?> pushNamedAndReturn(
    String name, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) {
    return _router.pushNamed(
      name,
      pathParameters: pathParameters,
      extra: extra,
    );
  }

  void replaceNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) {
    _router.replaceNamed(name, pathParameters: pathParameters, extra: extra);
  }

  void pop([Object? result]) {
    if (_router.canPop()) {
      _router.pop(result);
    }
  }

  bool get canPop => _router.canPop();
}
