import 'package:clean_arch/features/verify_otp/data/repositories/otp_repository.dart';
import 'package:clean_arch/features/verify_otp/presentation/blocs/otp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/session/models/verification_context.dart';
import '../../../../core/utils/validators.dart';


abstract class VerifyOtpEvent {}

class VerifyOtpSubmitted extends VerifyOtpEvent {
  final String code;

  VerifyOtpSubmitted(this.code);
}

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpRepository _repository;
  final VerificationContext verificationContext;

  bool _submitting = false;
  bool _accountActivated = false;

  VerifyOtpBloc(
      this._repository,
      this.verificationContext,
      ) : super(VerifyOtpInitial()) {
    on<VerifyOtpSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
      VerifyOtpSubmitted event,
      Emitter<VerifyOtpState> emit,
      ) async {
    if (_submitting) return;

    // Required only before activation has succeeded.
    // Validate OTP only before activation has succeeded.
    if (!_accountActivated) {
      final code = event.code.trim();
      final validationError = Validators.otp(code);

      // Check that the code is not empty and contains digits only.
      if (validationError != null) {
        emit(
          VerifyOtpFailure(
            message: validationError,
            accountActivated: false,
          ),
        );
        return;
      }

      // Check that the entered code matches the expected OTP.
      if (code != verificationContext.activationCode) {
        emit(
          VerifyOtpFailure(
            message: 'Incorrect verification code.',
            accountActivated: false,
          ),
        );
        return;
      }
    }


    _submitting = true;

    try {
      if (!_accountActivated) {
        emit(VerifyOtpLoading('Activating your account...'));

        await _repository.activate(verificationContext);
        _accountActivated = true;
      }

      emit(VerifyOtpLoading('Signing you in...'));

      await _repository.authenticateAndSaveSession(
        verificationContext.mobile,
      );

      emit(VerifyOtpSuccess());
    } catch (error) {
      emit(
        VerifyOtpFailure(
          message: errorMessage(error),
          accountActivated: _accountActivated,
        ),
      );
    } finally {
      _submitting = false;
    }
  }
}
