import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_error.dart';
import '../../data/repositories/home_repository.dart';
import 'home_state.dart';
export 'home_state.dart';

abstract class HomeEvent {}

class HomeStarted extends HomeEvent {}

class HomeLogoutRequested extends HomeEvent {}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;
  bool _loggingOut = false;

  HomeBloc(this._repository) : super(HomeInitial()) {
    on<HomeStarted>((event, emit) {
      emit(HomeLoaded(_repository.getSession()));
    });

    on<HomeLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
      HomeLogoutRequested event,
      Emitter<HomeState> emit,
      ) async {
    if (_loggingOut) return;

    _loggingOut = true;
    emit(HomeLoggingOut());

    try {
      await _repository.logout();
      emit(HomeLoggedOut());
    } catch (error) {
      emit(HomeFailure(errorMessage(error)));
      emit(HomeLoaded(_repository.getSession()));
    } finally {
      _loggingOut = false;
    }
  }
}
