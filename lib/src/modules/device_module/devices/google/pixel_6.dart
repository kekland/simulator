import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/modules/device_module/device_properties.dart';
import 'package:simulator/src/modules/device_module/devices/avd_skin_device_widget.dart';
import 'package:simulator/src/modules/device_module/devices/google/android_common.dart';

const viewPadding = EdgeInsets.only(
  top: 36.0,
  bottom: 24.0,
);

const pixel6 = DeviceProperties(
  id: 'pixel-6',
  name: 'Pixel 6',
  manufacturer: 'Google',
  platform: TargetPlatform.android,
  screenDiagonalInches: 6.4,
  screenSize: Size(412, 915),
  devicePixelRatio: 2.625,
  viewPaddings: {DeviceOrientation.portraitUp: viewPadding},
  allowedOrientations: {DeviceOrientation.portraitUp},
  frameBuilder: _pixel6Frame,
  // deviceFrame: _iPhone14Frame,
  // deviceKeyboard: _keyboard,
);

Widget _pixel6Frame(BuildContext context, Widget child) {
  return AvdSkinDeviceWidget(
    size: const Size(1209, 2553),
    displaySize: const Size(1080, 2400),
    displayOffset: const Offset(60, 69),
    backgroundAsset: 'assets/skins/pixel_6/back.webp',
    foregroundAsset: 'assets/skins/pixel_6/mask.webp',
    screenRadius: BorderRadius.circular(36.0),
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
