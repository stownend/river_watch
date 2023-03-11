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
  bool _hasError = false;
  Station? _station;
  Failure? _browseError;
  

  bool get loading => _loading;
  bool get hasError => _hasError;
  Station? get station => _station;
  Failure get browseError => _browseError??Failure();

  setLoading(bool loading) async {
    _loading = loading;
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
}