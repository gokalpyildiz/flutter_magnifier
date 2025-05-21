import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_magnifier/flutter_magnifier.dart';

mixin MagnifierToolMixin on State<MagnifierTool> {
  ui.Image? screenImage;
  Offset? touchPosition;
  final GlobalKey boundaryKey = GlobalKey();
  Size? screenSize;
  bool isShownMagnificier = false;
  double? positionedLeft;
  double? positionedTop;
  double? positionedRight;
  double? positionedBottom;

  PositionedPoints getPosition(double top, double bottom, double left, double right) {
    return PositionedPoints(top: top, bottom: bottom, left: left, right: right);
  }

  Future<void> captureScreen() async {
    try {
      RenderRepaintBoundary? boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        ui.Image image = await boundary.toImage(pixelRatio: 1.0);
        screenSize = Size(image.width.toDouble(), image.height.toDouble());

        // Eski görüntüyü temizle
        screenImage?.dispose();

        setState(() {
          screenImage = image;
        });
      }
    } catch (e) {
      debugPrint('Error capturing screen: $e');
    }
  }

  void onPanDown(Offset position) async {
    await captureScreen();
    setZoomPosition();
    isShownMagnificier = true;
    setState(() {
      touchPosition = position;
    });
  }

  void onPanUpdate(Offset position) async {
    if (isShownMagnificier) {
      await captureScreen();
      setZoomPosition();
    }
    setState(() {
      touchPosition = position;
    });
  }

  void setZoomPosition() {
    if (touchPosition == null) return;
    if (widget.zoomPosition is CustomZoomPosition) {
      final zoomPosition = widget.zoomPosition as CustomZoomPosition;
      positionedTop = zoomPosition.top;
      positionedBottom = zoomPosition.bottom;
      positionedLeft = zoomPosition.left;
      positionedRight = zoomPosition.right;
    } else if (widget.zoomPosition is BouncingZoomPosition) {
      final zoomPosition = widget.zoomPosition as BouncingZoomPosition;
      switch (zoomPosition.position) {
        case MagnifierPosition.bouncing:
          if (touchPosition!.dx < screenSize!.width / 2 && touchPosition!.dy < screenSize!.height / 2) {
            positionedTop = 0;
            positionedBottom = null;
            positionedLeft = 0;
            positionedRight = null;
          } else if (touchPosition!.dx < screenSize!.width / 2 && touchPosition!.dy >= screenSize!.height / 2) {
            positionedTop = null;
            positionedBottom = 0;
            positionedLeft = 0;
            positionedRight = null;
          } else if (touchPosition!.dx >= screenSize!.width / 2 && touchPosition!.dy < screenSize!.height / 2) {
            positionedTop = 0;
            positionedBottom = null;
            positionedLeft = null;
            positionedRight = 0;
          } else {
            positionedTop = null;
            positionedBottom = 0;
            positionedLeft = null;
            positionedRight = 0;
          }
        case MagnifierPosition.bouncingTopRightTopLeft:
          {
            if (touchPosition!.dx < screenSize!.width / 2) {
              positionedTop = 0;
              positionedBottom = null;
              positionedLeft = 0;
              positionedRight = null;
            } else {
              positionedTop = null;
              positionedBottom = 0;
              positionedLeft = null;
              positionedRight = 0;
            }
          }
        case MagnifierPosition.bouncingBottomRightBottomLeft:
          {
            if (touchPosition!.dx < screenSize!.width / 2) {
              positionedTop = null;
              positionedBottom = 0;
              positionedLeft = null;
              positionedRight = 0;
            } else {
              positionedTop = null;
              positionedBottom = 0;
              positionedLeft = 0;
              positionedRight = null;
            }
          }
        case MagnifierPosition.bouncingTopLeftBottomLeft:
          if (touchPosition!.dy < screenSize!.height / 2) {
            positionedTop = null;
            positionedBottom = 0;
            positionedLeft = 0;
            positionedRight = null;
          } else {
            positionedTop = 0;
            positionedBottom = null;
            positionedLeft = 0;
            positionedRight = null;
          }
        case MagnifierPosition.bouncingTopRightBottomRight:
          if (touchPosition!.dx < screenSize!.width / 2) {
            positionedTop = 0;
            positionedBottom = null;
            positionedLeft = 0;
            positionedRight = null;
          } else {
            positionedTop = null;
            positionedBottom = 0;
            positionedLeft = null;
            positionedRight = 0;
          }
        case MagnifierPosition.fingertips:
          positionedTop = touchPosition!.dy - (widget.magnifierSize.height + 20);
          positionedLeft = touchPosition!.dx - widget.magnifierSize.width / 2;
          if (positionedTop! < -30) positionedTop = widget.magnifierSize.height;
      }
    } else if (widget.zoomPosition is CustomFunctionZoomPosition) {
      var zoomPosition = widget.zoomPosition as CustomFunctionZoomPosition;
      final positionedPoints = zoomPosition.setPositionFunction(
        top: touchPosition!.dy,
        bottom: touchPosition!.dy,
        left: touchPosition!.dx,
        right: touchPosition!.dx,
      );
      positionedTop = positionedPoints.top;
      positionedBottom = positionedPoints.bottom;
      positionedLeft = positionedPoints.left;
      positionedRight = positionedPoints.right;
    } else if (widget.zoomPosition is CustomFunctionZoomPosition) {
      var zoomPosition = widget.zoomPosition as CustomFunctionZoomPosition;
      final positionedPoints = zoomPosition.setPositionFunction(
        top: touchPosition?.dy ?? 0,
        bottom: touchPosition?.dy ?? 0,
        left: touchPosition?.dx ?? 0,
        right: touchPosition?.dx ?? 0,
      );
      positionedTop = positionedPoints.top;
      positionedBottom = positionedPoints.bottom;
      positionedLeft = positionedPoints.left;
      positionedRight = positionedPoints.right;
    }
  }

  Future<void> clearCaptureScreen() async {
    isShownMagnificier = false;
    screenImage?.dispose();
    screenImage = null;
    touchPosition = null;
    setState(() {});
  }
}
