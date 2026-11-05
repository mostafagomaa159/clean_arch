import '../../data/models/home_session_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeSessionModel session;

  HomeLoaded(this.session);
}

class HomeLoggingOut extends HomeState {}

class HomeLoggedOut extends HomeState {}

class HomeFailure extends HomeState {
  final String message;

  HomeFailure(this.message);
}
