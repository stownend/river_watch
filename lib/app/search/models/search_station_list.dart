// To parse this JSON data, do
//
//     final searchStationList = searchStationListFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

List<SearchStationList> searchStationListFromJson(String str) => List<SearchStationList>.from(json.decode(str).map((x) => SearchStationList.fromJson(x)));

String searchStationListToJson(List<SearchStationList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchStationList {
    SearchStationList({
        required this.id,
        required this.name,
        required this.town,
        required this.riverName,
        required this.regionName,
        required this.areaName,
        required this.catchmentName,
        required this.label,
        required this.subLabel,
        required this.level,
        required this.direction,
        required this.isFalling,
        required this.isRising,
        required this.isIdeal,
    });

    int id;
    String name;
    String town;
    String riverName;
    RegionName regionName;
    String areaName;
    String catchmentName;
    String label;
    String subLabel;
    int level;
    int direction;
    bool isFalling;
    bool isRising;
    bool isIdeal;

    factory SearchStationList.fromJson(Map<String, dynamic> json) => SearchStationList(
        id: json["id"],
        name: json["name"],
        town: json["town"],
        riverName: json["riverName"],
        regionName: regionNameValues.map[json["regionName"]]!,
        areaName: json["areaName"],
        catchmentName: json["catchmentName"],
        label: json["label"],
        subLabel: json["subLabel"],
        level: json["level"],
        direction: json["direction"],
        isFalling: json["isFalling"],
        isRising: json["isRising"],
        isIdeal: json["isIdeal"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "town": town,
        "riverName": riverName,
        "regionName": regionNameValues.reverse[regionName],
        "areaName": areaName,
        "catchmentName": catchmentName,
        "label": label,
        "subLabel": subLabel,
        "level": level,
        "direction": direction,
        "isFalling": isFalling,
        "isRising": isRising,
        "isIdeal": isIdeal,
    };
}

enum RegionName { THAMES, NORTH_EAST, ANGLIAN, SOUTHERN, SOUTH_WEST, NORTH_WEST, MIDLANDS, MIDLAND }

final regionNameValues = EnumValues({
    "Anglian": RegionName.ANGLIAN,
    "Midland": RegionName.MIDLAND,
    "Midlands": RegionName.MIDLANDS,
    "North East": RegionName.NORTH_EAST,
    "North West": RegionName.NORTH_WEST,
    "Southern": RegionName.SOUTHERN,
    "South West": RegionName.SOUTH_WEST,
    "Thames": RegionName.THAMES
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
