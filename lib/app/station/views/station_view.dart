
import 'package:flutter/material.dart';

import '../../../common_models/view_argument.dart';
import '../../components/tabbed_app_bar_and_nav_bar_scaffold.dart';
import 'station_info_view.dart';
import 'station_map_view.dart';
import 'station_threshold_view.dart';

class StationView extends StatelessWidget {
  const StationView({super.key});

  @override
  Widget build(BuildContext context) {
    
    var args = ModalRoute.of(context)!.settings.arguments;
    var viewArgs = args == null ? null : args as ViewArgument;
    var stationId = viewArgs == null ? 0 : viewArgs.argInt;
    String navNameOverride = viewArgs == null ? "" : viewArgs.navNameOverride;

    return TabbedAppBarAndNavBarScaffold(
      navName: "Site", navNameOverride: navNameOverride,
      body: TabBarView(
        children: [
          StationInfoView(stationId: stationId),
          StationMapView(stationId: stationId),
          StationThresholdView(stationId: stationId),
        ],
      ),
    );  
    
    // return AppBarAndNavBarScaffold(
    //   navName: "Site", navNameOverride: navNameOverride,
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         Text(
    //           "Station: $stationId",
    //           style: Theme.of(context).textTheme.headlineMedium,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

}
