import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:clean_arch/core/injection/locator.dart';
import 'package:clean_arch/core/localization/app_locale.dart';
import 'package:clean_arch/core/localization/locale_keys.dart';
import 'package:clean_arch/core/routing/app_router.dart';
import 'package:clean_arch/core/services/shared_prefs_services.dart';
import 'package:clean_arch/features/login/presentation/blocs/login_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  await EasyLocalization.ensureInitialized();
  await sl<SharedPrefsServices>().init();

  runApp(
    EasyLocalization(
      supportedLocales: AppLocale.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: AppLocale.english,
      startLocale: AppLocale.arabic,
      child: const BlinkApp(),
    ),
  );
}

class BlinkApp extends StatefulWidget {
  const BlinkApp({super.key});

  @override
  State<BlinkApp> createState() => _BlinkAppState();
}

class _BlinkAppState extends State<BlinkApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sync locale from context
    unawaited(AppLocale.syncFrom(context.locale));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocProvider(
        create: (context) => sl<LoginBloc>(), // Provide LoginBloc here
        child: MaterialApp.router(
          title: LocaleKeys.title.tr(),
          debugShowCheckedModeBanner: false,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          routerConfig: AppRouter.router,
          builder: (context, child) {
            return BotToastInit()(context, child); // Properly initialize BotToast
          },
        ),
      ),
    );
  }
}
