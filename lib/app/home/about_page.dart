// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../ioc.dart';
import '../../common_services/app_settings_service.dart';
import '../components/app_bar_and_nav_bar_scaffold.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _appSettingsService = getIt.get<AppSettingsService>();

    return AppBarAndNavBarScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("${(kDebugMode && kIsWeb)?"":"assets/"}${_appSettingsService.appLogo}", width: 96,),
            const SizedBox(height: 64),
            Text(
              _appSettingsService.appName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            Text(
              'by ${_appSettingsService.author}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            Text(
              'Available at:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              _appSettingsService.appUrl,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}