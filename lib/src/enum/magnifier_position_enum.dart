/// Enum defining different magnifier position behaviors
enum MagnifierPositionEnum {
  /// Magnifier bounces between all four corners based on touch position
  bouncing,

  /// Magnifier bounces between top-right and top-left corners
  bouncingTopRightTopLeft,

  /// Magnifier bounces between bottom-right and bottom-left corners
  bouncingBottomRightBottomLeft,

  /// Magnifier bounces between top-left and bottom-left corners
  bouncingTopLeftBottomLeft,

  /// Magnifier bounces between top-right and bottom-right corners
  bouncingTopRightBottomRight,

  /// Magnifier follows the touch point with an offset
  fingertips,
}
