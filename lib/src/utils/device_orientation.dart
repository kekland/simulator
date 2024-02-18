import 'package:flutter/services.dart';

extension OrientationExtension on DeviceOrientation {
  int get quarterTurns {
    switch (this) {
      case DeviceOrientation.portraitUp:
        return 0;
      case DeviceOrientation.landscapeLeft:
        return -1;
      case DeviceOrientation.portraitDown:
        return -2;
      case DeviceOrientation.landscapeRight:
        return -3;
    }
  }
}
