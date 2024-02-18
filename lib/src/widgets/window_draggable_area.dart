import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

class WindowDraggableArea extends StatelessWidget {
  const WindowDraggableArea({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.move,
      child: GestureDetector(
        onPanStart: (_) {
          windowManager.startDragging();
        },
        child: child,
      ),
    );
  }
}
