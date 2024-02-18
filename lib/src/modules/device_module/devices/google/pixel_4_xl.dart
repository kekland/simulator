import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/modules/device_module/device_properties.dart';
import 'package:simulator/src/modules/device_module/devices/avd_skin_device_widget.dart';
import 'package:simulator/src/modules/device_module/devices/google/android_common.dart';

const viewPadding = EdgeInsets.only(
  top: 36.0,
  bottom: 24.0,
);

const pixel4Xl = DeviceProperties(
  id: 'pixel-4-xl',
  name: 'Pixel 4 XL',
  manufacturer: 'Google',
  platform: TargetPlatform.android,
  screenDiagonalInches: 6.3,
  screenSize: Size(412, 869),
  devicePixelRatio: 3.5,
  viewPaddings: {DeviceOrientation.portraitUp: viewPadding},
  allowedOrientations: {DeviceOrientation.portraitUp},
  frameBuilder: _pixel4XlFrame,
  // deviceFrame: _iPhone14Frame,
  // deviceKeyboard: _keyboard,
);

Widget _pixel4XlFrame(BuildContext context, Widget child) {
  return AvdSkinDeviceWidget(
    size: const Size(1571, 3332),
    displaySize: const Size(1440, 3040),
    displayOffset: const Offset(61, 195),
    backgroundAsset: 'assets/skins/pixel_4_xl/back.webp',
    foregroundAsset: 'assets/skins/pixel_4_xl/mask.webp',
    screenRadius: BorderRadius.circular(140.0),
    screen: Stack(
      children: [
        child,
        const Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AndroidStatusBar(height: 36.0),
        ),
        const Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: AndroidBarNavigationBar(height: 24.0),
        ),
      ],
    ),
  );
}
