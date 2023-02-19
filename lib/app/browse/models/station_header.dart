// To parse this JSON data, do
//
//     final stationHeader = stationHeaderFromJson(jsonString);

import 'dart:convert';

List<StationHeader> stationHeaderFromJson(String str) => List<StationHeader>.from(json.decode(str).map((x) => StationHeader.fromJson(x)));

String stationHeaderToJson(List<StationHeader> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StationHeader {
    StationHeader({
        required this.id,
        required this.name,
        required this.town,
        required this.label,
    });

    int id;
    String name;
    String town;
    String label;

    factory StationHeader.fromJson(Map<String, dynamic> json) => StationHeader(
        id: json["id"],
        name: json["name"],
        town: json["town"],
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "town": town,
        "label": label,
    };
}
