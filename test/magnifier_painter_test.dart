import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_magnifier/src/painter/magnifier_painter.dart';
import 'dart:ui' as ui;

void main() {
  group('MagnifierPainter Tests', () {
    late ui.Image testImage;
    late Size testSize;

    setUpAll(() async {
      // Create a test image
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint()..color = Colors.blue;
      canvas.drawRect(const Rect.fromLTWH(0, 0, 100, 100), paint);
      final picture = recorder.endRecording();
      testImage = await picture.toImage(100, 100);
      testSize = const Size(100, 100);
    });

    test('creates painter with default values', () {
      final painter = MagnifierPainter(position: const Offset(50, 50), image: testImage, imageSize: testSize);

      expect(painter.scale, 2.0);
      expect(painter.borderColor, Colors.black);
      expect(painter.shorBorder, true);
    });

    test('creates painter with custom values', () {
      final painter = MagnifierPainter(
        position: const Offset(50, 50),
        image: testImage,
        imageSize: testSize,
        scale: 3.0,
        borderColor: Colors.red,
        shorBorder: false,
      );

      expect(painter.scale, 3.0);
      expect(painter.borderColor, Colors.red);
      expect(painter.shorBorder, false);
    });

    test('shouldRepaint returns true when values change', () {
      final painter1 = MagnifierPainter(position: const Offset(50, 50), image: testImage, imageSize: testSize);

      final painter2 = MagnifierPainter(position: const Offset(60, 60), image: testImage, imageSize: testSize);

      final painter3 = MagnifierPainter(position: const Offset(50, 50), image: testImage, imageSize: testSize, scale: 3.0);

      expect(painter1.shouldRepaint(painter2), true);
      expect(painter1.shouldRepaint(painter3), true);
    });

    test('shouldRepaint returns false when values are the same', () {
      final painter1 = MagnifierPainter(position: const Offset(50, 50), image: testImage, imageSize: testSize);

      final painter2 = MagnifierPainter(position: const Offset(50, 50), image: testImage, imageSize: testSize);

      expect(painter1.shouldRepaint(painter2), false);
    });
  });
}
