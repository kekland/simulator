import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/modules/device_module/device_properties.dart';
import 'package:simulator/src/modules/device_module/devices/avd_skin_device_widget.dart';
import 'package:simulator/src/modules/device_module/devices/google/android_common.dart';

const viewPadding = EdgeInsets.only(
  top: 40.0,
  bottom: 24.0,
);

const pixel5 = DeviceProperties(
  id: 'pixel-5',
  name: 'Pixel 5',
  manufacturer: 'Google',
  platform: TargetPlatform.android,
  screenDiagonalInches: 6.0,
  screenSize: Size(393, 851),
  devicePixelRatio: 2.75,
  viewPaddings: {DeviceOrientation.portraitUp: viewPadding},
  allowedOrientations: {DeviceOrientation.portraitUp},
  frameBuilder: _pixel5Frame,
  // deviceFrame: _iPhone14Frame,
  // deviceKeyboard: _keyboard,
);

Widget _pixel5Frame(BuildContext context, Widget child) {
  return AvdSkinDeviceWidget(
    size: const Size(1211, 2474),
    displaySize: const Size(1080, 2340),
    displayOffset: const Offset(60, 65),
    backgroundAsset: 'assets/skins/pixel_5/back.webp',
    foregroundAsset: 'assets/skins/pixel_5/mask.webp',
    screen: Stack(
      children: [
        child,
        const Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AndroidStatusBar(
            height: 40.0,
            padding: EdgeInsets.only(
              top: 8.0,
              left: 32.0,
            ),
          ),
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
