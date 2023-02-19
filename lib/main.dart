
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'app/browse/view_models/browse_view_model.dart';
import 'app/home/home_page.dart';
import 'app/home/about_page.dart';
import 'app/material_app_builder.dart';
import 'ioc.dart';
import 'common_services/color_service.dart';
import 'app/browse/views/browse_view.dart';
import 'app/search/views/search_view.dart';
import 'app/pages/favourites_page.dart';

void main() {
  getServices();
  Logger.level = kDebugMode ? Level.verbose :  Level.info;
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
   const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BrowseViewModel>(
          create: (_) => BrowseViewModel(),
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
          theme: ThemeData(primarySwatch: MaterialColor(0xFF2196F3, _colorService.colorSwatchShades)),
          debugShowCheckedModeBanner: false,
          initialRoute: "/home",
          routes: {
            "/home": (_) => const HomePage(),
            "/about": (_) => const AboutPage(),

            "/browse": (_) => const BrowseView(),
            "/search": (_) => const SearchView(),
            "/favourites": (_) => const FavouritesPage(),
          }
        );
      }),
    );
  }
}
