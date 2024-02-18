import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simulator/src/modules/device_module/devices/device_widget.dart';
import 'package:simulator/src/utils/byte_data.dart';
import 'package:simulator/src/utils/color.dart';

class FrameButtonsWidget extends StatelessWidget {
  const FrameButtonsWidget({
    super.key,
    required this.padding,
    required this.buttons,
    required this.child,
  });

  final EdgeInsets padding;
  final List<Widget> buttons;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ...buttons,
        Padding(
          padding: padding,
          child: child,
        ),
      ],
    );
  }
}

class StackedBordersWidget extends StatelessWidget {
  const StackedBordersWidget({
    super.key,
    required this.innerRadius,
    required this.borders,
    required this.child,
  });

  final Radius innerRadius;
  final List<BorderSide> borders;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget child = ClipRRect(
      borderRadius: BorderRadius.all(innerRadius),
      child: this.child,
    );

    double radius = innerRadius.x;
    for (final border in borders) {
      radius += border.width;

      child = Container(
        decoration: BoxDecoration(
          color: border.color,
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: EdgeInsets.all(border.width),
        child: child,
      );
    }

    return child;
  }
}

class IPhonePhysicalHomeButton extends StatelessWidget {
  const IPhonePhysicalHomeButton({
    super.key,
    this.size = 134.0 / 2.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF585858),
          width: 4.0 / 2.0,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
    );
  }
}

class IOSStatusBarBatteryIcon extends StatelessWidget {
  const IOSStatusBarBatteryIcon({
    super.key,
    required this.color,
    this.width = 24.0,
    this.height = 11.5,
  });

  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          OverflowBox(
            maxWidth: width,
            maxHeight: width,
            child: Icon(
              CupertinoIcons.battery_0,
              color: color.withOpacity(0.25),
              size: width,
            ),
          ),
          Positioned(
            left: 2.0,
            top: 2.0,
            bottom: 2.0,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
              width: (width - 7.0) * 1.0,
              height: height - 4.0,
            ),
          ),
        ],
      ),
    );
  }
}

class IOSStatusBarCellularIcon extends StatelessWidget {
  const IOSStatusBarCellularIcon({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _IOSStatusBarCellularIconPainter(
        color: color,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _IOSStatusBarCellularIconPainter extends CustomPainter {
  _IOSStatusBarCellularIconPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const squareWidth = 3.0;
    const squareCount = 4;
    const squareHeights = [
      4 / 10.67,
      6 / 10.67,
      8.33 / 10.67,
      1.0,
    ];
    const signalStrength = 3;

    const radius = Radius.circular(1.0);

    final gap = (size.width - squareWidth * squareCount) / (squareCount - 1);

    Offset currentOffset = Offset.zero;

    for (var i = 0; i < squareCount; i++) {
      final height = size.height * squareHeights[i];

      final rect = Rect.fromLTWH(
        currentOffset.dx,
        currentOffset.dy + size.height - height,
        squareWidth,
        height,
      );

      final rrect = RRect.fromRectAndRadius(rect, radius);
      final color =
          i < signalStrength ? this.color : this.color.withOpacity(0.25);

      canvas.drawRRect(
        rrect,
        Paint()..color = color,
      );

      currentOffset += Offset(squareWidth + gap, 0);
    }
  }

  @override
  bool shouldRepaint(_IOSStatusBarCellularIconPainter oldDelegate) =>
      color != oldDelegate.color;
}

class IOSDeviceSystemUiOverlayWidget extends StatelessWidget {
  const IOSDeviceSystemUiOverlayWidget({super.key, required this.builder});

  final Widget Function(BuildContext context, Color foregroundColor) builder;

  @override
  Widget build(BuildContext context) {
    return DeviceSystemUiOverlayWidget(
      builder: (context, style) {
        final statusBarIconColor =
            style.statusBarIconBrightness == Brightness.light
                ? Colors.white
                : Colors.black;

        return IconTheme(
          data: IconThemeData(
            color: statusBarIconColor,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: statusBarIconColor,
              fontFamily: '.AppleSystemUIFont',
              fontFamilyFallback: const [
                'SF Pro Text',
                'Apple Color Emoji',
              ],
            ),
            child: builder(context, statusBarIconColor),
          ),
        );
      },
    );
  }
}

class IPhoneButton extends StatelessWidget {
  const IPhoneButton({super.key, required this.height});

  static const double offset = 15.0 / 3.0;
  final double height;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(3.0 / 3.0);

    return Container(
      width: 30.0 / 3.0,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        color: const Color.fromRGBO(0, 0, 0, 0.15),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 24.0 / 3.0,
        height: height - (6.0 / 3.0),
        decoration: BoxDecoration(
          borderRadius: radius,
          color: const Color(0xFF575858),
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 24.0 / 3.0,
          height: height - (9.0 / 3.0),
          decoration: BoxDecoration(
            borderRadius: radius,
            color: const Color(0xFF212121),
          ),
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 24.0 / 3.0,
            height: height - (12.0 / 3.0),
            decoration: BoxDecoration(
              borderRadius: radius,
              color: const Color(0xFF2C2D2B),
            ),
          ),
        ),
      ),
    );
  }
}

