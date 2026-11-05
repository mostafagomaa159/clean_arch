import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/session/models/verification_context.dart';
import '../data_sources/login_remote_data_source.dart';
import '../models/register_request.dart';

class LoginRepository {
  final LoginRemoteDataSource _remote;

  LoginRepository(this._remote);

  Future<VerificationContext> register(String mobile) async {
    try {
      final response = await _remote.register(
        RegisterRequest(
          mobile: mobile,
          password: ApiConstants.registrationPassword,
        ),
      );

      final code = response.activationCode;

      if (code == null || code.trim().isEmpty) {
        throw const ApiException(
          'The server did not return an activation code.',
        );
      }

      if (response.token.trim().isEmpty) {
        throw const ApiException(
          'The server did not return a registration token.',
        );
      }

      return VerificationContext(
        mobile: mobile,
        customerId: response.customer.id,
        activationCode: code,
        registrationToken: response.token,
      );
    } catch (error) {
      throw ApiException(errorMessage(error));
    }
  }
}
