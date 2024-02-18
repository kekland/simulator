import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/modules/device_module/device_properties.dart';
import 'package:simulator/src/modules/device_module/devices/avd_skin_device_widget.dart';
import 'package:simulator/src/modules/device_module/devices/google/android_common.dart';

const viewPadding = EdgeInsets.only(
  top: 36.0,
  bottom: 24.0,
);

const pixel4 = DeviceProperties(
  id: 'pixel-4',
  name: 'Pixel 4',
  manufacturer: 'Google',
  platform: TargetPlatform.android,
  screenDiagonalInches: 5.7,
  screenSize: Size(393, 830),
  devicePixelRatio: 2.75,
  viewPaddings: {DeviceOrientation.portraitUp: viewPadding},
  allowedOrientations: {DeviceOrientation.portraitUp},
  frameBuilder: _pixel4Frame,
  // deviceFrame: _iPhone14Frame,
  // deviceKeyboard: _keyboard,
);

Widget _pixel4Frame(BuildContext context, Widget child) {
  return AvdSkinDeviceWidget(
    size: const Size(1178, 2498),
    displaySize: const Size(1080, 2280),
    displayOffset: const Offset(46, 146),
    backgroundAsset: 'assets/skins/pixel_4/back.webp',
    foregroundAsset: 'assets/skins/pixel_4/mask.webp',
    screenRadius: BorderRadius.circular(104.0),
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
