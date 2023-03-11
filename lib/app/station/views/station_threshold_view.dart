// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../view_models/station_view_model.dart';

class StationThresholdView extends StatefulWidget {
  const StationThresholdView({super.key, required this.viewModel});

  final StationViewModel viewModel;
  
    @override
  State<StatefulWidget> createState() => StationThresholdViewState();
}

class StationThresholdViewState extends State<StationThresholdView> {

  late StationViewModel viewModel = widget.viewModel;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var _currentHighThreshold = viewModel.station!.thresholds.high;
    var _currentLowThreshold = viewModel.station!.thresholds.low;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "You can define high and low thresholds to represent the ideal water level for your activity. For example, fishing at this location may be impractical if the water is above or below the thresholds you define here.",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          Text(
            "Latest Level - for reference",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            viewModel.getLatestLevel(viewModel.station),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "High Water Threshold (in Metres)"),
                  initialValue: viewModel.station!.thresholds.high.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (val) {
                    if (isNumeric(val!)) {
                      if (double.parse(val) <= _currentLowThreshold) {
                        return "Must be higher than the low threshold";
                      } else {
                        _currentHighThreshold = double.parse(val);
                        return null;
                      }
                    } else {
                      return "Must be numeric";
                    }
                  },
                  onSaved: (val) => setState(() => 
                    viewModel.station!.thresholds.high = double.parse(val!)
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Low Water Threshold (in Metres)"),
                  initialValue: viewModel.station!.thresholds.low.toString(),
                  inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (val) {
                    if (isNumeric(val!)) {
                      if (double.parse(val) >= _currentHighThreshold) {
                        return "Must be lower than the high threshold";
                      } else {
                        _currentLowThreshold = double.parse(val);
                        return null;
                      }
                    } else {
                      return "Must be numeric";
                    }
                  },
                  onSaved: (val) => setState(() => 
                    viewModel.station!.thresholds.low = double.parse(val!)
                  ),
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: Text(
                    "Receive alerts when your thresholds are breached?",
                    style: Theme.of(context).textTheme.bodyMedium
                  ), 
                  value: viewModel.station!.thresholds.notify, 
                  onChanged: (bool val) {
                    setState(() => viewModel.station!.thresholds.notify = val);
                  }
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final form = _formKey.currentState;

                          if (form!.validate()) {
                            form.save();
                          }
                        },
                        child: const Text("Save as Favourite")
                      ),
                      const SizedBox(height: 100),
                      Text(
                        "Removing this site from Favourites will remove any existing thresholds for this site and will stop all alerts related to this site.",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                        },
                        child: const Text("Remove from Favourites")
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

  bool isNumeric(String? s) {
    if(s == null) {
      return false;
    }

    return double.tryParse(s) != null;
  }
}