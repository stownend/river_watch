import 'package:http/http.dart' as http;

class ApiService {

  Future<T> fetchData<T>(String url, T Function(String) parser) async {

      //throw Exception('Failed to load data from: $url');

    final response = await http.get(Uri.parse(url));

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