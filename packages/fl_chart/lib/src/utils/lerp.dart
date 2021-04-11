import 'dart:ui';

import '../../fl_chart.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

List<T> _lerpList<T>(List<T> a, List<T> b, double t,
    {@required T Function(T, T, double) lerp}) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return lerp(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return lerp(i >= a.length ? b[i] : a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [Color] list based on [t] value, check [Tween.lerp].
List<Color> lerpColorList(List<Color> a, List<Color> b, double t) =>
    _lerpList(a, b, t, lerp: Color.lerp);

/// Lerps [double] list based on [t] value, check [Tween.lerp].
List<double> lerpDoubleList(List<double> a, List<double> b, double t) =>
    _lerpList(a, b, t, lerp: lerpDouble);

/// Lerps [int] list based on [t] value, check [Tween.lerp].
List<int> lerpIntList(List<int> a, List<int> b, double t) =>
    _lerpList(a, b, t, lerp: lerpInt);

/// Lerps [int] list based on [t] value, check [Tween.lerp].
int lerpInt(int a, int b, double t) {
  return (a + (b - a) * t).round();
}

/// Lerps [FlSpot] list based on [t] value, check [Tween.lerp].
List<FlSpot> lerpFlSpotList(List<FlSpot> a, List<FlSpot> b, double t) =>
    _lerpList(a, b, t, lerp: FlSpot.lerp);

/// Lerps [HorizontalRangeAnnotation] list based on [t] value, check [Tween.lerp].
List<HorizontalRangeAnnotation> lerpHorizontalRangeAnnotationList(
        List<HorizontalRangeAnnotation> a,
        List<HorizontalRangeAnnotation> b,
        double t) =>
    _lerpList(a, b, t, lerp: HorizontalRangeAnnotation.lerp);

/// Lerps [VerticalRangeAnnotation] list based on [t] value, check [Tween.lerp].
List<VerticalRangeAnnotation> lerpVerticalRangeAnnotationList(
        List<VerticalRangeAnnotation> a,
        List<VerticalRangeAnnotation> b,
        double t) =>
    _lerpList(a, b, t, lerp: VerticalRangeAnnotation.lerp);

/// Lerps [BarChartGroupData] list based on [t] value, check [Tween.lerp].
List<BarChartGroupData> lerpBarChartGroupDataList(
        List<BarChartGroupData> a, List<BarChartGroupData> b, double t) =>
    _lerpList(a, b, t, lerp: BarChartGroupData.lerp);

/// Lerps [BarChartRodData] list based on [t] value, check [Tween.lerp].
List<BarChartRodData> lerpBarChartRodDataList(
        List<BarChartRodData> a, List<BarChartRodData> b, double t) =>
    _lerpList(a, b, t, lerp: BarChartRodData.lerp);

/// Lerps [BarChartRodStackItem] list based on [t] value, check [Tween.lerp].
List<BarChartRodStackItem> lerpBarChartRodStackList(
        List<BarChartRodStackItem> a, List<BarChartRodStackItem> b, double t) =>
    _lerpList(a, b, t, lerp: BarChartRodStackItem.lerp);
