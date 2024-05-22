import 'package:flutter/material.dart';
import 'package:simulator/src/modules/device_module/devices/device_widget.dart';

class AndroidStatusBar extends StatelessWidget {
  const AndroidStatusBar({
    super.key,
    required this.height,
    this.padding = EdgeInsets.zero,
  });

  final EdgeInsets padding;
  final double height;

  @override
  Widget build(BuildContext context) {
    return DeviceSystemUiOverlayWidget(
      builder: (context, style) {
        final Color backgroundColor;

        if (style.statusBarColor != null) {
          backgroundColor = style.statusBarColor!;
        } else if (style.statusBarBrightness != null) {
          backgroundColor = style.statusBarBrightness == Brightness.dark
              ? Colors.black.withOpacity(0.25)
              : Colors.white.withOpacity(0.25);
        } else {
          backgroundColor = Colors.transparent;
        }

        final Color foregroundColor;

        if (style.statusBarIconBrightness != null) {
          foregroundColor = style.statusBarIconBrightness == Brightness.dark
              ? Colors.black
              : Colors.white;
        } else {
          foregroundColor = Colors.black;
        }

        return Container(
          width: double.infinity,
          height: height,
          color: backgroundColor,
          padding: padding,
          child: IconTheme(
            data: IconThemeData(color: foregroundColor),
            child: DefaultTextStyle(
              style: TextStyle(
                fontFamily: 'Roboto',
                color: foregroundColor,
              ),
              child: const Center(
                child: SizedBox(
                  height: 24.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(width: 16.0),
                      Text(
                        '9:31 AM',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.signal_wifi_4_bar_rounded, size: 18.0),
                      Icon(Icons.signal_cellular_4_bar_rounded, size: 18.0),
                      Icon(Icons.battery_std_rounded, size: 18.0),
                      SizedBox(width: 16.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AndroidButtonsNavigationBar extends StatelessWidget {
  const AndroidButtonsNavigationBar({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return DeviceSystemUiOverlayWidget(
      builder: (context, style) {
        final platformBrightness = MediaQuery.of(context).platformBrightness;
        final Color backgroundColor;

        if (style.systemNavigationBarColor != null) {
          backgroundColor = style.systemNavigationBarColor!;
        } else {
          backgroundColor = platformBrightness == Brightness.dark
              ? Colors.black
              : Colors.white;
        }

        final Color foregroundColor;
        if (style.systemNavigationBarIconBrightness != null) {
          foregroundColor =
              style.systemNavigationBarIconBrightness == Brightness.dark
                  ? Colors.black.withOpacity(0.75)
                  : Colors.white.withOpacity(0.75);
        } else {
          foregroundColor = platformBrightness == Brightness.dark
              ? Colors.white.withOpacity(0.75)
              : Colors.black.withOpacity(0.75);
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Easing.legacyDecelerate,
          width: double.infinity,
          height: 48.0,
          color: backgroundColor,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: CustomPaint(
                    size: const Size(12, 14),
                    painter: _BackTrianglePainter(color: foregroundColor),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Icon(
                    Icons.circle_rounded,
                    size: 18.0,
                    color: foregroundColor,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Icon(
                    Icons.square_rounded,
                    size: 18.0,
                    color: foregroundColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BackTrianglePainter extends CustomPainter {
  _BackTrianglePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(10.4842, 0.146115);
    path.cubicTo(11.1507, -0.255119, 12, 0.224897, 12, 1.00285);
    path.lineTo(12, 12.9973);
    path.cubicTo(12, 13.7752, 11.1507, 14.2553, 10.4842, 13.854);
    path.lineTo(0.522151, 7.8568);
    path.cubicTo(-0.123505, 7.46812, -0.123506, 6.53202, 0.522151, 6.14333);
    path.lineTo(10.4842, 0.146115);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BackTrianglePainter oldDelegate) =>
      color != oldDelegate.color;
}

class AndroidBarNavigationBar extends StatelessWidget {
  const AndroidBarNavigationBar({
    super.key,
    this.height = 24.0,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return DeviceSystemUiOverlayWidget(
      builder: (context, style) {
        final platformBrightness = MediaQuery.of(context).platformBrightness;

        final Color foregroundColor;
        if (style.systemNavigationBarIconBrightness != null) {
          foregroundColor =
              style.systemNavigationBarIconBrightness == Brightness.dark
                  ? Colors.black.withOpacity(0.75)
                  : Colors.white.withOpacity(0.75);
        } else {
          foregroundColor = platformBrightness == Brightness.dark
              ? Colors.white.withOpacity(0.75)
              : Colors.black.withOpacity(0.75);
        }

        return SizedBox(
          height: height,
          child: Center(
            child: Container(
              width: 100.0,
              height: 6.0,
              decoration: BoxDecoration(
                color: foregroundColor,
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
