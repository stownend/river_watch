// To parse this JSON data, do
//
//     final hierarchy = hierarchyFromJson(jsonString);

import 'dart:convert';

List<Hierarchy> hierarchyFromJson(String str) => List<Hierarchy>.from(json.decode(str).map((x) => Hierarchy.fromJson(x)));

String hierarchyToJson(List<Hierarchy> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Hierarchy {
    Hierarchy({
        required this.name,
        required this.areas,
    });

    String name;
    List<Area> areas;

    factory Hierarchy.fromJson(Map<String, dynamic> json) => Hierarchy(
        name: json["name"],
        areas: List<Area>.from(json["areas"].map((x) => Area.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "areas": List<dynamic>.from(areas.map((x) => x.toJson())),
    };
}

class Area {
    Area({
        required this.name,
        required this.catchments,
    });

    String name;
    List<Catchment> catchments;

    factory Area.fromJson(Map<String, dynamic> json) => Area(
        name: json["name"],
        catchments: List<Catchment>.from(json["catchments"].map((x) => Catchment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "catchments": List<dynamic>.from(catchments.map((x) => x.toJson())),
    };
}

class Catchment {
    Catchment({
        required this.name,
        required this.rivers,
    });

    String name;
    List<River> rivers;

    factory Catchment.fromJson(Map<String, dynamic> json) => Catchment(
        name: json["name"],
        rivers: List<River>.from(json["rivers"].map((x) => River.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "rivers": List<dynamic>.from(rivers.map((x) => x.toJson())),
    };
}

class River {
    River({
        required this.id,
        required this.name,
    });

    int id;
    String name;

    factory River.fromJson(Map<String, dynamic> json) => River(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
