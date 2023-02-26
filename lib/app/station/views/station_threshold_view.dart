import 'package:flutter/material.dart';

class StationThresholdView extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  StationThresholdView({super.key, required this.stationId});

  final int stationId;

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Station Threshold for: $stationId",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}