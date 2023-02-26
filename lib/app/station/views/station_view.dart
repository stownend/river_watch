
import 'package:flutter/material.dart';

import '../../../common_models/view_argument.dart';
import '../../components/app_bar_and_nav_bar_scaffold.dart';

class StationView extends StatelessWidget {
  const StationView({super.key});

  @override
  Widget build(BuildContext context) {
    
    var args = ModalRoute.of(context)!.settings.arguments;
    var viewArgs = args == null ? null : args as ViewArgument;
    var stationId = viewArgs == null ? 0 : viewArgs.argInt;
    String navNameOverride = viewArgs == null ? "" : viewArgs.navNameOverride;

    return AppBarAndNavBarScaffold(
      navName: "Site", navNameOverride: navNameOverride,
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
