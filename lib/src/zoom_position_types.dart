import 'package:flutter_magnifier/src/enum/magnifier_position_enum.dart';

/// Base class for all zoom position types
abstract class ZoomPosition {
  const ZoomPosition();
}

/// Custom zoom position with fixed coordinates
class CustomZoomPosition extends ZoomPosition {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const CustomZoomPosition({this.top, this.bottom, this.left, this.right});
}

/// Bouncing zoom position that follows touch with predefined behavior
class BouncingZoomPosition extends ZoomPosition {
  final MagnifierPosition position;

  const BouncingZoomPosition(this.position);
}

/// Custom function zoom position that uses a callback for position calculation
class CustomFunctionZoomPosition extends ZoomPosition {
  final PositionedPoints Function({required double top, required double bottom, required double left, required double right}) setPositionFunction;

  const CustomFunctionZoomPosition(this.setPositionFunction);
}

/// Class to hold position points
class PositionedPoints {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const PositionedPoints({this.top, this.bottom, this.left, this.right});
}
