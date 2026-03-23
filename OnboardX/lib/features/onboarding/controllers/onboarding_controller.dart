import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_routes.dart';
import '../../../constants/app_strings.dart';

class OnboardingController extends GetxController {
  late final PageController pageController;
  final RxInt currentPage = 0.obs;

  int get totalPages => AppStrings.onboardingTitles.length;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void skip() {
    Get.offAllNamed(AppRoutes.welcome);
  }

  void next() {
    if (currentPage.value >= totalPages - 1) {
      complete();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void complete() {
    Get.offAllNamed(AppRoutes.welcome);
  }
}
