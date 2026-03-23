import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants/app_colors.dart';
import 'constants/app_routes.dart';
import 'constants/app_strings.dart';
import 'helpers/app_pages.dart';
import 'helpers/notification_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent),
        useMaterial3: true,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
      ),
      initialRoute: AppRoutes.onboarding,
      getPages: AppPages.pages,
    );
  }
}
