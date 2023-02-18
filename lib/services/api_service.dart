import 'package:http/http.dart' as http;

import '../ioc.dart';
import 'app_settings_service.dart';

class ApiService {
  

  Future<T> fetchData<T>(String url, T Function(String) parser) async {
final appSettingsService = getIt.get<AppSettingsService>();
      //throw Exception('Failed to load data from: $url');

    final response = await http.get(Uri.parse("${appSettingsService.apiBase}$url"));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return parser(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data from: $url');
    }
  }
}