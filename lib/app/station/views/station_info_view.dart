import 'package:flutter/material.dart';

import '../components/levels_chart.dart';
import '../view_models/station_view_model.dart';

class StationInfoView extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  StationInfoView({super.key, required this.viewModel});

  final StationViewModel viewModel;

  @override
  Widget build(BuildContext context) {



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
                  DataCell(Text(viewModel.getLatestLevel(viewModel.station))),
                ]
              ),
              DataRow(
                cells: <DataCell>[
                  const DataCell(Text("Highest Recorded", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(viewModel.getHighestLevel(viewModel.station))),
                ]
              ),
              DataRow(
                cells: <DataCell>[
                  const DataCell(Text("Opened on", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(viewModel.getFormattedDate(viewModel.station!.dateOpened))),
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