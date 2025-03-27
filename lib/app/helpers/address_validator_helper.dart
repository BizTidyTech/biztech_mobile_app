import 'package:biztidy_mobile_app/tidytech_app.dart';

class LocationValidator {
  // Validation rules for countries
  static final Map<String, dynamic> validationRules = {
    'Nigeria': {
      'allowedStates': [
        'Lagos',
        'Eko',
        'Abuja',
        'Federal Capital Territory',
        'FCT'
      ],
      'allowedCities': {
        'Lagos': [
          'Lagos',
          'Ikorodu',
          'Ikeja',
          'Agege',
          'Lagos Mainland',
          'Lagos Island'
        ],
        'Abuja': ['Abuja', 'FCT', 'Federal Capital Territory']
      }
    },
    'United States': {
      'allowedStates': ['Texas'],
      'allowedCities': {
        'Texas': [
          // Dallas cities and counties
          'Dallas', 'Highland Park', 'University Park', 'Addison',
          'Carrollton', 'Farmer\'s Branch', 'Irving', 'Garland',
          'Mesquite', 'Richardson', 'Rowlett',
          // Dallas County (for county-level validation)
          'Dallas County',

          // Arlington cities and counties
          'Arlington', 'Grand Prairie', 'Mansfield',
          // Tarrant County (where Arlington is located)
          'Tarrant County'
        ]
      }
    }
  };

  // Validate location based on country-specific rules
  static LocationValidationResult validateLocation(
      {required String address,
      required String country,
      required String state,
      required String cityOrCounty}) {
    // Check if country is supported
    if (!validationRules.containsKey(country)) {
      return LocationValidationResult(
          originalAddress: address,
          country: country,
          isCountrySupported: false);
    }

    // Get validation rules for the country
    final countryRules = validationRules[country];
    bool isStateValid = false, isCityValid = false;
    try {
      // Validate state
      isStateValid =
          (countryRules['allowedStates'] as List<String>).contains(state);

      // Validate city/county
      isCityValid = isStateValid &&
          (countryRules['allowedCities'][state] as List<String>)
              .contains(cityOrCounty);
    } catch (e) {
      logger.e("Error validating location: ${e.toString()}");
    }

    return LocationValidationResult(
      originalAddress: address,
      country: country,
      extractedState: state,
      extractedCityOrCounty: cityOrCounty,
      isCountrySupported: true,
      isStateValid: isStateValid,
      isCityValid: isCityValid,
    );
  }
}

// Validation result class
class LocationValidationResult {
  final String originalAddress;
  final String country;
  final String? extractedState;
  final String? extractedCityOrCounty;
  final bool isCountrySupported;
  final bool isStateValid;
  final bool isCityValid;

  LocationValidationResult({
    required this.originalAddress,
    required this.country,
    this.extractedState,
    this.extractedCityOrCounty,
    this.isCountrySupported = true,
    this.isStateValid = false,
    this.isCityValid = false,
  });

  bool get isFullyValid => isCountrySupported && isStateValid && isCityValid;

  @override
  String toString() {
    return '''
Address: $originalAddress
Country: $country
Country Supported: $isCountrySupported
State: $extractedState
City/County: $extractedCityOrCounty
State Valid: $isStateValid
City/County Valid: $isCityValid
Fully Valid: $isFullyValid
''';
  }
}
