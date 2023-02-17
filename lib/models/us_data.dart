import 'dart:convert';

class USData {
  final List<Nation> data;
  
  const USData({
    required this.data
  });

  factory USData.parseJson(String json) {
    return USData(
      data: (jsonDecode(json)['data'] as List).map((nationJson) => Nation.parseJson(nationJson)).toList(),
    );
  }
}

class Nation {
  final String idNation;
  final String nation;
  final int idYear;

  const Nation({
    required this.idNation,
    required this.nation,
    required this.idYear,
  });

  factory Nation.parseJson(dynamic json) {
    return Nation(
      idNation: json['ID Nation'],
      nation: json['Nation'],
      idYear: json['ID Year']
    );
  }

    @override
    String toString() {
      return '{ $idNation, $nation, $idYear }';
    }
}
