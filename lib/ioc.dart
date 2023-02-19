import 'package:get_it/get_it.dart';

import 'app/browse/repositories/browse_service.dart';

import 'common_services/app_settings_service.dart';
import 'common_services/api_service.dart';
import 'common_services/logging_service.dart';
import 'common_services/color_service.dart';

GetIt getIt = GetIt.instance;

void getServices() {
  //getIt.registerFactory(() => LoggingService());

  getIt.registerFactory(() => ColorService());
  getIt.registerFactory(() => LoggingService());
  getIt.registerFactory(() => AppSettingsService());
  getIt.registerFactory(() => ApiService());  

  getIt.registerFactory(() => BrowseService());
  //getIt.registerLazySingleton(() => OtherService());
}