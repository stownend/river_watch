
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_models/view_argument.dart';
import '../../components/app_error.dart';
import '../../components/app_loading.dart';
import '../../components/tabbed_app_bar_and_nav_bar_scaffold.dart';
import '../view_models/station_view_model.dart';
import 'station_info_view.dart';
import 'station_map_view.dart';
import 'station_threshold_view.dart';

class StationView extends StatefulWidget {
  const StationView({super.key});

  @override
  StationViewState createState() => StationViewState();
}

class StationViewState extends State<StationView> {

  late StationViewModel _viewModel;
  late String navNameOverride = "";
  late int stationId = 0;

  @override
  void initState() {

    _viewModel = Provider.of<StationViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      var args = ModalRoute.of(context)!.settings.arguments;
      var viewArgs = args == null ? null : args as ViewArgument;
      stationId = viewArgs == null ? 0 : viewArgs.argInt;
      navNameOverride = viewArgs == null ? "" : viewArgs.navNameOverride;

      _viewModel.getStation(stationId);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    

    return Consumer<StationViewModel>(
        builder: (_, model, child) {
          return TabbedAppBarAndNavBarScaffold(
            navName: "Site", navNameOverride: navNameOverride,
            body: _ui(_viewModel)
          );
        }
    );
  }

  _ui(StationViewModel viewModel) {

    if (viewModel.loading) {
      return const AppLoading(); 
    }
  
    if (viewModel.hasError) {
      return AppError(appError: viewModel.browseError); 
    }

    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        StationInfoView(viewModel: _viewModel),
        StationMapView(viewModel: _viewModel),
        StationThresholdView(viewModel: _viewModel),
      ],
    );
  }
}
