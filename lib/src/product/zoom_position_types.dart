import 'package:flutter/material.dart';
import 'package:flutter_magnifier/src/enum/magnifier_position_enum.dart';
import 'package:flutter_magnifier/src/models/position_points.dart';

abstract class ZoomPosition {
  const ZoomPosition();
  factory ZoomPosition.custom({double? top, double? bottom, double? left, double? right}) = CustomZoomPosition;
  factory ZoomPosition.bouncing(MagnifierPosition position, {EdgeInsets? padding}) = BouncingZoomPosition;
  factory ZoomPosition.customFunction({
    required PositionedPoints Function({required double top, required double bottom, required double left, required double right})
    setPositionFunction,
  }) = CustomFunctionZoomPosition;
}

class CustomZoomPosition extends ZoomPosition {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const CustomZoomPosition({this.top, this.bottom, this.left, this.right});
}

class CustomFunctionZoomPosition extends ZoomPosition {
  final PositionedPoints Function({required double top, required double bottom, required double left, required double right}) setPositionFunction;

  const CustomFunctionZoomPosition({required this.setPositionFunction});
}

class BouncingZoomPosition extends ZoomPosition {
  final MagnifierPosition position;
  final EdgeInsets? padding;
  const BouncingZoomPosition(this.position, {this.padding = const EdgeInsets.all(8)});
}
