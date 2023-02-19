import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../common_models/api_status.dart';
import '../../../common_models/constants.dart';
import '../../../common_services/logging_service.dart';
import '../../../ioc.dart';
import '../models/browse_list.dart';
import '../repositories/browse_service.dart';

class BrowseViewModel extends ChangeNotifier
{
  final _browseService = getIt.get<BrowseService>();
  final _loggingService = getIt.get<LoggingService>();
  late Logger _logger;

  BrowseViewModel() {
    _logger = _loggingService.getLogger(this);
    getBrowseList("");
  }

  bool _loading = false;
  bool _hasError = false;
  BrowseList? _browseList;
  Failure? _browseError;
  String _parents = "";

  bool get loading => _loading;
  bool get hasError => _hasError;
  BrowseList get browseList => _browseList??BrowseList();
  Failure get browseError => _browseError??Failure();
  String get parents => _parents;

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners(); // Update the UI
  }

  setBrowseList(BrowseList browseList) async {
    _hasError = false;
    _browseList = browseList;
  }

  setBrowseError(Failure error) async {
    _browseError = error;
    _hasError = true;
  }

  getBrowseList(String parents) async {
    setLoading(true);

    try {
      _parents = parents;

      List<String> parentList = parents == "" ? [] : parents.split('|');

      var browseList = await _browseService.getBrowseList(parentList);
      setBrowseList(browseList);
    }
    catch(ex, st) {
      _logger.e("Failed to get browse list", ex, st);
      Failure browseError = Failure(code: ERR_UNEXPECTED_ERROR, errorResponse: ex.toString());
      setBrowseError(browseError);
    }

    setLoading(false);
  }

  String getNewParents(String parent) {
    return "$_parents${_parents.isEmpty ? "" : "|"}$parent";
  }
}