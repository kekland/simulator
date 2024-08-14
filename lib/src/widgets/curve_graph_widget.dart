import 'dart:math';

import 'package:flutter/material.dart';

class CurvePreviewGraphWidget extends StatelessWidget {
  const CurvePreviewGraphWidget({
    super.key,
    required this.transform,
    this.size = 128.0,
    this.curveColor = Colors.blue,
    this.currentX,
  });

  final double? size;
  final double Function(double t) transform;
  final Color curveColor;
  final double? currentX;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final padding = size != null ? size! / 8.0 : 4.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: CustomPaint(
          painter: _CurveGraphPainter(
            transform: transform,
            curveColor: curveColor,
            guidesColor: Colors.white.withOpacity(0.15),
            currentX: currentX,
          ),
        ),
      ),
    );
  }
}

class _CurveGraphPainter extends CustomPainter {
  _CurveGraphPainter({
    required this.transform,
    required this.curveColor,
    required this.guidesColor,
    this.currentX,
  });

  final double Function(double t) transform;
  final Color curveColor;
  final Color guidesColor;
  final double? currentX;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = curveColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final points = <Offset>[];

    for (var i = 0; i <= 100; i++) {
      final t = i / 100.0;
      final x = t;
      final y = transform(t);

      points.add(Offset(x, y));
    }

    final minY = points.map((point) => point.dy).reduce(min);
    final maxY = points.map((point) => point.dy).reduce(max);

    // Draw guides
    final primaryGuidePaint = Paint()
      ..color = guidesColor.withOpacity(guidesColor.opacity * 2.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final guidePaint = Paint()
      ..color = guidesColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw primary guide
    canvas.drawLine(
      Offset(0.0, size.height),
      Offset(size.width, size.height),
      primaryGuidePaint,
    );

    canvas.drawLine(
      const Offset(0.0, 0.0),
      Offset(0.0, size.height),
      primaryGuidePaint,
    );

    final path = Path();

    // Draw graph
    for (var i = 0; i < points.length - 1; i++) {
      final point = points[i];
      final nextPoint = points[i + 1];

      final x = point.dx * size.width;
      final y = size.height - (point.dy - minY) / (maxY - minY) * size.height;

      final nextX = nextPoint.dx * size.width;
      final nextY =
          size.height - (nextPoint.dy - minY) / (maxY - minY) * size.height;

      path.moveTo(x, y);
      path.lineTo(nextX, nextY);
    }

    canvas.drawPath(path, paint);

    // Draw current X
    if (currentX != null) {
      final x = currentX! * size.width;
      final y = size.height - (transform(currentX!) - minY) / (maxY - minY) * size.height;

      final currentXPaint = Paint()
        ..color = curveColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 4.0, currentXPaint);

      // Draw guides
      canvas.drawLine(
        Offset(x, 0.0),
        Offset(x, size.height),
        guidePaint,
      );

      canvas.drawLine(
        Offset(0.0, y),
        Offset(size.width, y),
        guidePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
