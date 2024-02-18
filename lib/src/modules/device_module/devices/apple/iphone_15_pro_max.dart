import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/modules/device_module/device_properties.dart';
import 'package:simulator/src/modules/device_module/devices/apple/iphone_common.dart';
import 'package:simulator/src/modules/device_module/devices/device_widget.dart';

const _portraitViewPadding = EdgeInsets.only(
  top: 59.0,
  bottom: 34.0,
);

const _landscapeViewPadding = EdgeInsets.only(
  bottom: 21.0,
  left: 59.0,
  right: 59.0,
);

const iPhone15ProMax = DeviceProperties(
  id: 'iphone-15-pro-max',
  name: 'iPhone 15 Pro Max',
  manufacturer: 'Apple',
  platform: TargetPlatform.iOS,
  screenDiagonalInches: 6.7,
  screenSize: Size(430, 932),
  devicePixelRatio: 3.0,
  viewPaddings: {
    DeviceOrientation.portraitUp: _portraitViewPadding,
    DeviceOrientation.landscapeLeft: _landscapeViewPadding,
    DeviceOrientation.landscapeRight: _landscapeViewPadding,
  },
  allowedOrientations: {
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  },
  frameBuilder: _iPhone15ProMaxFrame,
  // deviceFrame: _iPhone14Frame,
  // deviceKeyboard: _keyboard,
);

Widget _iPhone15ProMaxFrame(BuildContext context, Widget child) {
  return DeviceWidget(
    frameBuilder: (context, screen) {
      return FrameButtonsWidget(
        buttons: const [
          Positioned(
            right: 0.0,
            top: 783.0 / 3.0,
            child: IPhoneButton(
              height: 303.0 / 3.0,
            ),
          ),
          Positioned(
            left: 0.0,
            top: 477.0 / 3.0,
            child: IPhoneButton(
              height: 102.0 / 3.0,
            ),
          ),
          Positioned(
            left: 0.0,
            top: 660.0 / 3.0,
            child: IPhoneButton(
              height: 192.0 / 3.0,
            ),
          ),
          Positioned(
            left: 0.0,
            top: 897.0 / 3.0,
            child: IPhoneButton(
              height: 192.0 / 3.0,
            ),
          ),
        ],
        padding:
            const EdgeInsets.symmetric(horizontal: IPhoneButton.offset - 1),
        child: StackedBordersWidget(
          innerRadius: const Radius.circular(165.0 / 3.0),
          borders: const [
            BorderSide(color: Color(0xFF010101), width: 27.0 / 3.0),
            BorderSide(color: Color(0xFF2C2C2C), width: 15.0 / 3.0),
            BorderSide(color: Color(0xFF7F7F7F), width: 3.0 / 3.0),
            BorderSide(color: Color.fromRGBO(0, 0, 0, 0.15), width: 3.0 / 3.0),
          ],
          child: screen,
        ),
      );
    },
    screenOverlays: const [
      Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        child: IPhoneWithDigitalIslandStatusBar(),
      ),
      Positioned(
        top: 33.0 / 3.0,
        left: 456.0 / 3.0,
        child: IPhoneDigitalIsland(),
      ),
      Positioned(
        bottom: 24.0 / 3.0,
        left: 0.0,
        right: 0.0,
        child: IPhoneHomeIndicator(
          width: 462.0 / 3.0,
          height: 15.0 / 3.0,
        ),
      )
    ],
    child: child,
  );
}
