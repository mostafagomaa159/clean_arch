import 'package:clean_arch/features/home/presentation/blocs/home_bloc.dart';
import 'package:clean_arch/features/login/presentation/blocs/login_bloc.dart';
import 'package:clean_arch/features/verify_otp/presentation/blocs/otp_bloc.dart';
import 'package:clean_arch/features/verify_otp/presentation/pages/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/login/presentation/pages/login_page.dart';
import '../di/injection.dart';
import '../session/models/verification_context.dart';
import '../session/session_store.dart';

GoRouter createAppRouter() {
  final sessionStore = getIt<SessionStore>();

  return GoRouter(
    initialLocation: sessionStore.isAuthenticated ? '/home' : '/login',
    redirect: (context, state) {
      final path = state.uri.path;
      final authenticated = sessionStore.isAuthenticated;

      if (!authenticated && path == '/home') {
        return '/login';
      }

      if (authenticated &&
          (path == '/login' || path == '/verify-otp')) {
        return '/home';
      }

      if (path == '/verify-otp' &&
          state.extra is! VerificationContext) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<LoginBloc>(),
            child: const LoginPage(),
          );
        },
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) {
          final verificationContext =
          state.extra as VerificationContext;

          return BlocProvider(
            create: (_) => getIt<VerifyOtpBloc>(
              param1: verificationContext,
            ),
            child: const VerifyOtpPage(),
          );
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<HomeBloc>()..add(HomeStarted()),
            child: const HomePage(),
          );
        },
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/login'),
            child: const Text('Return to app'),
          ),
        ),
      );
    },
  );
}
