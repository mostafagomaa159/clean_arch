import '../../../../core/session/session_store.dart';
import '../models/home_session_model.dart';

class HomeLocalDataSource {
  final SessionStore _sessionStore;

  HomeLocalDataSource(this._sessionStore);

  HomeSessionModel readSession() {
    final customer = _sessionStore.customer;
    final firstName = customer?.firstname.trim() ?? '';

    return HomeSessionModel(
      displayName: firstName.isEmpty ? 'Customer' : firstName,
      mobile: customer?.customAttributes['mobilenumber'],
      cartId: _sessionStore.cartId,
    );
  }

  Future<void> logout() {
    return _sessionStore.clearSession();
  }
}
