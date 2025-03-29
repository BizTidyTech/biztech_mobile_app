// ignore_for_file: use_build_context_synchronously

import 'package:biztidy_mobile_app/app/helpers/address_validator_helper.dart';
import 'package:biztidy_mobile_app/app/helpers/sharedprefs.dart';
import 'package:biztidy_mobile_app/app/services/snackbar_service.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker_google/place_picker_google.dart';

class LocationPickerView extends StatefulWidget {
  final double longitude;
  final double latitude;
  const LocationPickerView({
    super.key,
    required this.longitude,
    required this.latitude,
  });

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      mapsBaseUrl: "https://maps.googleapis.com/maps/api/",
      usePinPointingSearch: true,
      apiKey: "${keyInParts[0]}${keyInParts[1]}",
      enableNearbyPlaces: false,
      showSearchInput: true,
      initialLocation: LatLng(widget.latitude, widget.longitude),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      myLocationFABConfig: MyLocationFABConfig(
        mini: true,
        right: 6,
        bottom: 100,
        backgroundColor: AppColors.primaryThemeColor,
      ),
      onMapCreated: (controller) {
        mapController = controller;
      },
      searchInputConfig: const SearchInputConfig(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        autofocus: false,
        textDirection: TextDirection.ltr,
      ),
      searchInputDecorationConfig: SearchInputDecorationConfig(
        hintText: "Search for closest landmarks",
        hintStyle:
            AppStyles.floatingHintStringStyle(13, color: AppColors.fullBlack),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: AppColors.primaryThemeColor),
        ),
      ),
      autocompletePlacesSearchRadius: 200,
      onPlacePicked: (LocationResult? result) async {
        if (result != null) {
          String userCountry =
              (await getLocallySavedUserDetails())?.country ?? 'Nigeria';
          if (userCountry == 'USA') {
            userCountry = 'United States';
          }
          final selectedState = result.administrativeAreaLevel1?.longName;
          final selectedCityCounty = result.administrativeAreaLevel2?.longName;
          final selectedAddress = result.formattedAddress;
          logger.f("Address picked: $selectedAddress");
          logger.w("State and country:  $selectedState, $selectedCityCounty");

          final validatorResult = LocationValidator.validateLocation(
            address: selectedAddress!,
            country: userCountry,
            state: selectedState!,
            cityOrCounty: selectedCityCounty!,
          );
          logger.f("validatorResult:  ${validatorResult.toString()}");

          if (userCountry == 'Nigeria' &&
              validatorResult.isStateValid == true) {
            logger.i("Nigerian Address selected");
            Navigator.pop(context, result);
          } else if (userCountry == 'United States' &&
              validatorResult.isStateValid == true &&
              validatorResult.isCityValid == true) {
            logger.i("US Address selected");
            Navigator.pop(context, result);
          } else {
            showCustomSnackBar(context, "Selected address is out of range");
          }
        }
      },
    );
  }
}