class IPhoneHomeIndicator extends StatelessWidget {
  const IPhoneHomeIndicator({
    super.key,
    this.width = 420.0 / 3.0,
    this.height = 15.0 / 3.0,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1.0,
      child: DeviceScreenDependentWidget(
        builder: (context, image, byteData) {
          return SizedBox(
            width: width,
            height: height,
            child: _IPhoneHomeIndicatorRenderObjectWidget(
              image: image,
              byteData: byteData,
            ),
          );
        },
      ),
    );
  }
}

class _IPhoneHomeIndicatorRenderObjectWidget extends LeafRenderObjectWidget {
  const _IPhoneHomeIndicatorRenderObjectWidget({
    required this.image,
    required this.byteData,
  });

  final ui.Image image;
  final ByteData byteData;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _IPhoneHomeIndicatorRenderBox(image, byteData);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _IPhoneHomeIndicatorRenderBox renderObject,
  ) {
    renderObject.image = image;
    renderObject.byteData = byteData;
  }
}

class _IPhoneHomeIndicatorRenderBox extends RenderBox {
  _IPhoneHomeIndicatorRenderBox(this._image, this._byteData);

  ui.Image _image;
  ByteData _byteData;

  set image(ui.Image value) {
    _image = value;
    markNeedsPaint();
  }

  set byteData(ByteData value) {
    _byteData = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Find the screen ancestor
    RenderBox ancestor = parent! as RenderBox;

    while (ancestor.size.width != _image.width ||
        ancestor.size.height != _image.height) {
      if (ancestor.parent is! RenderBox) {
        return;
      }

      ancestor = ancestor.parent! as RenderBox;
    }

    const sampleCount = 64;
    final lumas = <double>[];

    final rect = localToGlobal(Offset.zero, ancestor: ancestor) & size;
    for (var i = 0; i < sampleCount; i++) {
      final x = rect.left + (rect.width / sampleCount) * i;
      final y = rect.top + rect.height / 2;

      final point = Offset(x, y);

      final pixelColor = getScreenPixel(
        _byteData,
        _image.width.toDouble(),
        point,
      );

      if (pixelColor != null) {
        final luminance = pixelColor.computeLuminance();
        lumas.add(luminance);
      }
    }
    if (lumas.isEmpty) return;

    final avgLuma = lumas.reduce((a, b) => a + b) / lumas.length;

    late final Color baseColor;

    if (avgLuma > 0.85) {
      baseColor = Colors.black;
    } else if (avgLuma < 0.1) {
      baseColor = const Color(0xFF484848);
    } else {
      baseColor = const Color(0xFF121212);
    }

    final shader = ui.Gradient.linear(
      rect.centerLeft,
      rect.centerRight,
      lumas.map((v) {
        final lumaDeviation = (v - avgLuma);
        final deviationAbsScaled = lumaDeviation.abs() * 0.3;

        late final Color color;

        if (lumaDeviation > 0.0) {
          color = baseColor.darken(deviationAbsScaled);
        } else if (lumaDeviation < 0.0) {
          color = baseColor.lighten(deviationAbsScaled);
        } else {
          color = baseColor;
        }

        return color;
      }).toList(),
      List.generate(lumas.length, (i) => i / (lumas.length - 1)),
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(offset & size, const Radius.circular(15 / 3)),
      Paint()..shader = shader,
    );
  }
}

class IPhoneDigitalIsland extends StatelessWidget {
  const IPhoneDigitalIsland({
    super.key,
    this.width = 376.0 / 3.0,
    this.height = 111.0 / 3.0,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF020201),
        borderRadius: BorderRadius.circular(height / 2.0),
      ),
    );
  }
}

class IPhoneWithDigitalIslandStatusBar extends StatelessWidget {
  const IPhoneWithDigitalIslandStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return IOSDeviceSystemUiOverlayWidget(
      builder: (context, color) {
        return SizedBox(
          height: 59.0,
          child: Row(
            children: [
              const SizedBox(width: 155.0 / 3.0),
              const Text(
                '17:01',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  height: 1.0,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 19.0,
                height: 13.0,
                child: IOSStatusBarCellularIcon(color: color),
              ),
              const SizedBox(width: 7),
              const Icon(CupertinoIcons.wifi, size: 18.0),
              const SizedBox(width: 7),
              IOSStatusBarBatteryIcon(
                width: 27.0,
                height: 13.0,
                color: color,
              ),
              const SizedBox(width: 96.0 / 3.0),
            ],
          ),
        );
      },
    );
  }
}
