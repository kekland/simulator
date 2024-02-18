import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/modules/device_module/device_properties.dart';
import 'package:simulator/src/modules/device_module/devices/avd_skin_device_widget.dart';
import 'package:simulator/src/modules/device_module/devices/google/android_common.dart';

const viewPadding = EdgeInsets.only(
  top: 24.0,
  bottom: 48.0,
);

const pixel3 = DeviceProperties(
  id: 'pixel-3',
  name: 'Pixel 3',
  manufacturer: 'Google',
  platform: TargetPlatform.android,
  screenDiagonalInches: 5.5,
  screenSize: Size(393, 786),
  devicePixelRatio: 2.75,
  viewPaddings: {DeviceOrientation.portraitUp: viewPadding},
  allowedOrientations: {DeviceOrientation.portraitUp},
  frameBuilder: _pixel3Frame,
  // deviceFrame: _iPhone14Frame,
  // deviceKeyboard: _keyboard,
);

Widget _pixel3Frame(BuildContext context, Widget child) {
  return AvdSkinDeviceWidget(
    size: const Size(1194, 2532),
    displaySize: const Size(1080, 2160),
    displayOffset: const Offset(54, 196),
    backgroundAsset: 'assets/skins/pixel_3/port_back.webp',
    foregroundAsset: 'assets/skins/pixel_3/round_corners.webp',
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
