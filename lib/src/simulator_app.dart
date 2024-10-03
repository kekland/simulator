// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:macos_window_utils/window_manipulator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/app/app_bar.dart';
import 'package:simulator/src/app/simulator_properties_panel.dart';
import 'package:simulator/src/bindings/mobile_gesture_simulator.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/platform_channels/platform_channel_interceptors.dart';
import 'package:simulator/src/state/simulator_state.dart';
import 'package:simulator/src/widgets/material_wrapper.dart';
import 'package:simulator/src/widgets/side_panel_reveal_animator.dart';
import 'package:simulator/src/widgets/window_resizable_area.dart';
import 'package:simulator/src/widgets/windows/window_root_navigator.dart';
import 'package:window_manager/window_manager.dart';

late final SharedPreferences _prefs;

Future<void> runSimulatorApp(
  Widget app, {
  List<SimulatorModule> modules = defaultSimulatorModules,
}) async {
  final binding = SimulatorWidgetsFlutterBinding.ensureInitialized();
  await _initWindow();

  _prefs = await SharedPreferences.getInstance();

  binding
    ..scheduleAttachRootWidget(SimulatorRootWidget(app: app, modules: modules))
    ..scheduleWarmUpFrame();
}

Future<void> _initWindow() async {
  await windowManager.ensureInitialized();

  if (Platform.isMacOS) {
    await WindowManipulator.initialize();

    WindowManipulator.makeWindowFullyTransparent();
    await WindowManipulator.setWindowBackgroundColorToClear();
  }

  const windowOptions = WindowOptions(
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
  );

  await windowManager.waitUntilReadyToShow(
    windowOptions,
    () async {
      if (!Platform.isMacOS) {
        await windowManager.show();
      }
    },
  );
}

final simulatorRootKey = GlobalKey();

class SimulatorRootWidget extends StatelessWidget {
  const SimulatorRootWidget({
    super.key,
    required this.app,
    required this.modules,
  });

  final List<SimulatorModule> modules;
  final Widget app;

  @override
  Widget build(BuildContext context) {
    final binding = WidgetsBinding.instance;

    return binding.wrapWithDefaultView(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SimulatorApp(
          key: simulatorRootKey,
          app: app,
          modules: modules,
        ),
      ),
    );
  }
}

class InheritedSimulatorState extends InheritedWidget {
  const InheritedSimulatorState({
    super.key,
    required Widget child,
    required this.state,
  }) : super(child: child);

  final SimulatorState state;

  static SimulatorState of(BuildContext context) {
    final simulatorState =
        context.dependOnInheritedWidgetOfExactType<InheritedSimulatorState>();

    return simulatorState!.state;
  }

  @override
  bool updateShouldNotify(InheritedSimulatorState oldWidget) {
    return oldWidget.state != state;
  }
}

class SimulatorApp extends StatefulWidget {
  const SimulatorApp({
    super.key,
    required this.modules,
    required this.app,
  });

  final List<SimulatorModule> modules;
  final Widget app;

  @override
  State<SimulatorApp> createState() => SimulatorAppState();
}

class SimulatorAppState extends State<SimulatorApp> {
  late SimulatorState _state;
  SimulatorState get state => _state;

  final _sidePanelKey = GlobalKey();
  bool _isSidePanelVisible = false;

