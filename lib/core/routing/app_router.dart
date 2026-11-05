import 'package:clean_arch/core/routing/app_routes.dart';
import 'package:clean_arch/features/verify_otp/presentation/pages/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bot_toast/bot_toast.dart';
import '../../features/login/presentation/pages/login_page.dart'; // Adjust imports

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    observers: [BotToastNavigatorObserver()],
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: RouteNames.login,
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        name: RouteNames.otpVerification,
        builder: (context, state) {
          // Extract arguments passed from the LoginPage
          final args = state.extra as Map<String, dynamic>?; // Use null safety
          final String customerId = args?['customerId'];
          final String mobile = args?['mobile'];
          final String actualCode = args?['actualCode']; // Ensure this is passed

          return OtpPage(
            customerId: customerId,
            mobile: mobile,
            actualCode: actualCode,
          );
        },
      ),

    ],
  );
}
