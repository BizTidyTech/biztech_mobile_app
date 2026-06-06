import 'package:biztidy_mobile_app/app/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

GetIt _getIt = GetIt.I;

final locator = _getIt;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => NavigationService());
}
