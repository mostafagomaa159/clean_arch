import '../../../../core/session/models/verification_context.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final VerificationContext verificationContext;

  LoginSuccess(this.verificationContext);
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);
}
