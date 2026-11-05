import 'package:clean_arch/features/login/presentation/blocs/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_error.dart';
import '../../../../core/utils/validators.dart';
import '../../data/repositories/login_repository.dart';

abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String mobile;

  LoginSubmitted(this.mobile);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _repository;
  bool _submitting = false;

  LoginBloc(this._repository) : super(LoginInitial()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
      LoginSubmitted event,
      Emitter<LoginState> emit,
      ) async {
    if (_submitting) return;

    final mobile = Validators.normalizeMobile(event.mobile);
    final validationError = Validators.internationalMobile(mobile);

    if (validationError != null) {
      emit(LoginFailure(validationError));
      return;
    }

    _submitting = true;
    emit(LoginLoading());

    try {
      final verificationContext = await _repository.register(mobile);
      emit(LoginSuccess(verificationContext));
    } catch (error) {
      emit(LoginFailure(errorMessage(error)));
    } finally {
      _submitting = false;
    }
  }
}
