import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/widgets/size_utils.dart';

class InspectorSelectionOverlay extends StatefulWidget {
  const InspectorSelectionOverlay({
    super.key,
    this.rendererKey,
    this.renderObject,
    this.pointerOffset,
    this.onDetached,
  });

  final GlobalKey? rendererKey;
  final RenderObject? renderObject;
  final Offset? pointerOffset;
  final VoidCallback? onDetached;

  @override
  State<InspectorSelectionOverlay> createState() =>
      _InspectorSelectionOverlayState();
}

class _InspectorSelectionOverlayState extends State<InspectorSelectionOverlay> {
  Offset? _localPointerOffset;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerHover: (event) {
        setState(() {
          _localPointerOffset = event.localPosition;
        });
      },
      child: _InspectorSelectionOverlay(
        key: widget.rendererKey,
        renderObject: widget.renderObject,
        pointerOffset: _localPointerOffset ?? widget.pointerOffset,
        onDetached: widget.onDetached,
      ),
    );
  }
}

class _InspectorSelectionOverlay extends LeafRenderObjectWidget {
  const _InspectorSelectionOverlay({
    super.key,
    this.renderObject,
    this.pointerOffset,
    this.onDetached,
  });

  final RenderObject? renderObject;
  final Offset? pointerOffset;
  final VoidCallback? onDetached;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderInspectorSelectionOverlay(
      selectedRenderObject: renderObject,
      pointerOffset: pointerOffset,
      onDetached: onDetached,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderInspectorSelectionOverlay renderObject,
  ) {
    renderObject.selectedRenderObject = this.renderObject;
    renderObject.pointerOffset = pointerOffset;
    renderObject.onDetached = onDetached;
  }
}

class RenderInspectorSelectionOverlay extends RenderBox {
  RenderInspectorSelectionOverlay({
    RenderObject? selectedRenderObject,
    Offset? pointerOffset,
    VoidCallback? onDetached,
  })  : _selectedRenderObject = selectedRenderObject,
        _pointerOffset = pointerOffset,
        _onDetached = onDetached;

  RenderObject? _selectedRenderObject;
  Offset? _pointerOffset;
  VoidCallback? _onDetached;

  set selectedRenderObject(RenderObject? value) {
    _selectedRenderObject = value;
    markNeedsPaint();
  }

  set pointerOffset(Offset? value) {
    _pointerOffset = value;
    markNeedsPaint();
  }

  set onDetached(VoidCallback? value) {
    _onDetached = value;
  }

  Rect? _lastRect;

