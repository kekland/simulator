// ignore_for_file: implementation_imports

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/binding.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/bindings/app_image_extractor.dart';
import 'package:simulator/src/bindings/binary_messenger.dart';
import 'package:simulator/src/bindings/mobile_gesture_simulator.dart';
import 'package:simulator/src/bindings/pipeline_owner.dart';
import 'package:simulator/src/bindings/platform_dispatcher.dart';
import 'package:simulator/src/bindings/pointer_listener_extractor.dart';
import 'package:simulator/src/bindings/system_ui_chrome_extractor.dart';

class SimulatorWidgetsFlutterBinding extends BindingBase
    with
        GestureBinding,
        SchedulerBinding,
        ServicesBinding,
        PaintingBinding,
        SemanticsBinding,
        RendererBinding,
        WidgetsBinding,
        PointerListenerExtractorBinding,
        SystemUiChromeExtractorBinding,
        AppImageExtractorBinding,
        MobileGestureSimulatorBinding {
  SimulatorWidgetsFlutterBinding()
      : _platformDispatcher = SimulatorPlatformDispatcher(),
        super();

  static WidgetsBinding ensureInitialized() {
    if (_instance != null) return _instance!;

    _instance = SimulatorWidgetsFlutterBinding();

    // Do more stuff here

    return _instance!;
  }

  static SimulatorWidgetsFlutterBinding? _instance;
  static SimulatorWidgetsFlutterBinding get instance => _instance!;

  final SimulatorPlatformDispatcher _platformDispatcher;

  @override
  SimulatorPlatformDispatcher get platformDispatcher => _platformDispatcher;

  @override
  SimulatorPipelineOwner createRootPipelineOwner() {
    return SimulatorPipelineOwner();
  }

  @override
  SimulatorBinaryMessenger get defaultBinaryMessenger =>
      super.defaultBinaryMessenger as SimulatorBinaryMessenger;

  @override
  BinaryMessenger createBinaryMessenger() {
    return SimulatorBinaryMessenger(super.createBinaryMessenger());
  }

  final appKey = GlobalKey();
  final deviceScreenKey = GlobalKey();
  final appWithDeviceFrameKey = GlobalKey();

  RenderRepaintBoundary get appRepaintBoundary =>
      appKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

  void forceRebuildApp() {
    reassembleApplication();
  }
}
