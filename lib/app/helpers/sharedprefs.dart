// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:biztidy_mobile_app/ui/features_user/auth/auth_model/user_data_model.dart';
import 'package:biztidy_mobile_app/utils/app_constants/fb_collection_names.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveSharedPrefsStringValue(
    String stringKey, String stringValue) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(stringKey, stringValue);
  print('Saved $stringKey as $stringValue');
}

Future<String> getSharedPrefsSavedString(String stringKey) async {
  final prefs = await SharedPreferences.getInstance();
  final String? readValue = prefs.getString(stringKey);
  print('Retrieved value for $stringKey is $readValue.');
  return readValue ?? '';
}

saveUserDetailsLocally(UserData? userData) async {
  await saveSharedPrefsStringValue(
      FbCollectionNames.user, jsonEncode(userData));
}

Future<UserData?> getLocallySavedUserDetails() async {
  try {
    final userDataString =
        await getSharedPrefsSavedString(FbCollectionNames.user);
    if (userDataString == '') {
      return null;
    }
    return UserData.fromJson(jsonDecode(userDataString));
  } catch (e) {
    return null;
  }
}
