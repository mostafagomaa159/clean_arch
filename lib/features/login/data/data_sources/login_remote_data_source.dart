import 'package:clean_arch/core/network/api_services.dart';

import '../../../../core/session/models/auth_response.dart';
import '../models/register_request.dart';

class LoginRemoteDataSource {
  final ApiService _api;

  LoginRemoteDataSource(this._api);

  Future<AuthResponse> register(RegisterRequest request) async {
    final json = await _api.register(body: request.toJson());
    return AuthResponse.fromJson(json);
  }
}
