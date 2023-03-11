// ignore_for_file: non_constant_identifier_names

import 'package:river_watch/app/station/models/station.dart';


class ChartBounds
{
    late double _Max;
    double get Max => _Max;

    late double _Min;
    double get Min => _Min;

    late double _Span;
    double get Span => _Span;

    late double _OffsetY;
    double get OffsetY => _OffsetY;

    late double _ScaleX;
    double get ScaleX => _ScaleX;
    
    late double _ScaleY;
    double get ScaleY => _ScaleY;

    List<LatestReading> _readings = [];
    // final double _maxOnRecord = 0;
    double _typicalRangeLow = 0;
    double _typicalRangeHigh = 0;

    ChartBounds()
    {
        _Min = 0;
        _Max = 1;
        _Span = 1;
        _ScaleX = 1;
        _ScaleY = 1;
    }

    ChartBounds.fromConfig(List<LatestReading> readings, double maxOnRecord, double typicalRangeLow, double typicalRangeHigh, double chartWidth, double chartHeight, Thresholds? thresholds)
    {
        _readings = readings;
        // _maxOnRecord = maxOnRecord;
        _typicalRangeLow = typicalRangeLow;
        _typicalRangeHigh = typicalRangeHigh;

        var dataMin = _readings.reduce((r1, r2) => r1.value < r2.value ? r1 : r2).value;
        var dataMax = _readings.reduce((r1, r2) => r1.value > r2.value ? r1 : r2).value;

        double highRange;
        double lowRange;

        // Calculate bounds based on typical ranges
        highRange = dataMax > _typicalRangeHigh ? dataMax : _typicalRangeHigh;
        lowRange = dataMin < _typicalRangeLow ? dataMin : _typicalRangeLow;

        // Then adjust for thresholds if defined
        if (thresholds != null)
        {
            highRange = dataMax > thresholds.high ? dataMax : thresholds.high;
            lowRange = dataMin < thresholds.low ? dataMin : thresholds.low;
        }

        //Max = ((float)Math.Ceiling(highRange * 2) / 2) * 1.1f; // To neareast half
        //Min = ((float)Math.Floor(lowRange * 2) / 2) * 0.9f; // To neareast half
        //Min = Min < 0 ? Min : 0;

        _Span = highRange - lowRange;

        _Max = highRange + (Span * 0.1); // 10% above
        _Min = lowRange - (Span * 0.1); // 10% below

        _Span = Max - Min;
        _OffsetY = 0 - Min;

        _ScaleX = chartWidth / (_readings.length - 1);
        _ScaleY = chartHeight / Span;
    }

}