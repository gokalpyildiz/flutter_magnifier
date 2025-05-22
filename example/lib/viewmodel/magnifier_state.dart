import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_magnifier/flutter_magnifier.dart';

class MagnifierState {
  final File? image;
  final ZoomPosition currentPosition;
  final String currentPositionValue;
  final double zoomScale;
  final bool showBorder;
  final Color borderColor;
  final Size magnifierSize;

  const MagnifierState({
    this.image,
    this.currentPosition = const BouncingZoomPosition(MagnifierPositionEnum.bouncingTopLeftBottomLeft),
    this.currentPositionValue = 'Bouncing',
    this.zoomScale = 2.0,
    this.showBorder = true,
    this.borderColor = Colors.black,
    this.magnifierSize = const Size(150, 150),
  });

  MagnifierState copyWith({
    File? image,
    ZoomPosition? currentPosition,
    String? currentPositionValue,
    double? zoomScale,
    bool? showBorder,
    Color? borderColor,
    Size? magnifierSize,
  }) {
    return MagnifierState(
      image: image ?? this.image,
      currentPosition: currentPosition ?? this.currentPosition,
      currentPositionValue: currentPositionValue ?? this.currentPositionValue,
      zoomScale: zoomScale ?? this.zoomScale,
      showBorder: showBorder ?? this.showBorder,
      borderColor: borderColor ?? this.borderColor,
      magnifierSize: magnifierSize ?? this.magnifierSize,
    );
  }
}
