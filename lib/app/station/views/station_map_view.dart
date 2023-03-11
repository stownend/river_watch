import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/station.dart';
import '../view_models/station_view_model.dart';

class StationMapView extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  StationMapView({super.key, required this.viewModel});

  final StationViewModel viewModel;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => StationMapViewState(viewModel: viewModel);

}

class StationMapViewState extends State<StationMapView> {
  StationMapViewState({required this.viewModel });

  final StationViewModel viewModel;

  late GoogleMapController mapController;
  final List<Marker> _markers = [];
  bool showMaps = true;

  late Station station;
  late double lat = 53;
  late double long = 0;

  @override
  void initState() {
    super.initState();
  
    station = viewModel.station!;

    _markers.add(
      Marker(
        markerId: const MarkerId("Site name here..."),
        position: LatLng(station.lat, station.long)
      )
    );

    if (_markers.isNotEmpty) {
      setState(() {
        showMaps = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(10),
      child: showMaps 
        ? GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            markers: Set<Marker>.of(_markers),
            mapType: MapType.hybrid,

            initialCameraPosition: CameraPosition(
              target: LatLng(station.lat, station.long), zoom: 14.3
            ),
          )
        : const CircularProgressIndicator(
            color: Colors.blue
          )
    );
    // return Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Text(
    //         "Station Map for: $stationId",
    //         style: Theme.of(context).textTheme.titleSmall,
    //       ),
    //     ],
    //   ),
    // );
  }
}