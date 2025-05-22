import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_magnifier/flutter_magnifier.dart';

/// Mixin that provides magnifier functionality to the MagnifierTool widget
mixin MagnifierToolMixin on State<MagnifierTool> {
  /// The captured screen image
  ui.Image? screenImage;

  /// The current touch position
  Offset? touchPosition;

  /// Key for the RepaintBoundary widget
  final GlobalKey boundaryKey = GlobalKey();

  /// Size of the captured screen
  Size? screenSize;

  /// Whether the magnifier is currently shown
  bool isShownMagnificier = false;

  /// Position values for the magnifier
  double? positionedLeft;
  double? positionedTop;
  double? positionedRight;
  double? positionedBottom;

  /// Last update timestamp for debouncing
  DateTime? _lastUpdate;

  /// Minimum time between updates (60 FPS)
  static const _updateInterval = Duration(milliseconds: 16);

  /// Creates a PositionedPoints object with the given coordinates
  PositionedPoints getPosition(double top, double bottom, double left, double right) {
    return PositionedPoints(top: top, bottom: bottom, left: left, right: right);
  }

  /// Captures the current screen content
  Future<void> captureScreen() async {
    try {
      final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        debugPrint('Warning: Could not find render boundary');
        return;
      }

      final image = await boundary.toImage(pixelRatio: 1.0);
      screenSize = Size(image.width.toDouble(), image.height.toDouble());

      screenImage?.dispose();
      setState(() {
        screenImage = image;
      });
    } catch (e, stackTrace) {
      debugPrint('Error capturing screen: $e\n$stackTrace');
    }
  }

  /// Handles pan down events
  void onPanDown(Offset position) async {
    await captureScreen();
    setZoomPosition();
    isShownMagnificier = true;
    setState(() {
      touchPosition = position;
    });
  }

  /// Handles pan update events with debouncing
  void onPanUpdate(Offset position) async {
    if (!isShownMagnificier) return;

    final now = DateTime.now();
    if (_lastUpdate != null && now.difference(_lastUpdate!) < _updateInterval) {
      return;
    }
    _lastUpdate = now;

    await captureScreen();
    setZoomPosition();
    setState(() {
      touchPosition = position;
    });
  }

  /// Sets the zoom position based on the current configuration
  void setZoomPosition() {
    if (touchPosition == null || screenSize == null) return;

    if (widget.zoomPosition is CustomZoomPosition) {
      _setCustomZoomPosition();
    } else if (widget.zoomPosition is BouncingZoomPosition) {
      _setBouncingZoomPosition();
    } else if (widget.zoomPosition is CustomFunctionZoomPosition) {
      _setCustomFunctionZoomPosition();
    }
  }

  /// Sets position for CustomZoomPosition
  void _setCustomZoomPosition() {
    final zoomPosition = widget.zoomPosition as CustomZoomPosition;
    positionedTop = zoomPosition.top;
    positionedBottom = zoomPosition.bottom;
    positionedLeft = zoomPosition.left;
    positionedRight = zoomPosition.right;
  }

  /// Sets position for BouncingZoomPosition
  void _setBouncingZoomPosition() {
    final zoomPosition = widget.zoomPosition as BouncingZoomPosition;
    final touch = touchPosition!;
    final screen = screenSize!;

    switch (zoomPosition.position) {
      case MagnifierPositionEnum.bouncing:
        _setBouncingPosition(touch, screen);
        break;
      case MagnifierPositionEnum.bouncingTopRightTopLeft:
        _setTopRightTopLeftPosition(touch, screen);
        break;
      case MagnifierPositionEnum.bouncingBottomRightBottomLeft:
        _setBottomRightBottomLeftPosition(touch, screen);
        break;
      case MagnifierPositionEnum.bouncingTopLeftBottomLeft:
        _setTopLeftBottomLeftPosition(touch, screen);
        break;
      case MagnifierPositionEnum.bouncingTopRightBottomRight:
        _setTopRightBottomRightPosition(touch, screen);
        break;
      case MagnifierPositionEnum.fingertips:
        _setFingertipsPosition(touch);
        break;
    }
  }

  /// Sets position for bouncing behavior
  void _setBouncingPosition(Offset touch, Size screen) {
    if (touch.dx < screen.width / 2 && touch.dy < screen.height / 2) {
      positionedTop = 0;
      positionedBottom = null;
      positionedLeft = 0;
      positionedRight = null;
    } else if (touch.dx < screen.width / 2 && touch.dy >= screen.height / 2) {
      positionedTop = null;
      positionedBottom = 0;
      positionedLeft = 0;
      positionedRight = null;
    } else if (touch.dx >= screen.width / 2 && touch.dy < screen.height / 2) {
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
  }

  /// Sets position for top-right to top-left bouncing
  void _setTopRightTopLeftPosition(Offset touch, Size screen) {
    if (touch.dx < screen.width / 2) {
      positionedTop = 0;
      positionedBottom = null;
      positionedLeft = null;
      positionedRight = 0;
    } else {
      positionedTop = 0;
      positionedBottom = null;
      positionedLeft = 0;
      positionedRight = null;
    }
  }

  /// Sets position for bottom-right to bottom-left bouncing
  void _setBottomRightBottomLeftPosition(Offset touch, Size screen) {
    if (touch.dx < screen.width / 2) {
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

  /// Sets position for top-left to bottom-left bouncing
  void _setTopLeftBottomLeftPosition(Offset touch, Size screen) {
    if (touch.dy < screen.height / 2) {
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
  }

  /// Sets position for top-right to bottom-right bouncing
  void _setTopRightBottomRightPosition(Offset touch, Size screen) {
    if (touch.dx < screen.width / 2) {
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
  }

  /// Sets position for fingertips following behavior
  void _setFingertipsPosition(Offset touch) {
    positionedTop = touch.dy - (widget.magnifierSize.height + 20);
    positionedLeft = touch.dx - widget.magnifierSize.width / 2;
    if (positionedTop! < -30) {
      positionedTop = widget.magnifierSize.height;
    }
  }

  /// Sets position for CustomFunctionZoomPosition
  void _setCustomFunctionZoomPosition() {
    final zoomPosition = widget.zoomPosition as CustomFunctionZoomPosition;
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
  }

  /// Clears the screen capture and resets the magnifier state
  Future<void> clearCaptureScreen() async {
    isShownMagnificier = false;
    screenImage?.dispose();
    screenImage = null;
    touchPosition = null;
    setState(() {});
  }
}
