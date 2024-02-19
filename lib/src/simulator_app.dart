// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';
import 'dart:io';

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
import 'package:simulator/src/widgets/side_panel_reveal_animator.dart';
import 'package:simulator/src/widgets/window_resizable_area.dart';
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
      await windowManager.setAsFrameless();

      if (!Platform.isMacOS) {
        await windowManager.show();
      }
    },
  );
}

final _simulatorRootKey = GlobalKey();

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
          key: _simulatorRootKey,
          app: app,
          modules: modules,
        ),
      ),
    );
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
      _state = SimulatorState(
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

  void _onToggleSidePanel() {
    _isSidePanelVisible = !_isSidePanelVisible;
    setState(() {});
  }

  Widget _wrapWithMaterialStuff(BuildContext context, {required Widget child}) {
    return ListenableBuilder(
      listenable: PlatformChannelInterceptors.system,
      builder: (context, child) {
        final primaryColor =
            PlatformChannelInterceptors.system.primaryColor ?? Colors.blue;

        return Theme(
          data: ThemeData(
            platform: TargetPlatform.android,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              brightness: Brightness.dark,
            ),
          ),
          child: child!,
        );
      },
      child: DefaultTextEditingShortcuts(
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Actions(
            actions: WidgetsApp.defaultActions,
            child: Localizations(
              locale: const Locale('en', 'US'),
              delegates: const [
                DefaultWidgetsLocalizations.delegate,
                DefaultMaterialLocalizations.delegate,
              ],
              child: Material(
                type: MaterialType.transparency,
                child: Navigator(
                  onPopPage: (route, result) {
                    return true;
                  },
                  pages: [
                    MaterialPage(child: child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return _wrapWithMaterialStuff(
      context,
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
      );

      if (overlay != null) {
        overlays.add(overlay);
      }
    }

    return overlays;
  }

  Widget _buildApp(BuildContext context) {
    return WindowResizableArea(
      child: _buildAppWrappers(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
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
                  builder: (context, constraints) => Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: OverflowBox(
                          maxWidth: constraints.maxWidth,
                          maxHeight: constraints.maxHeight,
                          child: _buildApp(context),
                        ),
                      ),
                      SidePanelRevealAnimator(
                        isVisible: _isSidePanelVisible,
                        width: SimulatorPropertiesPanel.width + 12.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: _wrapWithMaterialStuff(
                            context,
                            child: SimulatorPropertiesPanel(
                              key: _sidePanelKey,
                              modules: widget.modules,
                              state: _state,
                              onChanged: (value) {
                                _state = value;
                                _saveParamsForModules();

                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              MobileGestureSimulatorWidget(
                key: MobileGestureSimulatorWidget.requiredKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
