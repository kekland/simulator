import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

class WindowResizableArea extends StatelessWidget {
  const WindowResizableArea({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Positioned(
          top: 0.0,
          left: 0.0,
          width: 8.0,
          height: 8.0,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeUpLeft,
            child: GestureDetector(
              onPanStart: (_) {
                windowManager.startResizing(ResizeEdge.topLeft);
              },
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          width: 8.0,
          height: 8.0,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeUpRight,
            child: GestureDetector(
              onPanStart: (_) {
                windowManager.startResizing(ResizeEdge.topRight);
              },
            ),
          ),
        ),
        Positioned(
          right: 0.0,
          bottom: 0.0,
          width: 8.0,
          height: 8.0,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeDownRight,
            child: GestureDetector(
              onPanStart: (_) {
                windowManager.startResizing(ResizeEdge.bottomRight);
              },
            ),
          ),
        ),
        Positioned(
          left: 0.0,
          bottom: 0.0,
          width: 8.0,
          height: 8.0,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeDownLeft,
            child: GestureDetector(
              onPanStart: (_) {
                windowManager.startResizing(ResizeEdge.bottomLeft);
              },
            ),
          ),
        ),
      ],
    );
  }
}
