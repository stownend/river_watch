import 'package:flutter/material.dart';

class StationMapView extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  StationMapView({super.key, required this.stationId});

  final int stationId;

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Station Map for: $stationId",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}