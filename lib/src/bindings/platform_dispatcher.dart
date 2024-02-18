import 'dart:ui';

import 'package:simulator/src/bindings/test_platform_dispatcher.dart';

typedef PointerDataPacketTransformer = PointerDataPacket Function(
  PointerDataPacket packet,
);

class SimulatorPlatformDispatcher extends TestPlatformDispatcher {
  SimulatorPlatformDispatcher()
      : super(platformDispatcher: PlatformDispatcher.instance);

  void setLocaleOverride(List<Locale>? locales) {
    _localeOverrides = locales;
    onLocaleChanged?.call();
  }

  List<Locale>? _localeOverrides;

  List<Locale> get systemLocales => super.locales;

  @override
  List<Locale> get locales => _localeOverrides ?? super.locales;

  PointerDataPacketTransformer? _pointerDataPacketTransformer;
  set pointerDataPacketTransformer(PointerDataPacketTransformer? callback) {
    _pointerDataPacketTransformer = callback;
  }

  @override
  set onPointerDataPacket(PointerDataPacketCallback? callback) {
    super.onPointerDataPacket = (packet) {
      if (_pointerDataPacketTransformer != null) {
        packet = _pointerDataPacketTransformer!(packet);
      }

      callback?.call(packet);
    };
  }
}

