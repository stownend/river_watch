import 'package:logger/logger.dart';

import '../../../common_models/api_status.dart';
import '../../../common_models/constants.dart';
import '../../../common_services/api_service.dart';
import '../../../common_services/logging_service.dart';
import '../../../ioc.dart';
import '../models/station.dart';

class StationService {

  //#region Backing Fields
  final _loggingService = getIt.get<LoggingService>();
  final _apiService = getIt.get<ApiService>();

  static Station? _station;

  late Logger _logger;
  //#endregion Backing Fields

  StationService() {
    _logger = _loggingService.getLogger(this);
  }

  Future<Station?> getStation(int stationId) async {

    try {
      if (_station == null || _station!.id != stationId) {
        var stationResponse = await _apiService.fetchData("$API_STATION/$stationId", stationFromJson);
        
        if (stationResponse is Success) {
          _station = stationResponse.response as Station;  
        }

        if (stationResponse is Failure) {
          throw(stationResponse.errorResponse);
        }

      }
      return _station;
    } 
    catch (ex, st) {
      _logger.e("Failed to get station data", ex, st);
      rethrow;
    }
    
  }

  Future<Station?> getMyStation(int stationId, String userId) async {

    try {
      if (_station == null || _station!.id != stationId) {

        Map body = {
          "DeviceId": userId
        };

        var stationResponse = await _apiService.fetchPostData("$API_STATION/withThresholds/$stationId", body, stationFromJson);
        
        if (stationResponse is Success) {
          _station = stationResponse.response as Station;  
        }

        if (stationResponse is Failure) {
          throw(stationResponse.errorResponse);
        }

      }
      return _station;
    } 
    catch (ex, st) {
      _logger.e("Failed to get station data", ex, st);
      rethrow;
    }
    
  }
}