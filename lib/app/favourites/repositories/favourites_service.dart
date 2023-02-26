import 'package:logger/logger.dart';

import '../../../common_models/api_status.dart';
import '../../../common_models/constants.dart';
import '../../../common_services/api_service.dart';
import '../../../common_services/logging_service.dart';
import '../../../ioc.dart';
import '../models/favourites_list.dart';

class FavouritesService {

  //#region Backing Fields
  final _loggingService = getIt.get<LoggingService>();
  final _apiService = getIt.get<ApiService>();

  static List<FavouritesList> _favourites = [];

  late Logger _logger;
  //#endregion Backing Fields

  FavouritesService() {
    _logger = _loggingService.getLogger(this);
  }

  Future<List<FavouritesList>> getMyFavourites() async {

    var deviceId = "2a1cd97945f7cc66";

    try {
      if (_favourites.isEmpty) {
        var favouritesResponse = await _apiService.fetchPostData("$API_FAVOURITES/$deviceId", favouritesListFromJson);
        
        if (favouritesResponse is Success) {
          _favourites = favouritesResponse.response as List<FavouritesList>;  
        }

        if (favouritesResponse is Failure) {
          throw(favouritesResponse.errorResponse);
        }

      }
      return _favourites;
    } 
    catch (ex, st) {
      _logger.e("Failed to get favourites data", ex, st);
      rethrow;
    }
    
  }

}