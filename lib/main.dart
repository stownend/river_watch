
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'app/browse/repositories/browse_service.dart';
import 'app/browse/view_models/browse_view_model.dart';
import 'app/favourites/view_models/favourites_view_model.dart';
import 'app/home/home_page.dart';
import 'app/home/about_page.dart';
import 'app/material_app_builder.dart';
import 'app/search/view_models/search_view_model.dart';
import 'app/station/view_models/station_view_model.dart';
import 'app/station/views/station_view.dart';
import 'common_models/constants.dart';
import 'common_services/logging_service.dart';
import 'ioc.dart';
import 'common_services/color_service.dart';
import 'app/browse/views/browse_view.dart';
import 'app/search/views/search_view.dart';
import 'app/favourites/views/favourites_view.dart';

void main() {
  getServices();
  Logger.level = kDebugMode ? Level.verbose :  Level.info;
  runApp(MyApp());
} 

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
   MyApp({super.key});
  
  late BrowseService _browseService;
  late LoggingService _loggingService;
  late Logger _logger;

  @override
  Widget build(BuildContext context) {

    _browseService = getIt.get<BrowseService>();
    _loggingService = getIt.get<LoggingService>();
    
    _logger = _loggingService.getLogger(this);

    getBrowseList();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchViewModel>(
          create: (_) => SearchViewModel(),
        ),
        ChangeNotifierProvider<BrowseViewModel>(
          create: (_) => BrowseViewModel(),
        ),
        ChangeNotifierProvider<FavouritesViewModel>(
          create: (_) => FavouritesViewModel(),
        ),
        ChangeNotifierProvider<StationViewModel>(
          create: (_) => StationViewModel(),
        ),
      ],
      child: MaterialAppBuilder(builder: (context) {
        var _colorService = getIt.get<ColorService>();
        // final _loggingService = getIt.get<LoggingService>();

        // final logger = loggingService.getLogger(this);
        // logger.d("A test debug message");
        // logger.i("A test info message");
        // logger.e("A test error message");

        // try {
        //   throw Exception("Exceptions own message");
        // } catch (ex, st) {
        //   logger.e("A test error message with error", ex, st);
        // }
        
        return MaterialApp(
          scaffoldMessengerKey: snackbarKey,
          theme: ThemeData(primarySwatch: MaterialColor(0xFF2196F3, _colorService.colorSwatchShades)),
          debugShowCheckedModeBanner: false,
          initialRoute: "/home",
          routes: {
            "/home": (_) => const HomePage(),
            "/about": (_) => const AboutPage(),

            "/browse": (_) => BrowseView(),
            "/search": (_) => const SearchView(),
            "/favourites": (_) => const FavouritesView(),

            "/station": (_) => const StationView(),

          }
        );
      }),
    );


  }

  getBrowseList() async {

    try {
      await _browseService.getBrowseList([]);
    }
    catch(ex, st) {
      _logger.e("Failed to get browse list", ex, st);
    }
  }

}
