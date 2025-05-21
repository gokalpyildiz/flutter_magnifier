import 'package:flutter/material.dart';
import 'package:flutter_magnifier/src/enum/magnifier_position_enum.dart';
import 'package:flutter_magnifier/src/mixin/magnifier_tool_mixin.dart';
import 'package:flutter_magnifier/src/painter/magnifier_painter.dart';

import 'package:flutter_magnifier/src/product/zoom_position_types.dart';

@immutable
class MagnifierTool extends StatefulWidget {
  const MagnifierTool({
    super.key,
    required this.widget,
    this.zoomPosition = const BouncingZoomPosition(MagnifierPosition.bouncingTopLeftBottomLeft),
    this.magnifierSize = const Size(100, 100),
    this.zoomScale = 2.0,
    this.borderColor = Colors.black,
    this.showBorder = true,
  });
  final Widget widget;
  final ZoomPosition zoomPosition;
  final Size magnifierSize;
  final double zoomScale;
  final Color borderColor;
  final bool showBorder;

  @override
  State<MagnifierTool> createState() => _MagnifierToolState();
}

class _MagnifierToolState extends State<MagnifierTool> with SingleTickerProviderStateMixin, MagnifierToolMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundary(
            key: boundaryKey,
            child: Container(
              color: Colors.transparent,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanDown: (details) {
                  onPanDown(details.localPosition);
                },
                onPanUpdate: (details) {
                  onPanUpdate(details.localPosition);
                },
                onPanEnd: (details) {
                  clearCaptureScreen();
                },
                onTapUp: (details) {
                  clearCaptureScreen();
                },
                child: widget.widget,
              ),
            ),
          ),
          if (touchPosition != null && screenImage != null && isShownMagnificier)
            Positioned(top: positionedTop, bottom: positionedBottom, left: positionedLeft, right: positionedRight, child: _zoomWidget()),
        ],
      ),
    );
  }

  SizedBox _zoomWidget() {
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
