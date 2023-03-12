import 'package:get_it/get_it.dart';

import 'app/browse/repositories/browse_service.dart';

import 'app/favourites/repositories/favourites_service.dart';
import 'app/search/repositories/search_service.dart';
import 'app/station/repositories/station_service.dart';
import 'common_services/app_settings_service.dart';
import 'common_services/api_service.dart';
import 'common_services/logging_service.dart';
import 'common_services/color_service.dart';
import 'common_services/user_service.dart';

GetIt getIt = GetIt.instance;

void getServices() {
  //getIt.registerFactory(() => LoggingService());

  getIt.registerFactory(() => ColorService());
  getIt.registerFactory(() => LoggingService());
  getIt.registerFactory(() => AppSettingsService());
  getIt.registerFactory(() => ApiService());  
  getIt.registerFactory(() => UserService());  

  getIt.registerLazySingleton(() => BrowseService());
  getIt.registerFactory(() => SearchService());
  getIt.registerFactory(() => FavouritesService());
  getIt.registerFactory(() => StationService());

  //getIt.registerLazySingleton(() => OtherService());
}