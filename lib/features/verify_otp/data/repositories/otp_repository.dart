import 'package:clean_arch/features/verify_otp/data/data_sources/otp_remote_data_source.dart';
import 'package:clean_arch/features/verify_otp/data/models/activate_account_request_model.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/session/models/verification_context.dart';
import '../../../../core/session/session_store.dart';

class VerifyOtpRepository {
  final VerifyOtpRemoteDataSource _remote;
  final SessionStore _sessionStore;

  VerifyOtpRepository(this._remote, this._sessionStore);

  Future<void> activate(VerificationContext context) async {
    try {
      final response = await _remote.activate(
        request: ActivateAccountRequest(
          customerId: context.customerId,
        ),
        registrationToken: context.registrationToken,
      );

      if (response['status'] != 'success') {
        throw ApiException(
          response['message']?.toString() ??
              'Account activation failed.',
        );
      }
    } catch (error) {
      throw ApiException(errorMessage(error));
    }
  }

  Future<void> authenticateAndSaveSession(String mobile) async {
    try {
      final response = await _remote.authenticate(mobile: mobile);

      if (response.token.trim().isEmpty) {
        throw const ApiException(
          'The server did not return an authentication token.',
        );
      }

      await _sessionStore.saveSession(response);
    } catch (error) {
      throw ApiException(errorMessage(error));
    }
  }
}
