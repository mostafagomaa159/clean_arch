class ApiConstants {
  ApiConstants._();

  static const baseUrl =
      'https://2loyal-tmp-almasry.almasrypharmacy.com/rest/default/V1';

  static const register = '/guest/register';
  static const activateAccount = '/crocoit/auth/activate-account';
  static const authAfterOtp = '/auth-after-otp';

  static const registrationBearerToken =
      'p75lojdwgxcfldke5czc7gjvgc8q1jj2';


  static const registrationPassword = String.fromEnvironment(
    'REGISTRATION_PASSWORD',
    defaultValue: 'Password@123',
  );
}
