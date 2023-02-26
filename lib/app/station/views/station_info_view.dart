import 'package:flutter/material.dart';

class StationInfoView extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  StationInfoView({super.key, required this.stationId});

  final int stationId;

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Station Info for: $stationId",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}