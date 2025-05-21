import 'dart:ui' as ui;
import 'package:flutter/material.dart';

@immutable
class MagnifierPainter extends CustomPainter {
  final Offset position;
  final ui.Image image;
  final double scale;
  final Size imageSize;
  final Color borderColor;
  final bool shorBorder;

  const MagnifierPainter({
    required this.position,
    required this.image,
    this.scale = 2.0,
    required this.imageSize,
    this.borderColor = Colors.black,
    this.shorBorder = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final magnifierRadius = size.width / 2;

    // Clip the canvas to a circle
    final clipPath = Path()..addOval(Rect.fromCircle(center: Offset(magnifierRadius, magnifierRadius), radius: magnifierRadius));
    canvas.clipPath(clipPath);

    // Calculate the source rectangle for the image
    final sourceRect = Rect.fromCenter(center: position, width: size.width / scale, height: size.height / scale);

    // Draw the magnified portion of the image
    final destinationRect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Add a white background
    canvas.drawCircle(Offset(magnifierRadius, magnifierRadius), magnifierRadius, Paint()..color = Colors.white);

    canvas.drawImageRect(image, sourceRect, destinationRect, Paint());

    // Draw border

    if (shorBorder) {
      final borderPaint =
          Paint()
            ..color = borderColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5;
      canvas.drawCircle(Offset(magnifierRadius, magnifierRadius), magnifierRadius, borderPaint);

      // Draw inner border
      final innerBorderPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5;

      canvas.drawCircle(Offset(magnifierRadius, magnifierRadius), magnifierRadius - 2, innerBorderPaint);
    }
  }

  @override
  bool shouldRepaint(MagnifierPainter oldDelegate) {
    return position != oldDelegate.position || image != oldDelegate.image || scale != oldDelegate.scale;
  }
}
