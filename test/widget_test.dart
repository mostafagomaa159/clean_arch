import 'package:flutter_test/flutter_test.dart';
import 'package:clean_arch/core/constants/api_constants.dart';

void main() {
  test('API endpoints are configured correctly', () {
    expect(
      ApiConstants.baseUrl,
      'https://2loyal-tmp-almasry.almasrypharmacy.com/rest/default/V1',
    );

    expect(ApiConstants.register, '/guest/register');
    expect(
      ApiConstants.activateAccount,
      '/crocoit/auth/activate-account',
    );
    expect(ApiConstants.authAfterOtp, '/auth-after-otp');
  });
}
