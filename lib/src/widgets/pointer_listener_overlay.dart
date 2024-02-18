import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PointerListenerOverlay extends LeafRenderObjectWidget {
  const PointerListenerOverlay({super.key});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPointerListenerOverlay();
  }
}

class RenderPointerListenerOverlay extends RenderBox {
  List<RenderPointerListener> _pointerListeners = [];
  RenderObject? _subtreeRenderObject;
  Offset? _pointerOffset;

  set pointerListeners(List<RenderPointerListener> value) {
    _pointerListeners = value;
    markNeedsPaint();
  }

  set subtreeRenderObject(RenderObject? value) {
    _subtreeRenderObject = value;
    markNeedsPaint();
  }

  set pointerOffset(Offset? value) {
    _pointerOffset = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_pointerOffset == null) return;
    if (_subtreeRenderObject == null) return;

    final pointerOffset = _pointerOffset! + offset;

    final focusedPointerListeners = <RenderPointerListener, Rect>{};

    for (final pointerListener in _pointerListeners) {
      var rect = Offset.zero & pointerListener.size;

      rect = MatrixUtils.transformRect(
        pointerListener.getTransformTo(_subtreeRenderObject),
        rect,
      );

      rect = rect.shift(offset);

      if (rect.contains(pointerOffset)) {
        focusedPointerListeners[pointerListener] = rect;
      }
    }

    if (focusedPointerListeners.isEmpty) return;

    final deepestPointerListener = focusedPointerListeners.keys.reduce(
      (a, b) {
        final aDepth = a.depth;
        final bDepth = b.depth;

        if (aDepth > bDepth) {
          return a;
        } else {
          return b;
        }
      },
    );

    final rect = focusedPointerListeners[deepestPointerListener]!;
    _paintCheckerboardRect(
      context.canvas,
      rect: rect,
      color: const Color.fromARGB(255, 213, 116, 255),
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text:
            '${rect.size.width.toStringAsFixed(3)}x${rect.size.height.toStringAsFixed(3)}',
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          background: Paint()..color = Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(context.canvas, rect.topLeft + const Offset(4, 4));

    textPainter.dispose();
  }
}

void _paintCheckerboardRect(
  Canvas canvas, {
  required Rect rect,
  required Color color,
  double opacity = 0.5,
}) {
  final black = Paint()..color = Colors.black.withOpacity(opacity);
  final white = Paint()..color = color.withOpacity(opacity);

  final size = rect.size;
  for (int y = 0; y < size.height; y += 4) {
    for (int x = 0; x < size.width; x += 4) {
      var right = (x + 4).clamp(0, size.width.floor()).toDouble();
      var bottom = (y + 4).clamp(0, size.height.floor()).toDouble();

      int index = (x ~/ 4) + (y ~/ 4);

      canvas.drawRect(
        Rect.fromLTRB(x.toDouble(), y.toDouble(), right, bottom)
            .shift(rect.topLeft),
        index % 2 == 0 ? white : black,
      );
    }
  }
}
