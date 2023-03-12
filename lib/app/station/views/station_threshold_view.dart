// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common_models/constants.dart';
import '../../../common_services/user_service.dart';
import '../../../ioc.dart';
import '../models/station.dart';
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

  final _userService = getIt.get<UserService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double _currentHighThreshold = 0;
    double _currentLowThreshold = 0;
    bool _currentNotify = true;
    
    if (viewModel.station!.thresholds != null) {
      _currentHighThreshold = viewModel.station!.thresholds!.high;
      _currentLowThreshold = viewModel.station!.thresholds!.low;
      _currentNotify = viewModel.station!.thresholds!.notify;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: viewModel.station!.latestReadings.isEmpty ? 
          Text(
            "Sorry! This site has not reported any data. Therefore its thresholds can't be changed at present.", 
            style: Theme.of(context).textTheme.bodyMedium
          ) : 
          Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            Text(
              "Your site settings for ${viewModel.station!.name}: -",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: "High Water Threshold (in Metres)"),
                          initialValue: _currentHighThreshold.toString(),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
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
                            _currentHighThreshold = double.parse(val!)
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Low Water Threshold (in Metres)"),
                          initialValue: _currentLowThreshold.toString(),
                          inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
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
                            _currentLowThreshold = double.parse(val!)
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    title: Text(
                      "Receive alerts when your thresholds are breached?",
                      style: Theme.of(context).textTheme.bodySmall
                    ), 
                    value: _currentNotify, 
                    onChanged: (bool val) {
                      setState(() => _currentNotify = val);
                    }
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      verticalDirection: VerticalDirection.down,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: viewModel.saving ? null : () async {
                            final form = _formKey.currentState;

                            if (form!.validate()) {
                              form.save();
                              try {
                                Thresholds newThresholds;
                                if (viewModel.station!.thresholds != null) {
                                  // Create a clone of the current thresholds
                                  newThresholds = Thresholds.fromJson(json.decode(json.encode(viewModel.station!.thresholds)));
                                } else {
                                  newThresholds = Thresholds(
                                    id: 0, 
                                    stationId: viewModel.station!.id, 
                                    deviceId: _userService.user.id, 
                                    installId: "", 
                                    os: "", 
                                    low: 0, 
                                    high: 0, 
                                    notify: true, 
                                    lastNotified: DateTime.now()
                                  );
                                }

                                newThresholds.low = _currentLowThreshold;
                                newThresholds.high = _currentHighThreshold;
                                newThresholds.notify = _currentNotify;

                                newThresholds.id = await viewModel.saveThresholds(viewModel.station!.measureId, newThresholds);

                                viewModel.station!.thresholds = newThresholds;

                                showMessage(message: "Site settings saved successfully!");
                              } catch (e) {
                                showMessage(message: "Error saving site settings!", failed: true);
                              }
                            }
                          },
                          child: viewModel.saving ? const Text("Saving...") : const Text("Save as Favourite")
                        ),
                        const SizedBox(height: 50),
                        Text(
                          "Removing this site from Favourites will remove any existing thresholds for this site and will stop all alerts related to this site.",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: viewModel.deleting ? null : () async {
                            try {
                              await viewModel.deleteFavourite(viewModel.station!.id, viewModel.station!.thresholds!.deviceId);
                              viewModel.station!.thresholds = null;
                              showMessage(message: "Site is no longer a favourite!");
                            } catch (e) {
                              showMessage(message: "Error removing site as a favourite!", failed: true);
                            }
                          },
                          child: viewModel.deleting ? const Text("Deleting...") : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Remove from Favourites "),
                              Icon(Icons.delete_forever_rounded),
                            ],
                          ), 
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isNumeric(String? s) {
    if(s == null) {
      return false;
    }

    return double.tryParse(s) != null;
  }
  
  void showMessage({required String message, bool failed = false}) {
    snackbarKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: failed ? Colors.red : Colors.green,
      )
    );
  }
}