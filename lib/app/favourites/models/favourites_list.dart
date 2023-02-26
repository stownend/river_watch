// To parse this JSON data, do
//
//     final favouritesList = favouritesListFromJson(jsonString);

import 'dart:convert';

List<FavouritesList> favouritesListFromJson(String str) => List<FavouritesList>.from(json.decode(str).map((x) => FavouritesList.fromJson(x)));

String favouritesListToJson(List<FavouritesList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FavouritesList {
    FavouritesList({
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
    String regionName;
    String areaName;
    String catchmentName;
    String label;
    String subLabel;
    int level;
    int direction;
    bool isFalling;
    bool isRising;
    bool isIdeal;

    factory FavouritesList.fromJson(Map<String, dynamic> json) => FavouritesList(
        id: json["id"],
        name: json["name"],
        town: json["town"],
        riverName: json["riverName"],
        regionName: json["regionName"],
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
        "regionName": regionName,
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
