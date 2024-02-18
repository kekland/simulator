import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const defaultViewPaddings = {
  DeviceOrientation.portraitUp: EdgeInsets.zero,
  DeviceOrientation.portraitDown: EdgeInsets.zero,
  DeviceOrientation.landscapeLeft: EdgeInsets.zero,
  DeviceOrientation.landscapeRight: EdgeInsets.zero,
};

const defaultAllowedOrientations = {
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
  DeviceOrientation.landscapeLeft,
  DeviceOrientation.landscapeRight,
};

typedef DeviceFrameBuilder = Widget Function(
  BuildContext context,
  Widget child,
);

class DeviceProperties {
  const DeviceProperties({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.platform,
    required this.screenDiagonalInches,
    required this.devicePixelRatio,
    required this.screenSize,
    this.viewPaddings = defaultViewPaddings,
    this.allowedOrientations = defaultAllowedOrientations,
    this.frameBuilder,
  });

  final String id;
  final String name;
  final String manufacturer;
  final TargetPlatform platform;
  final double screenDiagonalInches;
  final double devicePixelRatio;
  final Size screenSize;
  final Map<DeviceOrientation, EdgeInsets> viewPaddings;
  final Set<DeviceOrientation> allowedOrientations;

  final DeviceFrameBuilder? frameBuilder;

  DeviceOrientation getScreenOrientation(DeviceOrientation orientation) {
    if (allowedOrientations.contains(orientation)) {
      return orientation;
    }

    return DeviceOrientation.portraitUp;
  }

  Size getScreenSize(DeviceOrientation orientation) {
    if (orientation == DeviceOrientation.portraitUp ||
        orientation == DeviceOrientation.portraitDown) {
      return screenSize;
    }

    return Size(screenSize.height, screenSize.width);
  }
}
