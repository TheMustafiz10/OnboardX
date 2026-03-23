import 'package:get/get.dart';

import '../constants/app_routes.dart';
import '../features/home/bindings/home_binding.dart';
import '../features/home/views/home_screen.dart';
import '../features/onboarding/bindings/onboarding_binding.dart';
import '../features/onboarding/views/onboarding_screen.dart';
import '../features/welcome/bindings/welcome_binding.dart';
import '../features/welcome/views/welcome_screen.dart';

class AppPages {
  const AppPages._();

  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeScreen(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
