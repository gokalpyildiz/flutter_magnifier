import 'package:flutter/material.dart';
import 'package:flutter_magnifier/src/enum/magnifier_position_enum.dart';
import 'package:flutter_magnifier/src/mixin/magnifier_tool_mixin.dart';
import 'package:flutter_magnifier/src/painter/magnifier_painter.dart';
import 'package:flutter_magnifier/src/zoom_position_types.dart';

/// A widget that provides a magnifying glass effect over its child widget.
///
/// The [MagnifierTool] allows users to magnify portions of the screen
/// by touching and dragging. It supports various positioning modes and
/// customization options.
@immutable
class MagnifierTool extends StatefulWidget {
  /// Creates a magnifier tool widget.
  ///
  /// The [widget] parameter is required and represents the content to be magnified.
  ///
  /// The [zoomPosition] parameter determines how the magnifier follows the touch point.
  /// Defaults to [BouncingZoomPosition] with [MagnifierPosition.bouncingTopLeftBottomLeft].
  ///
  /// The [magnifierSize] parameter sets the size of the magnifier lens.
  /// Defaults to 100x100.
  ///
  /// The [zoomScale] parameter determines the magnification level.
  /// Defaults to 2.0.
  ///
  /// The [borderColor] parameter sets the color of the magnifier border.
  /// Defaults to black.
  ///
  /// The [showBorder] parameter determines whether to show the magnifier border.
  /// Defaults to true.
  const MagnifierTool({
    super.key,
    required this.widget,
    this.zoomPosition = const BouncingZoomPosition(
      MagnifierPositionEnum.bouncingTopLeftBottomLeft,
    ),
    this.magnifierSize = const Size(100, 100),
    this.zoomScale = 2.0,
    this.borderColor = Colors.black,
    this.showBorder = true,
  });

  /// The widget to be magnified
  final Widget widget;

  /// The position configuration for the magnifier
  final ZoomPosition zoomPosition;

  /// The size of the magnifier lens
  final Size magnifierSize;

  /// The magnification scale factor
  final double zoomScale;

  /// The color of the magnifier border
  final Color borderColor;

  /// Whether to show the magnifier border
  final bool showBorder;

  @override
  State<MagnifierTool> createState() => _MagnifierToolState();
}

class _MagnifierToolState extends State<MagnifierTool>
    with SingleTickerProviderStateMixin, MagnifierToolMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMainContent(),
          if (_shouldShowMagnifier) _buildMagnifier(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return RepaintBoundary(
      key: boundaryKey,
      child: Container(
        color: Colors.transparent,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanDown: (details) => onPanDown(details.localPosition),
          onPanUpdate: (details) => onPanUpdate(details.localPosition),
          onPanEnd: (_) => clearCaptureScreen(),
          onTapUp: (_) => clearCaptureScreen(),
          child: widget.widget,
        ),
      ),
    );
  }

  Widget _buildMagnifier() {
    return Positioned(
      top: positionedTop,
      bottom: positionedBottom,
      left: positionedLeft,
      right: positionedRight,
      child: _zoomWidget(),
    );
  }

  bool get _shouldShowMagnifier =>
      touchPosition != null && screenImage != null && isShownMagnificier;

  Widget _zoomWidget() {
    return SizedBox(
      width: widget.magnifierSize.width,
      height: widget.magnifierSize.height,
      child: CustomPaint(
        painter: MagnifierPainter(
          position: touchPosition!,
          image: screenImage!,
          scale: widget.zoomScale,
          imageSize: screenSize!,
          shorBorder: widget.showBorder,
          borderColor: widget.borderColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    screenImage?.dispose();
    super.dispose();
  }
}
