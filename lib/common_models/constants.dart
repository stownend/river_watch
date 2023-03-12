// ignore_for_file: constant_identifier_names

//#region APIs

import 'package:flutter/material.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');

const String API_BASE_PROD = "https://services.riverwatchapp.co.uk";
const String API_BASE_DEV = "http://localhost:55275";

const String API_BROWSE = "api/browse";
const String API_STATIONS_IN_RIVER = "api/browse/stationsinriver";
const String API_SEARCH_STATIONS = "api/browse/searchAll";
const String API_FAVOURITES = "api/user/myStations";
const String API_STATION = "api/station";
const String API_SAVE_THRESHOLDS = "api/user/saveThresholds";
const String API_DELETE_FAVOURITE = "api/user/StopMonitoring";

//#endregion APIs

//#region Errors
const ERR_INVALID_API_RESPONSE = 100;
const ERR_NO_INTERNET = 101;
const ERR_INVALID_FORMAT = 102;
const ERR_UNKNOWN_ERROR = 103;
const ERR_UNEXPECTED_ERROR = 104;
//#endregion Errors

enum FavouriteCategory {
  TooDeep,
  Ideal,
  TooShallow
}

// Used to show snackbar without context
final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();