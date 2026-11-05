import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  runApp(
    App(router: createAppRouter()),
  );
}
