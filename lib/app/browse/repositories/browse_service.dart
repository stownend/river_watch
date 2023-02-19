import 'package:logger/logger.dart';

import '../../../common_models/api_status.dart';
import '../../../common_models/constants.dart';
import '../../../ioc.dart';

import '../../../common_services/logging_service.dart';
import '../../../common_services/api_service.dart';
import '../models/browse_list.dart';
import '../models/hierachy.dart';
import '../models/station_header.dart';


class BrowseService{

  //#region Backing Fields
  final _loggingService = getIt.get<LoggingService>();
  final _apiService = getIt.get<ApiService>();

  static List<Hierarchy> _hierarchy = [];
  static List<StationHeader> _stations = [];

  late Logger _logger;
  //#endregion Backing Fields

  BrowseService() {
    _logger = _loggingService.getLogger(this);
  }

  Future<Object> getHierarchy() async {

    try {
      var hierarchyResponse = await _apiService.fetchData(API_BROWSE, hierarchyFromJson);
      return hierarchyResponse;
    } 
    catch (ex, st) {
      _logger.e("Failed to get browse hierarchy", ex, st);
      rethrow;
    }
    
  }

  Future<BrowseList> getBrowseList(List<String> parents) async {

    var browseList = BrowseList();

    for (var parent in parents) {
      browseList.breadCrumbs += browseList.breadCrumbs == "" ? parent : ", $parent";
    }

    if (_hierarchy.isEmpty) {

      var hierarchyResponse = await getHierarchy();
  
      if (hierarchyResponse is Success) {
        _hierarchy = hierarchyResponse.response as List<Hierarchy>;  
      }

      if (hierarchyResponse is Failure) {
        throw(hierarchyResponse.errorResponse);
      }
    }

    if (parents.isEmpty)
    {
      browseList.scope = "Regions";

      for (var region in _hierarchy)
      {
          browseList.names.add(region.name);
      }
    } 
    else if (parents.length == 1)
    {
      browseList.scope = "Areas";

      try
      {
        for (var area in _hierarchy.firstWhere((r) => r.name.toUpperCase() == parents[0].toUpperCase()).areas)
        {
          browseList.names.add(area.name);
        }
      }
      catch (ex, st)
      {
        _logger.e("Could not find Region ${parents[0]}", ex, st);
        rethrow;
      }
    } 
    else if (parents.length == 2) 
    {
      browseList.scope = "Catchments";

      try
      {
        for (var catchment in _hierarchy
                                .firstWhere((r) => r.name.toUpperCase() == parents[0].toUpperCase()).areas
                                .firstWhere((a) => a.name.toUpperCase() == parents[1].toUpperCase()).catchments)
        {
          browseList.names.add(catchment.name);
        }
      }
      catch (ex, st)
      {
        _logger.e("Could not find Area ${parents[1]}", ex, st);
        rethrow;
      }
    }
    else if (parents.length == 3) 
    {
      browseList.scope = "Rivers";

      try
      {
        for (var river in _hierarchy
                            .firstWhere((r) => r.name.toUpperCase() == parents[0].toUpperCase()).areas
                            .firstWhere((a) => a.name.toUpperCase() == parents[1].toUpperCase()).catchments
                            .firstWhere((c) => c.name.toUpperCase() == parents[2].toUpperCase()).rivers)
        {
          browseList.names.add(river.name);
        }
      }
      catch (ex, st)
      {
        _logger.e("Could not find Catchment ${parents[2]}", ex, st);
        rethrow;
      }
    }
    else if (parents.length == 4) 
    {
      browseList.scope = "Sites";

      try
      {
        var river = _hierarchy
                      .firstWhere((r) => r.name.toUpperCase() == parents[0].toUpperCase()).areas
                      .firstWhere((a) => a.name.toUpperCase() == parents[1].toUpperCase()).catchments
                      .firstWhere((c) => c.name.toUpperCase() == parents[2].toUpperCase()).rivers
                      .firstWhere((r) => r.name.toUpperCase() == parents[3].toUpperCase());

        var stationResponse = await _getStationsInRiver(river.id);
  
        if (stationResponse is Success) {
          _stations = stationResponse.response as List<StationHeader>;  

          for (var station in _stations)
          {
              browseList.names.add(station.label);
          }
        }

        if (stationResponse is Failure) {
          throw(stationResponse.errorResponse);
        }

      }
      catch (ex, st)
      {
        _logger.e("Could not find Sites in River ${parents[3].toUpperCase()}", ex, st);
        rethrow;
      }
    }

    return browseList;
  }

  Future<Object> _getStationsInRiver(int riverId) async
  {
    try {
      var stationResponse = await _apiService.fetchData("$API_STATIONS_IN_RIVER/$riverId", stationHeaderFromJson);
      return stationResponse;
    } 
    catch (ex, st) {
      _logger.e("Failed to get station headers", ex, st);
      rethrow;
    }
  }

}