
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'app/TestPages/rest_api.dart';
import 'app/home/home_page.dart';
import 'app/home/about_page.dart';
import 'app/material_app_builder.dart';
import 'services/app_settings_service.dart';
import 'services/color_service.dart';
import 'services/logging_service.dart';
import 'app/pages/browse_page.dart';
import 'app/pages/search_page.dart';
import 'app/pages/my_sites_page.dart';

void main() {
  Logger.level = kDebugMode ? Level.verbose :  Level.info;
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
   const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppSettingsService>(
          create: (_) => AppSettingsService(),
        ),
        Provider<ColorService>(
          create: (_) => ColorService(),
        ),
        Provider<LoggingService>(
          create: (_) => LoggingService(),
        )
      ],
      child: MaterialAppBuilder(builder: (context) {
        final colorService = Provider.of<ColorService>(context, listen: false);
        final loggingService = Provider.of<LoggingService>(context, listen: false);

        final logger = loggingService.getLogger(this);
        logger.d("A test debug message");
        logger.i("A test info message");
        logger.e("A test error message");

        try {
          throw Exception("Exceptions own message");
        } catch (ex, st) {
          logger.e("A test error message with error", ex, st);
        }
        
        return MaterialApp(
          theme: ThemeData(primarySwatch: MaterialColor(0xFF2196F3, colorService.colorSwatchShades)),
          debugShowCheckedModeBanner: false,
          initialRoute: "/home",
          routes: {
            "/home": (_) => const HomePage(),
            "/testRestAPI": (_) => const RestApi(),
            "/about": (_) => const AboutPage(),

            "/browse": (_) => const BrowsePage(),
            "/search": (_) => const SearchPage(),
            "/mySites": (_) => const MySitesPage(),
          }
        );
      }),
    );
  }
}
