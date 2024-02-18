// import 'dart:ui' as ui;

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:simulator/src/modules/device_module/device_properties.dart';
// import 'package:simulator/src/modules/device_module/devices/device_widget.dart';
// import 'package:simulator/src/utils/byte_data.dart';
// import 'package:simulator/src/utils/color.dart';

// const viewPadding = EdgeInsets.only(
//   top: 47.0,
//   bottom: 34.0,
// );

// const rotatedViewPadding = EdgeInsets.only(
//   bottom: 21.0,
//   left: 47.0,
//   right: 47.0,
// );

// const iPhone14 = DeviceProperties(
//   id: 'iphone-14',
//   name: 'iPhone 14',
//   manufacturer: 'Apple',
//   platform: TargetPlatform.iOS,
//   screenDiagonalInches: 6.1,
//   screenSize: Size(390, 844),
//   devicePixelRatio: 3.0,
//   viewPaddings: {
//     DeviceOrientation.portraitUp: viewPadding,
//     DeviceOrientation.landscapeLeft: rotatedViewPadding,
//     DeviceOrientation.landscapeRight: rotatedViewPadding,
//   },
//   allowedOrientations: {
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.landscapeLeft,
//     DeviceOrientation.landscapeRight,
//   },
//   frameBuilder: _iPhone14Frame,
//   // deviceFrame: _iPhone14Frame,
//   // deviceKeyboard: _keyboard,
// );

// Widget _iPhone14Frame(BuildContext context, Widget child) {
//   return _IPhone14Frame(child: child);
// }

// const _screenRadius = Radius.circular(47.33);

// const _borderWidth = 15.0;
// const _outerBorderWidth = 4.0;
// const _totalBorderWidth = _borderWidth + _outerBorderWidth;

// const _borderColor = Color(0xFF010101);
// const _outerBorderColor = Color(0xFF2C2C2C);

// class _IPhone14Frame extends StatelessWidget {
//   const _IPhone14Frame({required this.child});

//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return DeviceWidget(
//       frameBuilder: (context, screen) {
//         return Container(
//           padding: const EdgeInsets.all(_totalBorderWidth),
//           decoration: BoxDecoration(
//             color: _borderColor,
//             borderRadius: BorderRadius.circular(
//               _screenRadius.x + _totalBorderWidth,
//             ),
//             border: Border.all(
//               color: _outerBorderColor,
//               width: _outerBorderWidth,
//             ),
//           ),
//           child: ClipRRect(
//             borderRadius: const BorderRadius.all(_screenRadius),
//             child: screen,
//           ),
//         );
//       },
//       screenOverlays: [
//         Align(
//           alignment: Alignment.topLeft,
//           child: DeviceSystemUiOverlayWidget(
//             builder: (context, style) => _IPhone14StatusBar(style: style),
//           ),
//         ),
//         const Align(
//           alignment: Alignment.topCenter,
//           child: _IPhone14Notch(),
//         ),
//         const Positioned(
//           bottom: 31.5 / 3,
//           left: 0.0,
//           right: 0.0,
//           child: _IPhone14HomeIndicator(),
//         ),
//       ],
//       child: child,
//     );
//   }
// }

// class _IPhone14Notch extends StatelessWidget {
//   const _IPhone14Notch({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Transform.translate(
//       offset: const Offset(0.0, -1.0),
//       child: ClipPath(
//         clipper: _IPhone14NotchClipper(),
//         child: Container(
//           width: 520 / 3,
//           height: 101 / 3,
//           color: _borderColor,
//         ),
//       ),
//     );
//   }
// }

// class _IPhone14NotchClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final notchPath = Path();

//     notchPath.moveTo(0, 0);

//     // 36/6 + 67 / 3 + 350 / 3 + 67 / 3 + 36 / 6 = 1040/6

//     notchPath.relativeArcToPoint(
//       const Offset(36 / 6, 36 / 6),
//       clockwise: true,
//       radius: const Radius.circular(36 / 3),
//     );

//     notchPath.relativeLineTo(0.0, 16.0 / 3.0);

//     notchPath.relativeArcToPoint(
//       const Offset(67 / 3, 67 / 3),
//       radius: const Radius.circular(67 / 3),
//       clockwise: false,
//     );

//     notchPath.relativeLineTo(350 / 3, 0);

//     notchPath.relativeArcToPoint(
//       const Offset(67 / 3, -67 / 3),
//       radius: const Radius.circular(67 / 3),
//       clockwise: false,
//     );

//     notchPath.relativeLineTo(0.0, -16.0 / 3.0);

//     notchPath.relativeArcToPoint(
//       const Offset(36 / 6, -36 / 6),
//       clockwise: true,
//       radius: const Radius.circular(36 / 3),
//     );

//     notchPath.close();
//     return notchPath;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
// }

// class _IPhone14StatusBar extends StatelessWidget {
//   const _IPhone14StatusBar({super.key, required this.style});

//   final SystemUiOverlayStyle style;

//   @override
//   Widget build(BuildContext context) {
//     final statusBarIconColor = style.statusBarIconBrightness == Brightness.light
//         ? Colors.white
//         : Colors.black;

//     final time = DateTime.now();

//     // TODO: Support i18n here
//     final hour = time.hour.toString().padLeft(2, '0');
//     final minute = time.minute.toString().padLeft(2, '0');

