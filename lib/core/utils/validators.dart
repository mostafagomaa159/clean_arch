class Validators {
  Validators._();

  static final RegExp _internationalMobileRegex =
  RegExp(r'^\+[1-9]\d{7,14}$');

  static final RegExp _egyptianLocalMobileRegex =
  RegExp(r'^01[0125][0-9]{8}$');

  // OTP must contain digits only.
  static final RegExp _otpRegex = RegExp(r'^[0-9]+$');

  static String normalizeMobile(String value) {
    final mobile = value.trim();

    // Example: 01019059224 -> +201019059224
    if (_egyptianLocalMobileRegex.hasMatch(mobile)) {
      return '+20${mobile.substring(1)}';
    }

    // Do not add a prefix to already-international numbers.
    return mobile;
  }

  static String? internationalMobile(String? value) {
    final input = value?.trim() ?? '';

    if (input.isEmpty) {
      return 'Enter your mobile number.';
    }

    final mobile = normalizeMobile(input);

    if (!_internationalMobileRegex.hasMatch(mobile)) {
      return 'Enter a valid mobile number, such as '
          '01019059224 or +201019059224.';
    }

    return null;
  }

  static String? otp(String? value) {
    final code = value?.trim() ?? '';

    if (code.isEmpty) {
      return 'Enter your verification code.';
    }

    if (!_otpRegex.hasMatch(code)) {
      return 'Verification code must contain digits only.';
    }

    return null;
  }
}
