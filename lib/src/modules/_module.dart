import 'package:flutter/widgets.dart';
import 'package:simulator/src/modules/animation_module.dart';
import 'package:simulator/src/modules/device_module.dart';
import 'package:simulator/src/modules/gestures_module.dart';
import 'package:simulator/src/modules/inspector_module.dart';
import 'package:simulator/src/modules/keyboard_module.dart';
import 'package:simulator/src/modules/locale_module.dart';
import 'package:simulator/src/modules/media_query_module.dart';
import 'package:simulator/src/modules/debug_module.dart';
import 'package:simulator/src/modules/screenshot_module.dart';
import 'package:simulator/src/modules/vm_module.dart';
import 'package:simulator/src/modules/window_module.dart';
import 'package:simulator/src/state/simulator_state.dart';

const defaultSimulatorModules = <SimulatorModule>[
  WindowModule(),
  ScreenshotModule(),
  DeviceModule(),
  KeyboardModule(),
  GesturesModule(),
  VmModule(),
  DebugModule(),
  LocaleModule(),
  MediaQueryModule(),
  InspectorModule(),
  AnimationModule(),
];

abstract class SimulatorModule<T> { 
  const SimulatorModule();

  String get id;

  T createInitialState(Map<String, dynamic>? json);
  Map<String, dynamic> toJson(T data);

  T getDataFromState(SimulatorState state) {
    return state.get<T>(id);
  }

  Widget buildPanel(
    BuildContext context,
    SimulatorState state,
    ValueChanged<T> onChanged,
  );

  Widget wrapApp(
    BuildContext context,
    SimulatorState state,
    Widget child,
  ) {
    return child;
  }

  Widget? buildOverlay(
    BuildContext context,
    SimulatorState state,
    ValueChanged<T> onChanged,
  ) {
    return null;
  }

  int get wrapAppPriority => 0;
}
