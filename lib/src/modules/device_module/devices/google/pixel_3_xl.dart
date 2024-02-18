import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/modules/device_module/device_properties.dart';
import 'package:simulator/src/modules/device_module/devices/avd_skin_device_widget.dart';
import 'package:simulator/src/modules/device_module/devices/google/android_common.dart';

const viewPadding = EdgeInsets.only(
  top: 48.0,
  bottom: 48.0,
);

const pixel3Xl = DeviceProperties(
  id: 'pixel-3-xl',
  name: 'Pixel 3 XL',
  manufacturer: 'Google',
  platform: TargetPlatform.android,
  screenDiagonalInches: 6.3,
  screenSize: Size(412, 846),
  devicePixelRatio: 3.5,
  viewPaddings: {DeviceOrientation.portraitUp: viewPadding},
  allowedOrientations: {DeviceOrientation.portraitUp},
  frameBuilder: _pixel3XlFrame,
  // deviceFrame: _iPhone14Frame,
  // deviceKeyboard: _keyboard,
);

Widget _pixel3XlFrame(BuildContext context, Widget child) {
  return AvdSkinDeviceWidget(
    size: const Size(1684, 3246),
    displaySize: const Size(1440, 2960),
    displayOffset: const Offset(126, 72),
    backgroundAsset: 'assets/skins/pixel_3_xl/port_back.webp',
    foregroundAsset: 'assets/skins/pixel_3_xl/round_corners.webp',
    screenRadius: BorderRadius.circular(64.0),
    screen: Stack(
      children: [
        child,
        const Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AndroidStatusBar(height: 48.0),
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
