// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

Station stationFromJson(String str) => Station.fromJson(json.decode(str));

String stationToJson(Station data) => json.encode(data.toJson());

class Station {
    Station({
        required this.label,
        required this.measureId,
        required this.latestReadings,
        required this.thresholds,
        required this.id,
        required this.name,
        required this.itemUrl,
        required this.rloIid,
        required this.regionName,
        required this.areaName,
        required this.catchmentName,
        required this.riverName,
        required this.dateOpened,
        required this.lat,
        required this.long,
        required this.maxDateTime,
        required this.maxValue,
        required this.minDateTime,
        required this.minValue,
        required this.typicalRangeHigh,
        required this.typicalRangeLow,
        required this.stationReference,
        required this.town,
    });

    String label;
    int measureId;
    List<LatestReading> latestReadings;
    Thresholds? thresholds;
    int id;
    String name;
    String itemUrl;
    String rloIid;
    String regionName;
    String areaName;
    String catchmentName;
    String riverName;
    DateTime dateOpened;
    double lat;
    double long;
    DateTime maxDateTime;
    double maxValue;
    DateTime minDateTime;
    double minValue;
    double typicalRangeHigh;
    double typicalRangeLow;
    String stationReference;
    String town;

    factory Station.fromJson(Map<String, dynamic> json) => Station(
        label: json["label"],
        measureId: json["measureId"],
        latestReadings: List<LatestReading>.from(json["latestReadings"].map((x) => LatestReading.fromJson(x))),
        thresholds: json["thresholds"] == null ? null : Thresholds.fromJson(json["thresholds"]),
        id: json["id"],
        name: json["name"],
        itemUrl: json["itemUrl"],
        rloIid: json["rloIid"],
        regionName: json["regionName"],
        areaName: json["areaName"],
        catchmentName: json["catchmentName"],
        riverName: json["riverName"],
        dateOpened: DateTime.parse(json["dateOpened"]),
        lat: json["lat"]?.toDouble(),
        long: json["long"]?.toDouble(),
        maxDateTime: DateTime.parse(json["maxDateTime"]),
        maxValue: json["maxValue"]?.toDouble(),
        minDateTime: DateTime.parse(json["minDateTime"]),
        minValue: json["minValue"]?.toDouble(),
        typicalRangeHigh: json["typicalRangeHigh"]?.toDouble(),
        typicalRangeLow: json["typicalRangeLow"]?.toDouble(),
        stationReference: json["stationReference"],
        town: json["town"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "measureId": measureId,
        "latestReadings": List<dynamic>.from(latestReadings.map((x) => x.toJson())),
        "thresholds": thresholds!.toJson(),
        "id": id,
        "name": name,
        "itemUrl": itemUrl,
        "rloIid": rloIid,
        "regionName": regionName,
        "areaName": areaName,
        "catchmentName": catchmentName,
        "riverName": riverName,
        "dateOpened": dateOpened.toIso8601String(),
        "lat": lat,
        "long": long,
        "maxDateTime": maxDateTime.toIso8601String(),
        "maxValue": maxValue,
        "minDateTime": minDateTime.toIso8601String(),
        "minValue": minValue,
        "typicalRangeHigh": typicalRangeHigh,
        "typicalRangeLow": typicalRangeLow,
        "stationReference": stationReference,
        "town": town,
    };
}

class LatestReading {
    LatestReading({
        required this.id,
        required this.dateTime,
        required this.value,
    });

    int id;
    DateTime dateTime;
    double value;

    factory LatestReading.fromJson(Map<String, dynamic> json) => LatestReading(
        id: json["id"],
        dateTime: DateTime.parse(json["dateTime"]),
        value: json["value"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "dateTime": dateTime.toIso8601String(),
        "value": value,
    };
}

class Thresholds {
    Thresholds({
        required this.id,
        required this.stationId,
        required this.deviceId,
        required this.installId,
        required this.os,
        required this.low,
        required this.high,
        required this.notify,
        required this.lastNotified,
    });

    int id;
    int stationId;
    String deviceId;
    String installId;
    String os;
    double low;
    double high;
    bool notify;
    DateTime lastNotified;

    factory Thresholds.fromJson(Map<String, dynamic> json) => Thresholds(
        id: json["id"],
        stationId: json["stationId"],
        deviceId: json["deviceId"],
        installId: json["installId"],
        os: json["os"],
        low: json["low"]?.toDouble(),
        high: json["high"]?.toDouble(),
        notify: json["notify"],
        lastNotified: DateTime.parse(json["lastNotified"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "stationId": stationId,
        "deviceId": deviceId,
        "installId": installId,
        "os": os,
        "low": low,
        "high": high,
        "notify": notify,
        "lastNotified": lastNotified.toIso8601String(),
    };
}
