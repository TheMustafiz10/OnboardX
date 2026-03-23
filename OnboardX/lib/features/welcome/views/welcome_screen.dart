import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../controllers/welcome_controller.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 80,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.welcomeHeadline,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  AppStrings.welcomeSubtitle,
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/Ellipse 7.png',
                  width: 350,
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Obx(() {
                  final isLoading = controller.isLoadingLocation.value;
                  return SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : controller.useCurrentLocation,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.textPrimary),
                        foregroundColor: AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.textPrimary,
                                ),
                              ),
                            )
                          else
                            const Text(AppStrings.useCurrentLocation),
                          if (!isLoading)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.location_on),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.goToHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(AppStrings.homeButton),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