  @override
  void initState() {
    super.initState();

    try {
      final moduleIds = widget.modules.map((e) => e.id).toList();
      var visualOrder =
          _getSavedModuleOrder() ?? widget.modules.map((e) => e.id).toList();

      if (!setEquals(moduleIds.toSet(), visualOrder.toSet())) {
        throw Exception('Module order does not match');
      }

      _state = SimulatorState(
        moduleVisualOrder:
            _getSavedModuleOrder() ?? widget.modules.map((e) => e.id).toList(),
        moduleState: Map.fromEntries(
          widget.modules.map(
            (module) => MapEntry(
              module.id,
              module.createInitialState(_getSavedParamsForModule(module.id)),
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());

      _state = SimulatorState(
        moduleVisualOrder: widget.modules.map((e) => e.id).toList(),
        moduleState: Map.fromEntries(
          widget.modules.map(
            (module) => MapEntry(
              module.id,
              module.createInitialState(null),
            ),
          ),
        ),
      );
    }

    _isSidePanelVisible =
        _prefs.getBool('simulator-side-panel-visible') ?? false;

    PlatformChannelInterceptors.ensureInitialized();
  }

  List<String>? _getSavedModuleOrder() {
    try {
      final json = _prefs.getString('simulator-module-order');

      if (json == null) {
        return null;
      }

      return List<String>.from(jsonDecode(json));
    } catch (e) {
      debugPrint('Error reading saved module order: $e');
      return null;
    }
  }

  Map<String, dynamic>? _getSavedParamsForModule(String id) {
    try {
      final json = _prefs.getString('simulator-$id');

      if (json == null) {
        return null;
      }

      return Map<String, dynamic>.from(jsonDecode(json));
    } catch (e) {
      debugPrint('Error reading saved params for module $id: $e');
      return null;
    }
  }

  void _saveParamsForModules() {
    for (final module in widget.modules) {
      final json = jsonEncode(module.toJson(_state.moduleState[module.id]));
      _prefs.setString('simulator-${module.id}', json);
    }

    _prefs.setBool('simulator-side-panel-visible', _isSidePanelVisible);
  }

  void _saveModuleOrder() {
    final json = jsonEncode(_state.moduleVisualOrder);
    _prefs.setString('simulator-module-order', json);
  }

  void _onToggleSidePanel() {
    _isSidePanelVisible = !_isSidePanelVisible;
    setState(() {});
  }

  Widget _buildAppBar(BuildContext context) {
    return MaterialWrapper(
      child: Stack(
        children: [
          ListenableBuilder(
            listenable: PlatformChannelInterceptors.system,
            builder: (context, _) => SimulatorAppBar(
              appTitle: PlatformChannelInterceptors.system.label,
              primaryColor: PlatformChannelInterceptors.system.primaryColor,
              onToggleSidePanel: _onToggleSidePanel,
              isSidePanelVisible: _isSidePanelVisible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppWrappers(BuildContext context, Widget child) {
    final children = [child];

    final sortedModules = List<SimulatorModule>.from(widget.modules);
    sortedModules.sort(
      (a, b) => b.wrapAppPriority.compareTo(a.wrapAppPriority),
    );

    for (final module in sortedModules) {
      final index = children.length - 1;

      children.add(
        Builder(
          builder: (context) {
            return module.wrapApp(
              context,
              _state,
              children[index],
            );
          },
        ),
      );
    }

    return children.last;
  }

  List<Widget> _buildAppOverlays(BuildContext context) {
    final overlays = <Widget>[];

    for (final module in widget.modules) {
      final overlay = module.buildOverlay(
        context,
        _state,
        (v) => setSimulatorState(
          _state.copyWithModuleState(module.id, v),
        ),
      );

      if (overlay != null) {
        overlays.add(overlay);
      }
    }

    return overlays;
  }

  Widget _buildApp(BuildContext context) {
    return _buildAppWrappers(
      context,
      Stack(
        children: [
          RepaintBoundary(
            key: SimulatorWidgetsFlutterBinding.instance.appKey,
            child: widget.app,
          ),
          ..._buildAppOverlays(context),
        ],
      ),
    );
  }

  void setSimulatorState(SimulatorState value) {
    _state = value;

    _saveParamsForModules();
    _saveModuleOrder();

    setState(() {});
  }

  List<SimulatorModule> get _orderedModules {
    final moduleOrder = _state.moduleVisualOrder;
    final modules = widget.modules;

    return moduleOrder.map((id) {
      return modules.firstWhere((e) => e.id == id);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedSimulatorState(
      state: _state,
      child: ColoredBox(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: WindowResizableArea(
            child: Stack(
              fit: StackFit.passthrough,
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: _buildAppBar(context),
                ),
                Positioned(
                  top: SimulatorAppBar.height + 16.0,
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      var sidePanelClosedDeviceMaxWidth = constraints.maxWidth;
                      var sidePanelOpenDeviceMaxWidth = constraints.maxWidth -
                          SimulatorPropertiesPanel.width -
                          12.0;
      
                      if (sidePanelOpenDeviceMaxWidth < 240.0) {
                        sidePanelOpenDeviceMaxWidth = constraints.maxWidth;
                      }
      
                      return Stack(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: OverflowBox(
                                  alignment: Alignment.topLeft,
                                  minWidth: 0.0,
                                  maxWidth: _isSidePanelVisible
                                      ? sidePanelOpenDeviceMaxWidth
                                      : sidePanelClosedDeviceMaxWidth,
                                  maxHeight: constraints.maxHeight,
                                  child: _buildApp(context),
                                ),
                              ),
                              SidePanelRevealAnimator(
                                isVisible: _isSidePanelVisible,
                                width: SimulatorPropertiesPanel.width + 12.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: MaterialWrapper(
                                    child: SimulatorPropertiesPanel(
                                      key: _sidePanelKey,
                                      modules: _orderedModules,
                                      state: _state,
                                      onChanged: setSimulatorState,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned.fill(
                            child: WindowRootNavigator(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                MobileGestureSimulatorWidget(
                  key: MobileGestureSimulatorWidget.requiredKey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
