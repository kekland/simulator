import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:simulator/src/modules/device_module/device_properties.dart';
import 'package:simulator/src/modules/device_module/devices/apple/iphone_common.dart';
import 'package:simulator/src/modules/device_module/devices/device_widget.dart';

const iPhoneSEGen3 = DeviceProperties(
  id: 'iphone-se-gen-3',
  name: 'iPhone SE (Gen 3)',
  manufacturer: 'Apple',
  platform: TargetPlatform.iOS,
  screenDiagonalInches: 4.7,
  screenSize: Size(375, 667),
  devicePixelRatio: 2.0,
  viewPaddings: {
    DeviceOrientation.portraitUp: EdgeInsets.only(top: 20.0),
    DeviceOrientation.landscapeLeft: EdgeInsets.only(top: 20.0),
    DeviceOrientation.landscapeRight: EdgeInsets.only(top: 20.0),
  },
  allowedOrientations: {
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  },
  frameBuilder: _iPhoneSEGen3Frame,
  // deviceFrame: _iPhone14Frame,
  // deviceKeyboard: _keyboard,
);

Widget _iPhoneSEGen3Frame(BuildContext context, Widget child) {
  return DeviceWidget(
    frameBuilder: (context, child) => FrameButtonsWidget(
      padding: const EdgeInsets.symmetric(horizontal: _IPhoneSEButton.offset),
      buttons: const [
        Positioned(
          top: 226.0 / 2.0,
          left: 0.0,
          child: _IPhoneSEButton(
            height: 72.0 / 2.0,
          ),
        ),
        Positioned(
          top: 374.0 / 2.0,
          left: 0.0,
          child: _IPhoneSEButton(
            height: 136.0 / 2.0,
          ),
        ),
        Positioned(
          top: 374.0 / 2.0,
          right: 0.0,
          child: _IPhoneSEButton(
            height: 136.0 / 2.0,
          ),
        ),
        Positioned(
          top: 536.0 / 2.0,
          left: 0.0,
          child: _IPhoneSEButton(
            height: 136.0 / 2.0,
          ),
        ),
      ],
      child: StackedBordersWidget(
        borders: const [
          BorderSide(
            width: 16.0 / 2.0,
            color: Color(0xFF000000),
          ),
          BorderSide(
            width: 12.0 / 2.0,
            color: Color(0xFF161716),
          ),
          BorderSide(
            width: 12.0 / 2.0,
            color: Color(0xFF1F1F1E),
          ),
          BorderSide(
            width: 2.0 / 2.0,
            color: Color(0xFF343534),
          ),
          BorderSide(
            width: 2.0 / 2.0,
            color: Color.fromRGBO(0, 0, 0, 0.5),
          ),
        ],
        innerRadius: const Radius.circular(76.0 / 2.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 176.0 / 2.0,
                horizontal: 10.0 / 2.0,
              ),
              child: ClipRect(child: child),
            ),
            const Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: IPhonePhysicalHomeButton(),
            ),
          ],
        ),
      ),
    ),
    screenOverlays: const [
      _IPhoneSEStatusBar(),
    ],
    child: child,
  );
}

class _IPhoneSEButton extends StatelessWidget {
  const _IPhoneSEButton({required this.height});

  final double height;
  static const double offset = (6.0 + 2.0) / 2.0;

  @override
  Widget build(BuildContext context) {
    return StackedBordersWidget(
      innerRadius: const Radius.circular(6.0 / 2.0),
      borders: const [
        BorderSide(
          color: Color(0xFF1F1F1F),
          width: 6.0 / 2.0,
        ),
        BorderSide(
          color: Color(0xFF414041),
          width: 2.0 / 2.0,
        ),
        BorderSide(
          width: 2.0 / 2.0,
          color: Color.fromRGBO(0, 0, 0, 0.25),
        ),
      ],
      child: SizedBox(
        height: height - (6.0 + 2.0 + 2.0),
      ),
    );
  }
}

class _IPhoneSEStatusBar extends StatelessWidget {
  const _IPhoneSEStatusBar();

  @override
  Widget build(BuildContext context) {
    return IOSDeviceSystemUiOverlayWidget(
      builder: (context, color) {
        return SizedBox(
          height: 20.0,
          child: Stack(
            children: [
              Row(
                children: [
                  const SizedBox(width: 6.0),
                  SizedBox(
                    width: 21.0 - 4.5,
                    height: 14.0 - 4.0,
                    child: IOSStatusBarCellularIcon(color: color),
                  ),
                  const SizedBox(width: 6.5),
                  Text(
                    'Carrier',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      height: 16.0 / 12.0,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    CupertinoIcons.wifi,
                    size: 14.25,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: IOSStatusBarBatteryIcon(color: color),
                  ),
                  const SizedBox(width: 2.0),
                ],
              ),
              const Center(
                child: Text(
                  '9:41 AM',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0,
                    height: 1.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
