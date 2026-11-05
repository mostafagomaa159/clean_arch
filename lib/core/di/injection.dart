import 'package:clean_arch/core/network/api_services.dart';
import 'package:clean_arch/features/home/presentation/blocs/home_bloc.dart';
import 'package:clean_arch/features/login/presentation/blocs/login_bloc.dart';
import 'package:clean_arch/features/verify_otp/data/data_sources/otp_remote_data_source.dart';
import 'package:clean_arch/features/verify_otp/data/repositories/otp_repository.dart';
import 'package:clean_arch/features/verify_otp/presentation/blocs/otp_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/home/data/data_sources/home_local_data_source.dart';
import '../../features/home/data/repositories/home_repository.dart';
import '../../features/login/data/data_sources/login_remote_data_source.dart';
import '../../features/login/data/repositories/login_repository.dart';

import '../constants/api_constants.dart';
import '../session/models/verification_context.dart';
import '../session/session_store.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final preferences = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();

  getIt.registerSingleton<SharedPreferences>(preferences);
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);

  final sessionStore = SessionStore(
    secureStorage,
    preferences,
  );

  await sessionStore.initialize();
  getIt.registerSingleton<SessionStore>(sessionStore);

  getIt.registerLazySingleton<Dio>(
        () => Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    ),
  );

  getIt.registerLazySingleton<ApiService>(
        () => ApiService(getIt<Dio>()),
  );

  // Login.
  getIt.registerLazySingleton<LoginRemoteDataSource>(
        () => LoginRemoteDataSource(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<LoginRepository>(
        () => LoginRepository(getIt<LoginRemoteDataSource>()),
  );

  getIt.registerFactory<LoginBloc>(
        () => LoginBloc(getIt<LoginRepository>()),
  );

  // Verify OTP.
  getIt.registerLazySingleton<VerifyOtpRemoteDataSource>(
        () => VerifyOtpRemoteDataSource(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<VerifyOtpRepository>(
        () => VerifyOtpRepository(
      getIt<VerifyOtpRemoteDataSource>(),
      getIt<SessionStore>(),
    ),
  );

  getIt.registerFactoryParam<
      VerifyOtpBloc,
      VerificationContext,
      void>(
        (verificationContext, _) => VerifyOtpBloc(
      getIt<VerifyOtpRepository>(),
      verificationContext,
    ),
  );

  // Home.
  getIt.registerLazySingleton<HomeLocalDataSource>(
        () => HomeLocalDataSource(getIt<SessionStore>()),
  );

  getIt.registerLazySingleton<HomeRepository>(
        () => HomeRepository(getIt<HomeLocalDataSource>()),
  );

  getIt.registerFactory<HomeBloc>(
        () => HomeBloc(getIt<HomeRepository>()),
  );
}
