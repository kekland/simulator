import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/modules/device_module/device_properties.dart';
import 'package:simulator/src/modules/device_module/devices/avd_skin_device_widget.dart';
import 'package:simulator/src/modules/device_module/devices/google/android_common.dart';

const viewPadding = EdgeInsets.only(
  top: 24.0,
  bottom: 48.0,
);

const pixel2 = DeviceProperties(
  id: 'pixel-2',
  name: 'Pixel 2',
  manufacturer: 'Google',
  platform: TargetPlatform.android,
  screenDiagonalInches: 5.0,
  screenSize: Size(412, 732),
  devicePixelRatio: 2.6,
  viewPaddings: {DeviceOrientation.portraitUp: viewPadding},
  allowedOrientations: {DeviceOrientation.portraitUp},
  frameBuilder: _pixel2Frame,
  // deviceFrame: _iPhone14Frame,
  // deviceKeyboard: _keyboard,
);

Widget _pixel2Frame(BuildContext context, Widget child) {
  return AvdSkinDeviceWidget(
    size: const Size(1370, 2534),
    displaySize: const Size(1080, 1920),
    displayOffset: const Offset(140, 280),
    backgroundAsset: 'assets/skins/pixel_2/port_back.webp',
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
