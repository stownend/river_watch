// ignore_for_file: library_private_types_in_public_api, constant_identifier_names, non_constant_identifier_names

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../models/chart_bounds.dart';
import '../models/station.dart';

const double LEFT_MARGIN = 70;
const double RIGHT_MARGIN = 10;
const double TOP_MARGIN = 10;
const double BOTTOM_MARGIN = 50;

const double TICK_LENGTH = 10;

const int DAYS_HISTORY = 14;

class LevelsChart extends StatefulWidget {
  const LevelsChart({super.key, required this.readings, required this.maxOnRecord, required this.typicalRangeLow, required this.typicalRangeHigh, required this.thresholds});

  final List<LatestReading> readings;
  final double maxOnRecord;
  final double typicalRangeLow;
  final double typicalRangeHigh;
  final Thresholds? thresholds;

  @override
  _LevelsChartState createState() => _LevelsChartState();

}

class _LevelsChartState extends State<LevelsChart> {

  //#region Backing Fields

  late List<LatestReading> _readings;
  late double _maxOnRecord;
  late double _typicalRangeLow;
  late double _typicalRangeHigh;
  late Thresholds? _thresholds;

  //#endregion Backing Fields

  @override
  Widget build(BuildContext context) {

    _readings = widget.readings;
    _maxOnRecord = widget.maxOnRecord;
    _typicalRangeLow = widget.typicalRangeLow;
    _typicalRangeHigh = widget.typicalRangeHigh;
    _thresholds = widget.thresholds;

    return CustomPaint(
        painter: ChartPainter(_readings, _maxOnRecord, _typicalRangeLow, _typicalRangeHigh, _thresholds),
        child: Container(),
      );
  }
}

class ChartPainter extends CustomPainter{

  ChartPainter(this._readings_orig, this._maxOnRecord, this._typicalRangeLow, this._typicalRangeHigh, this._thresholds);

  final List<LatestReading> _readings_orig;
  final double _maxOnRecord;
  final double _typicalRangeLow;
  final double _typicalRangeHigh;
  final Thresholds? _thresholds;

  late double _chartWidth;
  late double _chartHeight;
  late ChartBounds _bounds;

  late List<LatestReading> _readings;

