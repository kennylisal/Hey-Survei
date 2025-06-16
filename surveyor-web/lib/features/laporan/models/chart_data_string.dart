import 'package:flutter/material.dart';

class ChartData {
  ChartData(
    this.x,
    this.y,
    // this.color,
  );
  String x;
  double y;
  Color color = Colors.black;

  @override
  String toString() => 'ChartData(x: $x, y: $y)';
}
