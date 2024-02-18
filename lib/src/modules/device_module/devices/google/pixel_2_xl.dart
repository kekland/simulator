import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/modules/device_module/device_properties.dart';
import 'package:simulator/src/modules/device_module/devices/avd_skin_device_widget.dart';
import 'package:simulator/src/modules/device_module/devices/google/android_common.dart';

const viewPadding = EdgeInsets.only(
  top: 24.0,
  bottom: 48.0,
);

const pixel2Xl = DeviceProperties(
  id: 'pixel-2-xl',
  name: 'Pixel 2 XL',
  manufacturer: 'Google',
  platform: TargetPlatform.android,
  screenDiagonalInches: 6.0,
  screenSize: Size(412, 824),
  devicePixelRatio: 3.5,
  viewPaddings: {DeviceOrientation.portraitUp: viewPadding},
  allowedOrientations: {DeviceOrientation.portraitUp},
  frameBuilder: _pixel2XlFrame,
  // deviceFrame: _iPhone14Frame,
  // deviceKeyboard: _keyboard,
);

Widget _pixel2XlFrame(BuildContext context, Widget child) {
  return AvdSkinDeviceWidget(
    size: const Size(1858, 3456),
    displaySize: const Size(1440, 2880),
    displayOffset: const Offset(201, 245),
    backgroundAsset: 'assets/skins/pixel_2_xl/port_back.webp',
    foregroundAsset: 'assets/skins/pixel_2_xl/round_corners.webp',
    screenRadius: BorderRadius.circular(96.0),
    screen: Stack(
      children: [
        child,
        const Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AndroidStatusBar(height: 24.0),
        ),
        const Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: AndroidButtonsNavigationBar(height: 48.0),
        ),
      ],
    ),
  );
}
