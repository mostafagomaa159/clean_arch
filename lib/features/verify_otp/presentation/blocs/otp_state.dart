abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {
  final String message;

  VerifyOtpLoading(this.message);
}

class VerifyOtpSuccess extends VerifyOtpState {}

class VerifyOtpFailure extends VerifyOtpState {
  final String message;
  final bool accountActivated;

  VerifyOtpFailure({
    required this.message,
    required this.accountActivated,
  });
}
