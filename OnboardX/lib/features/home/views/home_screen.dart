import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              AppStrings.selectLocation,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.locationController,
              onTap: controller.getCurrentLocation,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Add your location',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: AppColors.textPrimary,
                ),
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),
            const Text(
              AppStrings.alarms,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.alarms.isEmpty) {
                  return const Center(
                    child: Text(
                      AppStrings.noAlarms,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = controller.alarms[index];
                    return Card(
                      color: AppColors.cardBackground,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('h:mm a').format(alarm.dateTime),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              DateFormat(
                                'EEE dd MMM yyyy',
                              ).format(alarm.dateTime),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        trailing: Switch(
                          value: alarm.isActive,
                          onChanged: (_) => controller.toggleAlarm(index),
                          activeColor: AppColors.textPrimary,
                          activeTrackColor: AppColors.accent,
                          inactiveThumbColor: Colors.black,
                          inactiveTrackColor: AppColors.textPrimary,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addAlarm,
        shape: const CircleBorder(),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textPrimary,
        heroTag: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
