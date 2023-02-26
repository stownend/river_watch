import 'package:logger/logger.dart';

import '../../../common_models/api_status.dart';
import '../../../common_models/constants.dart';
import '../../../ioc.dart';

import '../../../common_services/logging_service.dart';
import '../../../common_services/api_service.dart';
import '../models/search_station_list.dart';


class SearchService{

  //#region Backing Fields
  final _loggingService = getIt.get<LoggingService>();
  final _apiService = getIt.get<ApiService>();

  static List<SearchStationList> _searchStations = [];

  late Logger _logger;
  //#endregion Backing Fields

  SearchService() {
    _logger = _loggingService.getLogger(this);
  }

  Future<List<SearchStationList>> searchStations() async {

    try {
      if (_searchStations.isEmpty) {
        var searchResponse = await _apiService.fetchData(API_SEARCH_STATIONS, searchStationListFromJson);
        
        if (searchResponse is Success) {
          _searchStations = searchResponse.response as List<SearchStationList>;  
        }

        if (searchResponse is Failure) {
          throw(searchResponse.errorResponse);
        }

      }
      return _searchStations;
    } 
    catch (ex, st) {
      _logger.e("Failed to get search data", ex, st);
      rethrow;
    }
    
  }


}