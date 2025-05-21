import 'package:flutter/material.dart';

@immutable
final class PositionedPoints {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const PositionedPoints({this.top, this.bottom, this.left, this.right});
}
