import 'dart:convert';

class NavigationData {

  // Note: This reads data from Json that is an array at the outer level e.g. [{"name":"First"},{"name":"Second"},{"name":"Third"}]
  static List<RegionDto> getRegions(String payloadJson) {
    List<RegionDto> payloadList = List<RegionDto>.from(json.decode(payloadJson).map((x) => RegionDto.parseJson(x)));

    return payloadList;
  }

}

class RegionDto {
  final String name;
  final List<AreaDto> areas;
  
  const RegionDto({
    required this.name,
    required this.areas
  });

  factory RegionDto.parseJson(Map<String, dynamic> json) {
    return RegionDto(
      name: json['name'],
      areas: (json['areas'] as List).map((listJson) => AreaDto.parseJson(listJson)).toList(),
    );
  }

}

class AreaDto {
  final String name;
  // List<CatchmentDto> catchments;

  const AreaDto({
    required this.name
  });

  factory AreaDto.parseJson(dynamic json) {
    return AreaDto(
      name: json['name'],
      //areas: (jsonDecode(json)['data'] as List).map((nationJson) => AreaDto.parseJson(nationJson)).toList(),
    );
  }

}
