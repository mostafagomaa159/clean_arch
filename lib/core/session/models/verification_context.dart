class VerificationContext {
  final String mobile;
  final int customerId;
  final String activationCode;
  final String registrationToken;

  const VerificationContext({
    required this.mobile,
    required this.customerId,
    required this.activationCode,
    required this.registrationToken,
  });
}
