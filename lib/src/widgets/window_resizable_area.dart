import 'dart:io';

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
        if (!Platform.isMacOS)
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
        if (!Platform.isMacOS)
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
        if (!Platform.isMacOS)
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
        Positioned(
          right: 0.0,
          bottom: 0.0,
          width: 24.0,
          height: 24.0,
          child: Container(
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Builder(
              builder: (context) {
                const child = Center(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.south_east_rounded,
                        color: Colors.black,
                        size: 16.0,
                      ),
                      Icon(
                        Icons.north_west_rounded,
                        color: Colors.black,
                        size: 16.0,
                      ),
                    ],
                  ),
                );

                if (Platform.isMacOS) {
                  return const _MacOSResizableGestureDetector(
                    child: child,
                  );
                }

                return MouseRegion(
                  cursor: SystemMouseCursors.resizeDownRight,
                  child: GestureDetector(
                    onPanStart: (_) {
                      windowManager.startResizing(ResizeEdge.bottomRight);
                    },
                    child: child,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _MacOSResizableGestureDetector extends StatefulWidget {
  const _MacOSResizableGestureDetector({
    required this.child,
  });

  final Widget child;

  @override
  State<_MacOSResizableGestureDetector> createState() =>
      _MacOSResizableGestureDetectorState();
}

class _MacOSResizableGestureDetectorState
    extends State<_MacOSResizableGestureDetector> {
  Size? _initialSize;
  Offset? _initialPanPosition;

  @override
  void initState() {
    super.initState();
    windowManager.setResizable(false);
  }

  @override
  void dispose() {
    windowManager.setResizable(true);
    super.dispose();
  }

  Future<void> onPanStart(DragStartDetails details) async {
    _initialSize = await windowManager.getSize();
    _initialPanPosition = details.globalPosition;
  }

  Future<void> onPanUpdate(DragUpdateDetails details) async {
    if (_initialPanPosition == null) return;
    final delta = details.globalPosition - _initialPanPosition!;
    final newSize = _initialSize! + delta;

    await windowManager.setSize(
      Size(
        newSize.width.roundToDouble(),
        newSize.height.roundToDouble(),
      ),
    );
  }

  Future<void> onPanEnd() async {
    _initialPanPosition = null;
    _initialSize = null;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeUpLeftDownRight,
      hitTestBehavior: HitTestBehavior.deferToChild,
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: (_) => onPanEnd(),
        onPanCancel: onPanEnd,
        child: widget.child,
      ),
    );
  }
}
