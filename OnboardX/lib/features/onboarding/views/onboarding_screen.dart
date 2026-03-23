import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/onboarding_page.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            itemCount: controller.totalPages,
            itemBuilder: (context, index) => OnboardingPage(
              title: AppStrings.onboardingTitles[index],
              description: AppStrings.onboardingDescriptions[index],
              videoPath: AppStrings.onboardingVideos[index],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: controller.skip,
              child: const Text(
                AppStrings.skip,
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.totalPages,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: controller.currentPage.value == index ? 12 : 8,
                    height: controller.currentPage.value == index ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.currentPage.value == index
                          ? AppColors.accent
                          : AppColors.textPrimary.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Obx(
              () => ElevatedButton(
                onPressed:
                    controller.currentPage.value == controller.totalPages - 1
                    ? controller.complete
                    : controller.next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  controller.currentPage.value == controller.totalPages - 1
                      ? AppStrings.getStarted
                      : AppStrings.next,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
