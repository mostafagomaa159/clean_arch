import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/auth_response.dart';

class SessionStore {
  static const _tokenKey = 'auth_token';
  static const _cartIdKey = 'cart_id';

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _preferences;

  String? _token;
  CustomerModel? _customer;

  SessionStore(this._secureStorage, this._preferences);

  bool get isAuthenticated => _token?.isNotEmpty == true;
  CustomerModel? get customer => _customer;
  String? get cartId => _preferences.getString(_cartIdKey);

  Future<void> initialize() async {
    _token = await _secureStorage.read(key: _tokenKey);
  }

  Future<String?> readToken() {
    return _secureStorage.read(key: _tokenKey);
  }

  Future<void> saveSession(AuthResponse response) async {
    if (response.token.trim().isEmpty) {
      throw StateError('Cannot save an empty authentication token.');
    }

    // Save non-sensitive metadata first.
    if (response.cartId != null) {
      await _preferences.setString(_cartIdKey, response.cartId!);
    } else {
      await _preferences.remove(_cartIdKey);
    }

    await _secureStorage.write(
      key: _tokenKey,
      value: response.token,
    );

    _token = response.token;
    _customer = response.customer;
  }

  Future<void> clearSession() async {
    await _secureStorage.delete(key: _tokenKey);
    await _preferences.remove(_cartIdKey);

    _token = null;
    _customer = null;
  }
}
