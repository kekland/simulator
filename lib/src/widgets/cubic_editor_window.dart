import 'package:flutter/material.dart';
import 'package:simulator/src/widgets/windows/window_root_navigator.dart';

Future<void> showCubicEditorWindow(
  BuildContext context, {
  Curve? initialCurve,
  void Function(Curve)? onCurveChanged,
}) async {
  await windowRootNavigatorStateKey.currentState!.pushWindow(
    title: const Text('Edit curve'),
    icon: const Icon(Icons.show_chart_rounded),
    (context) => CubicEditorWindow(
      initialCurve: initialCurve is Cubic? ? initialCurve : null,
      onCurveChanged: onCurveChanged,
    ),
  );
}

class CubicEditorWindow extends StatefulWidget {
  const CubicEditorWindow({super.key, this.initialCurve, this.onCurveChanged});

  final Cubic? initialCurve;
  final void Function(Cubic)? onCurveChanged;

  @override
  State<CubicEditorWindow> createState() => _CubicEditorWindowState();
}

class _CubicEditorWindowState extends State<CubicEditorWindow> {
  late var p1 = widget.initialCurve != null
      ? Offset(widget.initialCurve!.a, widget.initialCurve!.b)
      : Offset.zero;

  late var p2 = widget.initialCurve != null
      ? Offset(widget.initialCurve!.c, widget.initialCurve!.d)
      : Offset.zero;

  void _onCurveChanged() {
    widget.onCurveChanged?.call(Cubic(p1.dx, p1.dy, p2.dx, p2.dy));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final dimension = constraints.biggest.shortestSide;
              const innerDimension = 1200.0;
              const innerPaddedDimension = 600.0;

              const offset = Offset(
                (innerDimension - innerPaddedDimension) / 2.0,
                (innerDimension - innerPaddedDimension) / 2.0,
              );

              return SizedBox.square(
                dimension: dimension,
                child: InteractiveViewer(
                  child: SizedBox.square(
                    dimension: dimension,
                    child: FittedBox(
                      child: SizedBox.square(
                        dimension: innerDimension,
                        child: Stack(
                          fit: StackFit.passthrough,
                          alignment: Alignment.center,
                          children: [
                            GridPaper(
                              color: Colors.white.withOpacity(0.25),
                              interval: 150.0,
                              divisions: 1,
                            ),
                            Center(
                              child: CustomPaint(
                                painter: _GraphAxesPainter(),
                                size: const Size.square(innerPaddedDimension),
                              ),
                            ),
                            Center(
                              child: CustomPaint(
                                painter: _CubicPainter(p1, p2),
                                size: const Size.square(innerPaddedDimension),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Transform.translate(
                                offset: offset,
                                child: _DraggableControlPoint(
                                  offset: p1,
                                  dimension: innerPaddedDimension,
                                  color: Colors.blue,
                                  onOffsetChanged: (offset) {
                                    p1 = offset;
                                    _onCurveChanged();
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Transform.translate(
                                offset: offset,
                                child: _DraggableControlPoint(
                                  offset: p2,
                                  dimension: innerPaddedDimension,
                                  color: Colors.orange,
                                  onOffsetChanged: (offset) {
                                    p2 = offset;
                                    _onCurveChanged();
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          ButtonBar(
            children: [
              TextButton(
                onPressed: () {
                  p1 = Offset.zero;
                  p2 = Offset.zero;
                  _onCurveChanged();
                  setState(() {});
                },
                child: const Text('Reset'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, Cubic(p1.dx, p1.dy, p2.dx, p2.dy));
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GraphAxesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2.0;

    canvas.drawLine(
      Offset(0.0, size.height),
      Offset(size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(0.0, size.height),
      Offset.zero,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CubicPainter extends CustomPainter {
  _CubicPainter(this.p1, this.p2);

  final Offset p1;
  final Offset p2;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height)
      ..cubicTo(
        p1.dx * size.width,
        (1.0 - p1.dy) * size.height,
        p2.dx * size.width,
        (1.0 - p2.dy) * size.height,
        size.width,
        0.0,
      );

    canvas.drawPath(path, paint);

    final controlPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    canvas.drawLine(
      Offset(0.0, size.height),
      Offset(p1.dx * size.width, (1.0 - p1.dy) * size.height),
      controlPaint,
    );

    canvas.drawLine(
      Offset(size.width, 0.0),
      Offset(p2.dx * size.width, (1.0 - p2.dy) * size.height),
      controlPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _DraggableControlPoint extends StatefulWidget {
  const _DraggableControlPoint({
    required this.offset,
    required this.dimension,
    required this.onOffsetChanged,
    required this.color,
  });

  final Offset offset;
  final double dimension;
  final ValueChanged<Offset> onOffsetChanged;
  final Color color;

  @override
  State<_DraggableControlPoint> createState() => _DraggableControlPointState();
}

class _DraggableControlPointState extends State<_DraggableControlPoint> {
  Offset? _panStartPosition;
  Offset? _panStartOffset;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
            widget.offset.dx * widget.dimension,
            (1.0 - widget.offset.dy) * widget.dimension,
          ) -
          const Offset(16.0, 16.0),
      child: GestureDetector(
        onPanStart: (details) {
          _panStartPosition = details.localPosition;
          _panStartOffset = widget.offset;
        },
        onPanUpdate: (details) {
          final position = details.localPosition - _panStartPosition!;
          final x = position.dx / widget.dimension;
          final y = -position.dy / widget.dimension;

          widget.onOffsetChanged(_panStartOffset! + Offset(x, y));
        },
        child: Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
