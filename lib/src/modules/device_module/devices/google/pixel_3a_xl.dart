import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/modules/device_module/device_properties.dart';
import 'package:simulator/src/modules/device_module/devices/avd_skin_device_widget.dart';
import 'package:simulator/src/modules/device_module/devices/google/android_common.dart';

const viewPadding = EdgeInsets.only(
  top: 24.0,
  bottom: 48.0,
);

const pixel3aXl = DeviceProperties(
  id: 'pixel-3a-xl',
  name: 'Pixel 3a XL',
  manufacturer: 'Google',
  platform: TargetPlatform.android,
  screenDiagonalInches: 6.0,
  screenSize: Size(412, 824),
  devicePixelRatio: 2.625,
  viewPaddings: {DeviceOrientation.portraitUp: viewPadding},
  allowedOrientations: {DeviceOrientation.portraitUp},
  frameBuilder: _pixel3aXlFrame,
  // deviceFrame: _iPhone14Frame,
  // deviceKeyboard: _keyboard,
);

Widget _pixel3aXlFrame(BuildContext context, Widget child) {
  return AvdSkinDeviceWidget(
    size: const Size(1206, 2533),
    displaySize: const Size(1080, 2160),
    displayOffset: const Offset(58, 198),
    backgroundAsset: 'assets/skins/pixel_3a_xl/port_back.webp',
    foregroundAsset: 'assets/skins/pixel_3a_xl/rounded_corners.webp',
    screenRadius: BorderRadius.circular(40.0),
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
