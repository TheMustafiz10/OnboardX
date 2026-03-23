import 'package:get/get.dart';

import '../../../constants/app_routes.dart';
import '../../../helpers/location_helper.dart';

class WelcomeController extends GetxController {
  final RxBool isLoadingLocation = false.obs;

  Future<void> useCurrentLocation() async {
    if (isLoadingLocation.value) {
      return;
    }

    isLoadingLocation.value = true;
    final result = await LocationHelper.requestLocation();
    isLoadingLocation.value = false;

    if (result.isSuccess && result.address != null) {
      Get.toNamed(AppRoutes.home, arguments: result.address);
    } else if (result.errorMessage != null) {
      Get.snackbar('Location', result.errorMessage!);
    }
  }

  void goToHome() {
    Get.toNamed(AppRoutes.home);
  }
}
