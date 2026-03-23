import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/app_strings.dart';

class LocationResult {
  const LocationResult({this.address, this.errorMessage});

  final String? address;
  final String? errorMessage;

  bool get isSuccess => address != null && errorMessage == null;
}

class LocationHelper {
  const LocationHelper._();

  static Future<LocationResult> requestLocation() async {
    final status = await Permission.location.request();

    if (!status.isGranted) {
      return const LocationResult(errorMessage: AppStrings.locationDenied);
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final address = _placemarkToAddress(placemarks, position);
      return LocationResult(address: address);
    } catch (error) {
      return LocationResult(
        errorMessage: '${AppStrings.locationErrorPrefix}$error',
      );
    }
  }

  static String _placemarkToAddress(
    List<Placemark> placemarks,
    Position position,
  ) {
    if (placemarks.isEmpty) {
      return '${position.latitude}, ${position.longitude}';
    }

    final place = placemarks.first;
    final buffer = StringBuffer();

    if (place.street != null && place.street!.isNotEmpty) {
      buffer.write(place.street);
    }

    if (place.locality != null && place.locality!.isNotEmpty) {
      if (buffer.isNotEmpty) buffer.write(', ');
      buffer.write(place.locality);
    }

    if (place.country != null && place.country!.isNotEmpty) {
      if (buffer.isNotEmpty) buffer.write(', ');
      buffer.write(place.country);
    }

    return buffer.isEmpty
        ? '${position.latitude}, ${position.longitude}'
        : buffer.toString();
  }
}
