
import 'package:flutter/material.dart';

import '../../components/app_bar_and_nav_bar_scaffold.dart';

class StationView extends StatelessWidget {
  const StationView({super.key});

  @override
  Widget build(BuildContext context) {
    
    var args = ModalRoute.of(context)!.settings.arguments;
    var stationId = args == null ? 0 : args as int;

    return AppBarAndNavBarScaffold(
      navName: "Site",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Station: $stationId",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );

  }

}
