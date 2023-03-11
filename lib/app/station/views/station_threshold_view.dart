import 'package:flutter/material.dart';

import '../view_models/station_view_model.dart';

class StationThresholdView extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  StationThresholdView({super.key, required this.viewModel});

  final StationViewModel viewModel;

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Station Threshold for: ${viewModel.station!.id}",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}