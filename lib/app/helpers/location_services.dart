// ignore_for_file: use_build_context_synchronously

import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class LocationServices {
  Future<Position?> captureLocation(BuildContext context) async {
    // Check if location services are enabled
    await Geolocator.requestPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location services are disabled.');
      return null;
    }

    // Check for location permission and request if necessary
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
        msg:
            'Location permissions are permanently denied. Please enable them in settings.',
      );
      return null;
    }

    // Capture the current position
    Position position = await Geolocator.getCurrentPosition();
    logger.w("Captured location: ${position.toJson()}");

    return position;
  }
}
