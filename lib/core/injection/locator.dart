import 'package:clean_arch/core/services/api_logger_interceptor_service.dart';
import 'package:clean_arch/core/services/api_services.dart';
import 'package:clean_arch/core/services/cache_manager_service.dart';
import 'package:clean_arch/core/services/graphql_service.dart';
import 'package:clean_arch/core/services/navigation_service.dart';
import 'package:clean_arch/core/services/network_logger_service.dart';
import 'package:clean_arch/core/services/shared_prefs_services.dart';
import 'package:clean_arch/features/login/data/data_sources/login_remote_data_source.dart';
import 'package:clean_arch/features/login/data/repositories/login_repository.dart';
import 'package:clean_arch/features/login/presentation/blocs/login_bloc.dart';
import 'package:clean_arch/features/verify_otp/data/data_sources/otp_remote_data_source.dart';
import 'package:clean_arch/features/verify_otp/data/repositories/otp_repository.dart';
import 'package:clean_arch/features/verify_otp/presentation/blocs/otp_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {

  // --- Core ---
  sl.registerLazySingleton(() => ApiLoggerInterceptorService());
  sl.registerLazySingleton(() => NavigationService());
  sl.registerLazySingleton(() => SharedPrefsServices()); // Assuming this is your service

  // Register ApiService (which internally uses Dio)
  sl.registerLazySingleton(() => ApiService());

  // --- Data Sources ---
  sl.registerLazySingleton<LoginRemoteDataSource>(
        () => LoginRemoteDataSourceImpl(apiService: sl()),
  );
  sl.registerLazySingleton<OtpRemoteDataSource>(
        () => OtpRemoteDataSourceImpl(apiService: sl()),
  );

  // --- Repositories ---
  sl.registerLazySingleton(() => LoginRepository(sl()));
  sl.registerLazySingleton<OtpRepository>(
        () => OtpRepository(
      remoteDataSource: sl<OtpRemoteDataSource>(),
      sharedPrefs: sl<SharedPrefsServices>(),
    ),
  );
  // --- BLoCs ---
  // Using registerFactory so a new instance is created for every page/screen
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerFactory(() => OtpBloc(sl()));
}
