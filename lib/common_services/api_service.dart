// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../common_models/api_status.dart';
import '../common_models/constants.dart';
import '../ioc.dart';
import 'logging_service.dart';

class ApiService {
  
  final _loggingService = getIt.get<LoggingService>();

  String _api_base = "";

  ApiService() {
    if (isProduction) {
      _api_base = API_BASE_PROD;
    } else {
      _api_base = API_BASE_DEV;
    }
  }

  Future<Object> fetchData(String url, Function(String) parser) async {
      //throw Exception('Failed to load data from: $url');
    var _logger = _loggingService.getLogger(this);

    //await Future.delayed(const Duration(seconds: 15));

    try {
      final response = await http.get(Uri.parse("$_api_base/$url"));

      if (response.statusCode == 200) {
        return Success(response: parser(response.body));
      } else {
        _logger.e("Error calling $url - status: ${response.statusCode}");
        return Failure(code: ERR_INVALID_API_RESPONSE, errorResponse: "Invalid response");
      }
    } on HttpException {
      return Failure(code: ERR_NO_INTERNET, errorResponse: "No Internet");
    } on SocketException {
      return Failure(code: ERR_NO_INTERNET, errorResponse: "No internet");
    } on http.ClientException {
      return Failure(code: ERR_NO_INTERNET, errorResponse: "No internet");
    } on FormatException {
      return Failure(code: ERR_INVALID_FORMAT, errorResponse: "Invalid format");
    } catch (ex, st) {
      _logger.e("Unknown error calling $url", ex, st);
      return Failure(code: ERR_UNKNOWN_ERROR, errorResponse: "Unknown error getting data");
    }
  }

  Future<Object> fetchPostData(String url, dynamic body, Function(String) parser) async {
      //throw Exception('Failed to load data from: $url');
    var _logger = _loggingService.getLogger(this);

    //await Future.delayed(const Duration(seconds: 15));

    try {
      final response = await http.post(
        Uri.parse("$_api_base/$url"), 
        headers: {"Content-Type": "application/json"},
        body: json.encode(body)
      );

      if (response.statusCode == 200) {
        return Success(response: parser(response.body));
      } else {
        _logger.e("Error calling $url - status: ${response.statusCode}");
        return Failure(code: ERR_INVALID_API_RESPONSE, errorResponse: "Invalid response");
      }
    } on HttpException {
      return Failure(code: ERR_NO_INTERNET, errorResponse: "No Internet");
    } on SocketException {
      return Failure(code: ERR_NO_INTERNET, errorResponse: "No internet");
    } on http.ClientException {
      return Failure(code: ERR_NO_INTERNET, errorResponse: "No internet");
    } on FormatException {
      return Failure(code: ERR_INVALID_FORMAT, errorResponse: "Invalid format");
    } catch (ex, st) {
      _logger.e("Unknown error calling $url", ex, st);
      return Failure(code: ERR_UNKNOWN_ERROR, errorResponse: "Unknown error getting data");
    }
  }
}