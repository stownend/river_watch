import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../common_models/api_status.dart';
import '../../../common_models/constants.dart';
import '../../../common_services/logging_service.dart';
import '../../../ioc.dart';
import '../models/station.dart';
import '../repositories/station_service.dart';

class StationViewModel extends ChangeNotifier
{
  final _stationService = getIt.get<StationService>();
  final _loggingService = getIt.get<LoggingService>();
  late Logger _logger;

  StationViewModel() {
    _logger = _loggingService.getLogger(this);
  }

  bool _loading = false;
  bool _saving = false;
  bool _hasError = false;
  Station? _station;
  Failure? _browseError;
  

  bool get loading => _loading;
  bool get saving => _saving;
  bool get hasError => _hasError;
  Station? get station => _station;
  Failure get browseError => _browseError??Failure();

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners(); // Update the UI
  }

  setSaving(bool saving) async {
    _saving = saving;
    notifyListeners(); // Update the UI
  }

  setStation(Station? station) async {
    _hasError = false;
    _station = station;
  }

  setBrowseError(Failure error) async {
    _browseError = error;
    _hasError = true;
  }

  getStation(int stationId) async {
    setLoading(true);

    try {
      Station? station;

      // If we have user info
      var deviceId = "2a1cd97945f7cc66";

      if (deviceId != "") {
        station = await _stationService.getMyStation(stationId, deviceId);
      } else {
        station = await _stationService.getStation(stationId);
      }
      setStation(station!);
    }
    catch(ex, st) {
      _logger.e("Failed to get station", ex, st);
      Failure browseError = Failure(code: ERR_UNEXPECTED_ERROR, errorResponse: ex.toString());
      setBrowseError(browseError);
    }

    setLoading(false);
  }

  Future saveThresholds(int measureId, Thresholds thresholds) async {
    setSaving(true);

    try {
        await _stationService.saveThresholds(measureId, thresholds);
    }
    catch(ex, st) {
      _logger.e("Failed to save thresholds", ex, st);
      Failure browseError = Failure(code: ERR_UNEXPECTED_ERROR, errorResponse: ex.toString());
      setBrowseError(browseError);
    }

    setSaving(false);
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

  String getHighestLevel(Station? station) {

    String highestLevel = "";

    if (station == null) {
      return highestLevel;
    }

    highestLevel = "${station.maxValue.toStringAsFixed(2)}m at ${getFormattedTime(station.maxDateTime)} on ${getFormattedDate(station.maxDateTime)}";

    return highestLevel;
  }

}