  void _maybeMarkNeedsPaint() {
    if (_selectedRenderObject != null &&
        _lastRect != _computeRect(_selectedRenderObject!)) {
      markNeedsPaint();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    SimulatorWidgetsFlutterBinding.instance.rootPipelineOwner
        .addAfterFlushCompositingBitsCallback(_maybeMarkNeedsPaint);
  }

  @override
  void detach() {
    SimulatorWidgetsFlutterBinding.instance.rootPipelineOwner
        .removeAfterFlushCompositingBitsCallback(_maybeMarkNeedsPaint);
    super.detach();
  }

  @override
  void performLayout() {
    size = constraints.biggest;
  }

  double _getOpacityForRect(Rect rect) {
    if (_pointerOffset != null && rect.contains(_pointerOffset!)) {
      return 1.0;
    }

    return 0.1;
  }

  Rect _computeRect(RenderObject object) {
    final appRepaintBoundary =
        SimulatorWidgetsFlutterBinding.instance.appRepaintBoundary;

    final Rect rect;

    if (object is RenderBox) {
      rect = Offset.zero & object.size;
    } else {
      rect = object.paintBounds;
    }

    return MatrixUtils.transformRect(
      object.getTransformTo(appRepaintBoundary),
      rect,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_selectedRenderObject == null) return;
    if (!_selectedRenderObject!.attached) {
      _selectedRenderObject = null;
      _onDetached?.call();

      return;
    }

    final appRepaintBoundary =
        SimulatorWidgetsFlutterBinding.instance.appRepaintBoundary;

    final screenSize = appRepaintBoundary.size;
    final targetRect = _computeRect(_selectedRenderObject!);
    _lastRect = targetRect;

    final targetRectPaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final parentRectPaint = Paint()
      ..color = Colors.orange.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    _drawTargetRectOverlay(
      context,
      offset,
      targetRect,
      targetRectPaint,
    );
    RenderBox? parentWithGreaterSize;
    var parent = _selectedRenderObject!.parent;

    while (parent != null) {
      if (parent == appRepaintBoundary) break;

      final parentTargetRect = _computeRect(parent);

      if (parent is RenderBox &&
          parentTargetRect.size.width > targetRect.size.width &&
          parentTargetRect.size.height > targetRect.size.height) {
        parentWithGreaterSize = parent;
        break;
      }

      parent = parent.parent;
    }

    if (parentWithGreaterSize != null) {
      // TODO: Flex support
      if (parentWithGreaterSize is RenderFlex) {}

      final parentRect = parentWithGreaterSize.paintBounds;
      final parentTargetRect = MatrixUtils.transformRect(
        parentWithGreaterSize.getTransformTo(
          SimulatorWidgetsFlutterBinding.instance.appRepaintBoundary,
        ),
        parentRect,
      );

      _drawTargetRectOverlay(
        context,
        offset,
        parentTargetRect,
        parentRectPaint,
      );

      _drawPaddingLines(
        context,
        offset,
        targetRect,
        parentTargetRect,
      );

      _drawTargetRectInfoTextBox(
        context,
        offset,
        targetRect.size,
        screenSize,
        parentTargetRect.shift(const Offset(0, -4.0)),
      );
    } else {
      _drawTargetRectInfoTextBox(
        context,
        offset,
        targetRect.size,
        screenSize,
        targetRect,
      );
    }
  }

  void _drawTargetRectOverlay(
    PaintingContext context,
    Offset offset,
    Rect rect,
    Paint paint,
  ) {
    context.canvas.drawRect(
      rect.shift(offset),
      paint,
    );
  }

  void _drawTargetRectInfoTextBox(
    PaintingContext context,
    Offset offset,
    Size targetSize,
    Size screenSize,
    Rect rect,
  ) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(1.0)
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      text: TextSpan(
        text:
            '${describeIdentity(_selectedRenderObject)} (${targetSize.toFormattedString()})',
        style: const TextStyle(color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final textPainterSize = textPainter.size;
    final textBoxSize = textPainterSize + const Offset(4.0, 4.0);

    final textOffset = positionDependentBox(
      size: screenSize,
      childSize: textBoxSize,
      target: rect.topCenter,
      preferBelow: false,
      margin: 16.0,
    );

    final textPainterRect = Rect.fromLTWH(
      textOffset.dx,
      textOffset.dy,
      textBoxSize.width,
      textBoxSize.height,
    );

    context.canvas.drawRect(
      textPainterRect.shift(offset),
      paint,
    );

    textPainter.paint(
      context.canvas,
      textPainterRect.topLeft + offset + const Offset(2.0, 2.0),
    );

    textPainter.dispose();
  }

  void _drawPaddingTextBox(
    PaintingContext context,
    double padding,
    Offset offset,
    Offset paddingLineCenter,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: padding.toStringAsFixed(1),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final textPainterSize = textPainter.size;
    final textBoxSize = textPainterSize + const Offset(2.0, 2.0);
    final textPainterRect = Rect.fromCenter(
      center: paddingLineCenter,
      width: textBoxSize.width,
      height: textBoxSize.height,
    );

    final paint = Paint()
      ..color = Colors.red.withOpacity(_getOpacityForRect(textPainterRect))
      ..style = PaintingStyle.fill;

    context.canvas.drawRect(
      textPainterRect.shift(offset),
      paint,
    );

    textPainter.paint(
      context.canvas,
      textPainterRect.topLeft + offset + const Offset(1.0, 1.0),
    );

    textPainter.dispose();
  }

  void _drawPaddingLines(
    PaintingContext context,
    Offset offset,
    Rect targetRect,
    Rect parentRect,
  ) {
    final paddingLeft = targetRect.left - parentRect.left;
    final paddingRight = parentRect.right - targetRect.right;
    final paddingTop = targetRect.top - parentRect.top;
    final paddingBottom = parentRect.bottom - targetRect.bottom;

    final paint = Paint()
      ..color = Colors.red.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    if (paddingLeft > 0) {
      context.canvas.drawLine(
        targetRect.centerLeft,
        targetRect.centerLeft - Offset(paddingLeft, 0),
        paint,
      );

      _drawPaddingTextBox(
        context,
        paddingLeft,
        offset,
        targetRect.centerLeft - Offset(paddingLeft / 2, 0),
      );
    }

    if (paddingRight > 0) {
      context.canvas.drawLine(
        targetRect.centerRight,
        targetRect.centerRight + Offset(paddingRight, 0),
        paint,
      );

      _drawPaddingTextBox(
        context,
        paddingRight,
        offset,
        targetRect.centerRight + Offset(paddingRight / 2, 0),
      );
    }

    if (paddingTop > 0) {
      context.canvas.drawLine(
        targetRect.topCenter,
        targetRect.topCenter - Offset(0, paddingTop),
        paint,
      );

      _drawPaddingTextBox(
        context,
        paddingTop,
        offset,
        targetRect.topCenter - Offset(0, paddingTop / 2),
      );
    }

    if (paddingBottom > 0) {
      context.canvas.drawLine(
        targetRect.bottomCenter,
        targetRect.bottomCenter + Offset(0, paddingBottom),
        paint,
      );

      _drawPaddingTextBox(
        context,
        paddingBottom,
        offset,
        targetRect.bottomCenter + Offset(0, paddingBottom / 2),
      );
    }
  }
}
