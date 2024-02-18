import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/modules/device_module/device_properties.dart';
import 'package:simulator/src/modules/device_module/devices/avd_skin_device_widget.dart';
import 'package:simulator/src/modules/device_module/devices/google/android_common.dart';

const viewPadding = EdgeInsets.only(
  top: 32.0,
  bottom: 24.0,
);

const pixel7Pro = DeviceProperties(
  id: 'pixel-7-pro',
  name: 'Pixel 7 Pro',
  manufacturer: 'Google',
  platform: TargetPlatform.android,
  screenDiagonalInches: 6.7,
  screenSize: Size(412, 892),
  devicePixelRatio: 3.5, // TODO: Verify this
  viewPaddings: {DeviceOrientation.portraitUp: viewPadding},
  allowedOrientations: {DeviceOrientation.portraitUp},
  frameBuilder: _pixel7ProFrame,
  // deviceFrame: _iPhone14Frame,
  // deviceKeyboard: _keyboard,
);

Widget _pixel7ProFrame(BuildContext context, Widget child) {
  return AvdSkinDeviceWidget(
    size: const Size(1547, 3272),
    displaySize: const Size(1440, 3120),
    displayOffset: const Offset(48, 66),
    backgroundAsset: 'assets/skins/pixel_7_pro/back.webp',
    foregroundAsset: 'assets/skins/pixel_7_pro/mask.webp',
    screenRadius: BorderRadius.circular(76.0),
    screen: Stack(
      children: [
        child,
        const Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AndroidStatusBar(height: 32.0),
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
