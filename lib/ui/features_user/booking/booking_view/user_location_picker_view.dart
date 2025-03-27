import 'dart:async';

import 'package:biztidy_mobile_app/app/helpers/location_services.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';

class UserLocationPickerView extends StatefulWidget {
  final double longitude;
  final double latitude;
  final double accuracy;
  const UserLocationPickerView({
    super.key,
    required this.longitude,
    required this.latitude,
    required this.accuracy,
  });

  @override
  State<UserLocationPickerView> createState() => _UserLocationPickerViewState();
}

class _UserLocationPickerViewState extends State<UserLocationPickerView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  LatLng? _selectedPosition;

  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;

  MapType _currentMapType = MapType.normal;

  late CameraPosition _cameraInitialLocation;

  Set<Marker> _markers = {};

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  Future<void> _getCurrentLocation() async {
    _currentPosition = await LocationServices().captureLocation(context);
  }

  Future<void> _goToMyLocation() async {
    final GoogleMapController controller = await _controller.future;
    final myLocation = CameraPosition(
      target: LatLng(
        _currentPosition?.latitude ?? widget.latitude,
        _currentPosition?.longitude ?? widget.latitude,
      ),
      zoom: 10.5,
      bearing: 192.8334901395799,
      tilt: 59.440717697143555,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(myLocation));
  }

  void _startLocationUpdates() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  void _setMarkers() {
    // Create the destination marker.
    Marker destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      position: LatLng(
        _cameraInitialLocation.target.latitude,
        _cameraInitialLocation.target.longitude,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: 'Destination'),
    );

    setState(() {
      _markers = {destinationMarker};
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedPosition = LatLng(widget.latitude, widget.longitude);
    _cameraInitialLocation = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 16.5,
      bearing: 192.8334901395799,
      tilt: 59.440717697143555,
    );
    _getCurrentLocation();
    _startLocationUpdates();
    _setMarkers();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.plainWhite,
      ),
      child: Scaffold(
        backgroundColor: AppColors.plainWhite,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
          child: CustomButton(
            buttonText: AppStrings.confirm,
            onPressed: () {
              Navigator.pop(context, _selectedPosition);
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              width: screenWidth(context),
              height: screenHeight(context) - (180),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Container(
                    width: screenWidth(context),
                    height: screenHeight(context) - (180),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapType: _currentMapType,
                      initialCameraPosition: _cameraInitialLocation,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      zoomControlsEnabled: false,
                      onTap: (argument) {
                        setState(() {
                          _selectedPosition = argument;
                        });
                      },
                      cameraTargetBounds: CameraTargetBounds(
                        AllowedStateBounds.lagosStateBounds,
                      ),
                      markers: _markers,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: SizedBox(
                      width: 60,
                      height: 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.plainWhite,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Ionicons.layers_outline,
                                color: AppColors.coolRed,
                              ),
                              onPressed: _onMapTypeButtonPressed,
                              tooltip: 'Change Map Type',
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.plainWhite,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.my_location,
                                color: AppColors.coolRed,
                              ),
                              onPressed: _goToMyLocation,
                              tooltip: 'My Location',
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.plainWhite,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.location_on_outlined,
                                color: AppColors.coolRed,
                              ),
                              onPressed: _goToPropertyLocation,
                              tooltip: 'Property Location',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      locationEntityWidget(
                        "Latitude",
                        "${_selectedPosition!.latitude}°",
                      ),
                      locationEntityWidget(
                        "Longitude",
                        "${_selectedPosition!.longitude}°",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goToPropertyLocation() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_cameraInitialLocation),
    );
  }
}

Widget locationEntityWidget(String label, String value) {
  return SizedBox(
    height: 48,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.normalStringStyle(12, AppColors.fullBlack),
        ),
        verticalSpacer(6),
        Text(
          value,
          style: AppStyles.regularStringStyle(16, AppColors.fullBlack),
        ),
      ],
    ),
  );
}

class AllowedStateBounds {
  // Oyo State Bounds
  static final LatLngBounds oyoStateBounds = LatLngBounds(
      southwest: const LatLng(7.2, 3.5), // Southwestern point
      northeast: const LatLng(8.9, 4.5) // Northeastern point
      );

  // Lagos State Bounds
  static final LatLngBounds lagosStateBounds = LatLngBounds(
      southwest: const LatLng(6.3, 3.0), // Southwestern point
      northeast: const LatLng(6.7, 3.7) // Northeastern point
      );

  // Ogun State Bounds
  static final LatLngBounds ogunStateBounds = LatLngBounds(
      southwest: const LatLng(6.5, 3.0), // Southwestern point
      northeast: const LatLng(7.5, 4.0) // Northeastern point
      );

  // Example usage in Google Maps widget
  void setStateView(GoogleMapController controller, LatLngBounds stateBounds) {
    controller
        .animateCamera(CameraUpdate.newLatLngBounds(stateBounds, 50 // padding
            ));
  }
}
