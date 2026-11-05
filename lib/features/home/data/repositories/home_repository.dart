import '../../../../core/network/api_error.dart';
import '../data_sources/home_local_data_source.dart';
import '../models/home_session_model.dart';

class HomeRepository {
  final HomeLocalDataSource _local;

  HomeRepository(this._local);

  HomeSessionModel getSession() {
    return _local.readSession();
  }

  Future<void> logout() async {
    try {
      await _local.logout();
    } catch (error) {
      throw ApiException(errorMessage(error));
    }
  }
}
