import 'package:clean_arch/core/network/api_services.dart';
import 'package:clean_arch/features/verify_otp/data/models/activate_account_request_model.dart';

import '../../../../core/session/models/auth_response.dart';

class VerifyOtpRemoteDataSource {
  final ApiService _api;

  VerifyOtpRemoteDataSource(this._api);

  Future<Map<String, dynamic>> activate({
    required ActivateAccountRequest request,
    required String registrationToken,
  }) {
    return _api.activateAccount(
      body: request.toJson(),
      registrationToken: registrationToken,
    );
  }

  Future<AuthResponse> authenticate({
    required String mobile,
  }) async {
    final json = await _api.authenticateAfterOtp(mobile: mobile);
    return AuthResponse.fromJson(json);
  }
}
