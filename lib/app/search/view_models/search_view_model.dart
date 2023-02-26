import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../common_models/api_status.dart';
import '../../../common_models/constants.dart';
import '../../../common_services/logging_service.dart';
import '../../../ioc.dart';
import '../models/search_station_list.dart';
import '../repositories/search_service.dart';

class SearchViewModel extends ChangeNotifier
{
  final _searchService = getIt.get<SearchService>();
  final _loggingService = getIt.get<LoggingService>();
  late Logger _logger;

  SearchViewModel() {
    _logger = _loggingService.getLogger(this);
  }

  bool _loading = false;
  bool _hasError = false;
  List<SearchStationList>? _searchList;
  Failure? _browseError;
  

  bool get loading => _loading;
  bool get hasError => _hasError;
  List<SearchStationList> get searchList => _searchList??[];
  Failure get browseError => _browseError??Failure();
  
  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners(); // Update the UI
  }

  setSearchList(List<SearchStationList> searchList) async {
    _hasError = false;
    _searchList = searchList;
  }

  setBrowseError(Failure error) async {
    _browseError = error;
    _hasError = true;
  }

  getSearchList() async {
    setLoading(true);

    try {
      var searchList = await _searchService.searchStations();
      setSearchList(searchList);
    }
    catch(ex, st) {
      _logger.e("Failed to get search list", ex, st);
      Failure browseError = Failure(code: ERR_UNEXPECTED_ERROR, errorResponse: ex.toString());
      setBrowseError(browseError);
    }

    setLoading(false);
  }
}