import 'package:flutter/material.dart';

import '../components/levels_chart.dart';
import '../models/station.dart';
import '../view_models/station_view_model.dart';

class StationInfoView extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  StationInfoView({super.key, required this.viewModel});

  final StationViewModel viewModel;

  @override
  Widget build(BuildContext context) {

    String getFormattedTime(DateTime date) {
      String time = "";

      if (date.hour < 12) {
        time = "${date.hour}:${date.minute} am";
      } else {
        time = "${date.hour > 12 ? date.hour - 12 : date.hour}:${date.minute} pm";
      }

      return time;
    }

    String getFormattedDate(DateTime date) {

      List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
      List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

      String formattedDate = "";

      formattedDate = "${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}";

      return formattedDate;
    }

    String getLatestLevel(Station? station) {

      String latestLevel = "";

      if (station == null || station.latestReadings.isEmpty) {
        return latestLevel;
      }

      station.latestReadings.sort((a, b) => b.dateTime.compareTo(a.dateTime));

      var latestReading = station.latestReadings[0];
      latestLevel = "${latestReading.value.toStringAsFixed(2)}m at ${getFormattedTime(latestReading.dateTime)} on ${getFormattedDate(latestReading.dateTime)}";

      return latestLevel;
    }

    String getHighestLevel(Station? station) {

      String highestLevel = "";

      if (station == null) {
        return highestLevel;
      }

      highestLevel = "${station.maxValue.toStringAsFixed(2)}m at ${getFormattedTime(station.maxDateTime)} on ${getFormattedDate(station.maxDateTime)}";

      return highestLevel;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: DataTable(
            headingRowHeight: 10,
            columnSpacing: 8,
            dataRowHeight: 28,
            dividerThickness: 0,
            dataTextStyle: const TextStyle(fontSize: 12, color: Colors.black87),
            columns: <DataColumn>[
              DataColumn(label: Container()),
              DataColumn(label: Container()),
            ],
            rows: <DataRow> [
              DataRow(
                cells: <DataCell>[
                  const DataCell(SizedBox(width: 110, child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold)))),
                  DataCell(Text(viewModel.station == null ? "" : viewModel.station!.name)),
                ]
              ),
              DataRow(
                cells: <DataCell>[
                  const DataCell(Text("Latest Level", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(getLatestLevel(viewModel.station))),
                ]
              ),
              DataRow(
                cells: <DataCell>[
                  const DataCell(Text("Highest Recorded", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(getHighestLevel(viewModel.station))),
                ]
              ),
              DataRow(
                cells: <DataCell>[
                  const DataCell(Text("Opened on", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(getFormattedDate(viewModel.station!.dateOpened))),
                ]
              ),
              DataRow(
                cells: <DataCell>[
                  const DataCell(Text("River", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(viewModel.station == null ? "" : viewModel.station!.riverName)),
                ]
              ),
              DataRow(
                cells: <DataCell>[
                  const DataCell(Text("Catchment", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(viewModel.station == null ? "" : viewModel.station!.catchmentName)),
                ]
              ),
              DataRow(
                cells: <DataCell>[
                  const DataCell(Text("Area", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(viewModel.station == null ? "" : viewModel.station!.areaName)),
                ]
              ),
            ]
          ),
        ),
        Expanded(
          child: LevelsChart(readings: viewModel.station!.latestReadings,  maxOnRecord: viewModel.station!.maxValue, typicalRangeLow: viewModel.station!.typicalRangeLow, typicalRangeHigh: viewModel.station!.typicalRangeHigh, thresholds: viewModel.station!.thresholds)
        ),
      ],
    );
  }
}