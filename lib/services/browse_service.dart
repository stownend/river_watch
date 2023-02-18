import 'package:logger/logger.dart';

import '../ioc.dart';
import '../models/navigation.dart';
import '../models/browse_list.dart';

import 'app_settings_service.dart';
import 'logging_service.dart';
import 'api_service.dart';


class BrowseService{

  //#region Backing Fields
  final _appSettingsService = getIt.get<AppSettingsService>();
  final _loggingService = getIt.get<LoggingService>();
  final _apiService = getIt.get<ApiService>();

  static List<RegionDto> _hierarchy = [];
  late Logger _logger;
  //#endregion Backing Fields

  BrowseService() {
    _logger = _loggingService.getLogger(this);
  }

  Future<List<RegionDto>> getHierarchy() async {

    late Future<List<RegionDto>> hierarchy;

    _logger.i("How does this look?");

    try {
      hierarchy = _apiService.fetchData<List<RegionDto>>(_appSettingsService.apiEndpoints["Browse"]?? "", NavigationData.getRegions);
    } 
    catch (ex, st) {
      _logger.e("Failed to get browse hierarchy", ex, st);
      rethrow;
    }

    return hierarchy;
  }

  Future<BrowseList> getBrowseList(List<String> parents) async {

    var browseList = BrowseList();

    for (var parent in parents) {
      browseList.breadCrumbs += browseList.breadCrumbs == "" ? parent : ", $parent";
    }

    if (_hierarchy.isEmpty) {
      _hierarchy = await getHierarchy();
    }

    if (parents.isEmpty)
    {
        browseList.scope = "Regions";

        for (var region in _hierarchy)
        {
            browseList.names.add(region.name);
        }
    } else if (parents.length == 1)
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

    return browseList;
  }
}