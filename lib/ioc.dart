import 'package:get_it/get_it.dart';
import 'package:river_watch/services/api_service.dart';
import 'package:river_watch/services/app_settings_service.dart';
import 'package:river_watch/services/browse_service.dart';
import 'package:river_watch/services/logging_service.dart';
// import 'services/browse_service.dart';
// import 'services/app_settings_service.dart';
// import 'services/api_service.dart';
// import 'services/logging_service.dart';

GetIt getIt = GetIt.instance;

void getServices() {
  //getIt.registerFactory(() => LoggingService());
  getIt.registerFactory(() => BrowseService());


  getIt.registerFactory(() => ApiService());  

  getIt.registerFactory(() => LoggingService());
  getIt.registerFactory(() => AppSettingsService());
  //getIt.registerLazySingleton(() => OtherService());
}