//     return Padding(
//       padding: const EdgeInsets.only(top: 40 / 3),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const SizedBox(width: 32.0),
//           Text(
//             '$hour:$minute',
//             style: TextStyle(
//               fontFamily: 'SF Pro',
//               fontWeight: FontWeight.w600,
//               fontSize: 15.0,
//               letterSpacing: 0.5,
//               height: 1.0,
//               color: statusBarIconColor,
//             ),
//           ),
//           const Spacer(),
//           CustomPaint(
//             painter: _IOSCellularStatusPainter(color: statusBarIconColor),
//             size: const Size(17, 17),
//           ),
//           const SizedBox(width: 4.0),
//           Icon(
//             CupertinoIcons.wifi,
//             size: 17.0,
//             color: statusBarIconColor,
//           ),
//           const SizedBox(width: 6.0),
//           Icon(
//             CupertinoIcons.battery_100,
//             size: 24.0,
//             color: statusBarIconColor,
//           ),
//           const SizedBox(width: 18.0),
//         ],
//       ),
//     );
//   }
// }

// class _IOSCellularStatusPainter extends CustomPainter {
//   _IOSCellularStatusPainter({required this.color});

//   final Color color;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final squareSize = const Size.square(9) / 3;
//     const radius = Radius.circular(3 / 3);

//     final gap = const Offset(5, 0) / 3;
//     var cOffset = Offset(0, size.height - 4);

//     for (var i = 0; i < 4; i++) {
//       final rect = cOffset & squareSize;
//       cOffset += Offset(gap.dx + squareSize.width, 0);

//       canvas.drawRRect(
//         RRect.fromRectAndRadius(rect, radius),
//         Paint()..color = color.withOpacity(0.2),
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(_IOSCellularStatusPainter oldDelegate) =>
//       color != oldDelegate.color;
// }

// class _IPhone14HomeIndicator extends StatelessWidget {
//   const _IPhone14HomeIndicator({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       heightFactor: 1.0,
//       child: DeviceScreenDependentWidget(
//         builder: (context, image, byteData) {
//           return _IPhone14HomeIndicatorRenderObjectWidget(
//             image: image,
//             byteData: byteData,
//           );
//         },
//       ),
//     );
//   }
// }

// class _IPhone14HomeIndicatorRenderObjectWidget extends LeafRenderObjectWidget {
//   const _IPhone14HomeIndicatorRenderObjectWidget({
//     super.key,
//     required this.image,
//     required this.byteData,
//   });

//   final ui.Image image;
//   final ByteData byteData;

//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     return _IPhone14HomeIndicatorRenderBox(image, byteData);
//   }

//   @override
//   void updateRenderObject(
//     BuildContext context,
//     _IPhone14HomeIndicatorRenderBox renderObject,
//   ) {
//     renderObject.image = image;
//     renderObject.byteData = byteData;
//   }
// }

// class _IPhone14HomeIndicatorRenderBox extends RenderBox {
//   _IPhone14HomeIndicatorRenderBox(this._image, this._byteData);

//   ui.Image _image;
//   ByteData _byteData;

//   set image(ui.Image value) {
//     _image = value;
//     markNeedsPaint();
//   }

//   set byteData(ByteData value) {
//     _byteData = value;
//     markNeedsPaint();
//   }

//   @override
//   void performLayout() {
//     size = const Size(417 / 3, 15 / 3);
//   }

//   @override
//   void paint(PaintingContext context, Offset offset) {
//     // Find the screen ancestor
//     RenderBox ancestor = parent! as RenderBox;

//     while (ancestor.size.width != _image.width ||
//         ancestor.size.height != _image.height) {
//       if (ancestor.parent == null) {
//         return;
//       }

//       ancestor = ancestor.parent! as RenderBox;
//     }

//     const sampleCount = 64;
//     final lumas = <double>[];

//     final rect = localToGlobal(Offset.zero, ancestor: ancestor) & size;
//     for (var i = 0; i < sampleCount; i++) {
//       final x = rect.left + (rect.width / sampleCount) * i;
//       final y = rect.top + rect.height / 2;

//       final point = Offset(x, y);

//       final pixelColor = getScreenPixel(
//         _byteData,
//         _image.width.toDouble(),
//         point,
//       );

//       if (pixelColor != null) {
//         final luminance = pixelColor.computeLuminance();
//         lumas.add(luminance);
//       }
//     }
//     if (lumas.isEmpty) return;

//     final avgLuma = lumas.reduce((a, b) => a + b) / lumas.length;

//     late final Color baseColor;

//     if (avgLuma > 0.85) {
//       baseColor = Colors.black;
//     } else if (avgLuma < 0.1) {
//       baseColor = const Color(0xFF484848);
//     } else {
//       baseColor = const Color(0xFF121212);
//     }

//     final shader = ui.Gradient.linear(
//       rect.centerLeft,
//       rect.centerRight,
//       lumas.map((v) {
//         final lumaDeviation = (v - avgLuma);
//         final deviationAbsScaled = lumaDeviation.abs() * 0.3;

//         late final Color color;

//         if (lumaDeviation > 0.0) {
//           color = baseColor.darken(deviationAbsScaled);
//         } else if (lumaDeviation < 0.0) {
//           color = baseColor.lighten(deviationAbsScaled);
//         } else {
//           color = baseColor;
//         }

//         return color;
//       }).toList(),
//       List.generate(lumas.length, (i) => i / (lumas.length - 1)),
//     );

//     context.canvas.drawRRect(
//       RRect.fromRectAndRadius(offset & size, const Radius.circular(15 / 3)),
//       Paint()..shader = shader,
//     );
//   }
// }
