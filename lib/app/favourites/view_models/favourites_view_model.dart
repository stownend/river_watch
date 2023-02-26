import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../common_models/api_status.dart';
import '../../../common_models/constants.dart';
import '../../../common_services/logging_service.dart';
import '../../../ioc.dart';
import '../models/favourites_list.dart';
import '../repositories/favourites_service.dart';

class FavouritesViewModel extends ChangeNotifier {

  final _favouritesService = getIt.get<FavouritesService>();
  final _loggingService = getIt.get<LoggingService>();
  late Logger _logger;

  FavouritesViewModel() {
    _logger = _loggingService.getLogger(this);
  }

  bool _loading = false;
  bool _hasError = false;
  List<FavouritesList>? _favouritesList;
  Failure? _browseError;

  bool get loading => _loading;
  bool get hasError => _hasError;
  List<FavouritesList> get favouritesList => _favouritesList??[];
  Failure get browseError => _browseError??Failure();
  
  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners(); // Update the UI
  }

  setBrowseError(Failure error) async {
    _browseError = error;
    _hasError = true;
  }

  setFavouritesList(List<FavouritesList> list) async {
    _hasError = false;
    _favouritesList = list;
  }

  getFavouritesList() async {
    setLoading(true);

    try {
      var list = await _favouritesService.getMyFavourites();
      setFavouritesList(list);
    }
    catch(ex, st) {
      _logger.e("Failed to get favourites list", ex, st);
      Failure browseError = Failure(code: ERR_UNEXPECTED_ERROR, errorResponse: ex.toString());
      setBrowseError(browseError);
    }

    setLoading(false);
  }

}