  @override
  void paint(Canvas canvas, Size size) {
    // final c = Offset(size.width / 2.0, size.height / 2.0);
    // final r = 50.0;
    // final paint = Paint()..color = Colors.black;

    // canvas.drawCircle(c, r, paint);

    var width = size.width;
    var height = size.height;

    _chartHeight = height - (BOTTOM_MARGIN + TOP_MARGIN);
    _chartWidth = width - (LEFT_MARGIN + RIGHT_MARGIN);

    _readings_orig.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    _readings = _readings_orig.where((element) => element.dateTime.compareTo(DateTime.now().add(const Duration(days: -DAYS_HISTORY)))>= 0).toList();

    _bounds = ChartBounds.fromConfig(_readings, _maxOnRecord, _typicalRangeLow, _typicalRangeHigh, _chartWidth, _chartHeight, _thresholds);

    canvas.translate(0, height);

    // Thresholds - before readings so that they are on top of thresholds
    if (_thresholds != null)
    {
        var thresholdsPath = Path();
        thresholdsPath.MoveToPoint(_point(0, _thresholds!.low));
        thresholdsPath.LineToPoint(_point(_readings.length - 1, _thresholds!.low));
        thresholdsPath.LineToPoint(_point(_readings.length - 1, _thresholds!.high));
        thresholdsPath.LineToPoint(_point(0, _thresholds!.high));
        canvas.drawPath(thresholdsPath, PaintBrushes.thresholdPaint);
    }

    // Readings
    {
      var chartPath = Path();
      var startPoint = _point(0, _bounds.Min);
      chartPath.MoveToPoint(startPoint);
      int p;
      for (p = 0; p < _readings.length; p++)
      {
          chartPath.LineToPoint(_point(p as double, _readings[p].value));
      }
      chartPath.LineToPoint(_point((p -1) as double, _bounds.Min));
      chartPath.LineToPoint(startPoint);

      canvas.drawPath(chartPath, PaintBrushes.chartFillPaint);
    }

    {
      var chartPath = Path();
      var startPoint = _point(0, _bounds.Min);
      chartPath.MoveToPoint(startPoint);
      int p;
      for (p = 0; p < _readings.length; p++)
      {
          chartPath.LineToPoint(_point(p as double, _readings[p].value));
      }
      chartPath.LineToPoint(_point((p - 1)as double, _bounds.Min));
      chartPath.LineToPoint(startPoint);

      canvas.drawPath(chartPath, PaintBrushes.chartEdgePaint);

    }

    // Y axis

    // Label is centred on a pat that stretches the full length of the Y-Axis
    var labelPathStart = _point(0, _bounds.Min);
    var labelPathEnd = _point(0, _bounds.Max);

    var tPath = Path();
    double legendX = labelPathStart.X + 10 + PaintBrushes.xAxisLegendPaintStyle.fontSize! - LEFT_MARGIN;
    tPath.moveTo(legendX, labelPathStart.Y);
    tPath.lineTo(legendX, labelPathEnd.Y);
    //canvas.DrawTextOnPath("Metres", tPath, 0, 0, xAxisLegendPaint);
    //canvas.DrawPath(tPath, chartEdgePaint); // Useful for debugging tet in the wrong place

    // Value at each metre
    for (double xTick = _bounds.Min; xTick <= _bounds.Max; xTick+=0.5)
    {
        var xStart = _point(0, xTick).X;
        var xEnd = _point(_readings.length - 1, xTick).X;

        var y = _point(0, xTick).Y;

        // Grid
        canvas.drawLine(Offset(xStart, y), Offset(xEnd, y), PaintBrushes.gridPaint);

        // Tick
        canvas.drawLine(Offset(xStart - TICK_LENGTH, y), Offset(xStart, y), PaintBrushes.chartBorderPaint);

        // Label
        canvas.DrawTextRightAligned("${xTick.toStringAsFixed(2)}m", xStart - (TICK_LENGTH * 2), y - (PaintBrushes.xAxisLegendPaintStyle.fontSize! / 2), PaintBrushes.xAxisLegendPaintStyle);

    }

    // X Axis

    // Value at each day
    for (int yTick = 0; yTick < _readings.length; yTick += (_readings.length / DAYS_HISTORY).round())
    {
        var yStart = _point(yTick as double, _bounds.Min).Y;
        var yEnd = _point(yTick as double, _bounds.Max).Y;

        var x = _point(yTick as double, _bounds.Min).X;

        // Grid
        canvas.drawLine(Offset(x, yStart), Offset(x, yEnd), PaintBrushes.gridPaint);

        // Tick
        canvas.drawLine(Offset(x, yStart + TICK_LENGTH), Offset(x, yStart), PaintBrushes.chartBorderPaint);

    }

    for (int dateIndex = (_readings.length / 28).round(); dateIndex < _readings.length; dateIndex += (_readings.length / DAYS_HISTORY).round())
    {
        // Label
        var dateLabel = intl.DateFormat("E").format(_readings[dateIndex].dateTime);
        var x = _point(dateIndex as double, _bounds.Min).X;
//        canvas.DrawText(dateLabel, x, _bounds.Min - (TICK_LENGTH * 4), PaintBrushes.xAxisLegendPaintStyle);
        canvas.DrawTextCentered(dateLabel, x, _bounds.Min - BOTTOM_MARGIN + 6, PaintBrushes.xAxisLegendPaintStyle);
    }

    // Threshold labels - so that they are on top of readings
    if (_thresholds != null)
    {
        canvas.DrawText("High Water Threshold", _point(0, 0).X + 25, _point(0, _thresholds!.high).Y, PaintBrushes.thresholdTextStyle);
        canvas.DrawText("Low Water Threshold", _point(0, 0).X + 25, _point(0, _thresholds!.low).Y, PaintBrushes.thresholdTextStyle);
    }

    // Chart Border
    var borderPath = Path();
    borderPath.MoveToPoint(_point(0, _bounds.Min));
    borderPath.LineToPoint(_point(0, _bounds.Max));
    borderPath.lineTo(_point(_readings.length - 1, _bounds.Max).X - 1, _point(_readings.length - 1, _bounds.Max).Y);
    borderPath.lineTo(_point(_readings.length - 1, _bounds.Min).X - 1, _point(_readings.length - 1, _bounds.Min).Y);
    borderPath.LineToPoint(_point(0, _bounds.Min));

    canvas.drawPath(borderPath, PaintBrushes.chartBorderPaint);

    //canvas.drawLine(const Offset(0,0), const Offset(1910,-585), PaintBrushes.chartBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Point _point(double x, double y) {
    return Point(LEFT_MARGIN + (x * _bounds.ScaleX), (BOTTOM_MARGIN + ((y + _bounds.OffsetY) * _bounds.ScaleY)) * -1);
  }
  
}

class PaintBrushes {
  static Paint chartBorderPaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  static Paint chartFillPaint = Paint()
    ..color = const Color(0x77acd1e7)
    ..style = PaintingStyle.fill;

  static Paint chartEdgePaint = Paint()
//    ..color = const Color(0xffacd1e7)
    ..color = Colors.blue
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  static Paint gridPaint = Paint()
    ..color = const Color(0x55cccccc)
    ..strokeWidth = 1;

  static Paint thresholdPaint = Paint()
    ..color = const Color(0x4490EE90);

  static const TextStyle thresholdTextStyle = TextStyle(
    fontSize: 10,
    color: Colors.black,
  );

  static const TextStyle xAxisLegendPaintStyle = TextStyle(
    fontSize: 8,
    color: Colors.black,
  );

}

class Point {

  Point(this.X, this.Y);

  final double X;
  final double Y;
}

extension PathExtensions on Path {
  MoveToPoint(Point point) {
    moveTo(point.X, point.Y);
  }
  
  LineToPoint(Point point) {
    lineTo(point.X, point.Y);
  }

}

extension CanvasExtensions on Canvas {
  DrawText(String text, double x, double y, TextStyle style) {
    var drawer = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    drawer.layout(
      minWidth: 0,
      //maxWidth: size.width
    );
    drawer.paint(this, Offset(x, y));
  }

  DrawTextRightAligned(String text, double x, double y, TextStyle style) {
    var drawer = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    drawer.layout(
      minWidth: 0,
      //maxWidth: size.width
    );
    drawer.paint(this, Offset(x - drawer.width, y));
  }

  DrawTextCentered(String text, double x, double y, TextStyle style) {
    var drawer = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    drawer.layout(
      minWidth: 0,
      //maxWidth: size.width
    );
    drawer.paint(this, Offset(x - drawer.width / 2, y));
  }


}