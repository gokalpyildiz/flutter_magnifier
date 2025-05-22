import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// A custom painter that draws a magnified portion of an image with a circular border.
@immutable
class MagnifierPainter extends CustomPainter {
  /// Creates a magnifier painter.
  ///
  /// The [position] parameter is the center point of the magnified area.
  /// The [image] parameter is the image to be magnified.
  /// The [scale] parameter determines the magnification level.
  /// The [imageSize] parameter is the size of the source image.
  /// The [borderColor] parameter sets the color of the magnifier border.
  /// The [shorBorder] parameter determines whether to show the border.
  const MagnifierPainter({
    required this.position,
    required this.image,
    this.scale = 2.0,
    required this.imageSize,
    this.borderColor = Colors.black,
    this.shorBorder = true,
    this.showInnerBorder = false,
  });

  /// The center point of the magnified area
  final Offset position;

  /// The image to be magnified
  final ui.Image image;

  /// The magnification scale factor
  final double scale;

  /// The size of the source image
  final Size imageSize;

  /// The color of the magnifier border
  final Color borderColor;

  /// Whether to show the magnifier border
  final bool shorBorder;

  final bool showInnerBorder;

  @override
  void paint(Canvas canvas, Size size) {
    final magnifierRadius = size.width / 2;
    final center = Offset(magnifierRadius, magnifierRadius);

    // Create and apply circular clip path
    _applyCircularClip(canvas, center, magnifierRadius);

    // Draw white background
    _drawBackground(canvas, center, magnifierRadius);

    // Draw magnified image
    _drawMagnifiedImage(canvas, size);

    // Draw border if enabled
    if (shorBorder) {
      _drawBorder(canvas, center, magnifierRadius);
    }
  }

  /// Applies a circular clip path to the canvas
  void _applyCircularClip(Canvas canvas, Offset center, double radius) {
    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.clipPath(clipPath);
  }

  /// Draws the white background circle
  void _drawBackground(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);
  }

  /// Draws the magnified portion of the image
  void _drawMagnifiedImage(Canvas canvas, Size size) {
    final sourceRect = Rect.fromCenter(
      center: position,
      width: size.width / scale,
      height: size.height / scale,
    );
    final destinationRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, sourceRect, destinationRect, Paint());
  }

  /// Draws the magnifier border
  void _drawBorder(Canvas canvas, Offset center, double radius) {
    // Draw outer border
    final outerBorderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, outerBorderPaint);

    // Draw inner border
    if (showInnerBorder) {
      final innerBorderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(center, radius - 2, innerBorderPaint);
    }
  }

  @override
  bool shouldRepaint(MagnifierPainter oldDelegate) {
    return position != oldDelegate.position ||
        image != oldDelegate.image ||
        scale != oldDelegate.scale;
  }
}
