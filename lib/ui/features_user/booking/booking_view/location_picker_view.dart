import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
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
      apiKey: FlutterConfig.get('AIzaSyBtP7Q3qKqJHrDU9rlYfFTQk8xMsEmtvDM'),
      onPlacePicked: (LocationResult result) {
        debugPrint("Place picked: ${result.formattedAddress}");
        Navigator.of(context).pop();
      },
      enableNearbyPlaces: false,
      showSearchInput: true,
      initialLocation: LatLng(widget.latitude, widget.longitude),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (controller) {
        mapController = controller;
      },
      searchInputConfig: const SearchInputConfig(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        autofocus: false,
        textDirection: TextDirection.ltr,
      ),
      searchInputDecorationConfig: const SearchInputDecorationConfig(
        hintText: "Search for a building, street or ...",
      ),
      // selectedPlaceWidgetBuilder: (ctx, state, result) {
      //   return const SizedBox.shrink();
      // },
      autocompletePlacesSearchRadius: 150,
    );
  }
}
