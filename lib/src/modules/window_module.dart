import 'package:flutter/material.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/state/simulator_state.dart';
import 'package:window_manager/window_manager.dart';

class WindowProperties {
  const WindowProperties({
    required this.alwaysOnTop,
    required this.hasTitleBar,
  });

  factory WindowProperties.fromJson(Map<String, dynamic> json) {
    return WindowProperties(
      alwaysOnTop: json['alwaysOnTop'],
      hasTitleBar: json['hasTitleBar'],
    );
  }

  final bool alwaysOnTop;
  final bool hasTitleBar;

  WindowProperties copyWith({
    bool? alwaysOnTop,
    bool? hasTitleBar,
  }) {
    return WindowProperties(
      alwaysOnTop: alwaysOnTop ?? this.alwaysOnTop,
      hasTitleBar: hasTitleBar ?? this.hasTitleBar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alwaysOnTop': alwaysOnTop,
      'hasTitleBar': hasTitleBar,
    };
  }
}

class WindowModule extends SimulatorModule<WindowProperties> {
  const WindowModule();

  @override
  Widget buildPanel(
    BuildContext context,
    SimulatorState state,
    ValueChanged<WindowProperties> onChanged,
  ) {
    final data = getDataFromState(state);
    windowManager.setAlwaysOnTop(data.alwaysOnTop);

    if (data.hasTitleBar) {
      windowManager.setTitleBarStyle(
        TitleBarStyle.normal,
        windowButtonVisibility: true,
      );
    } else {
      windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
    }

    return SectionCard(
      leading: const Icon(Icons.window_rounded),
      title: const Text('Window'),
      builder: (context) => SectionList(
        automaticallyImplyDividers: false,
        children: [
          CheckboxListTile(
            onChanged: (v) => onChanged(data.copyWith(alwaysOnTop: v)),
            value: data.alwaysOnTop,
            title: const Text('Always on top'),
            subtitle: const Text(
              'Whether the simulator window should always be on top of other windows.',
            ),
          ),
          CheckboxListTile(
            onChanged: (v) => onChanged(data.copyWith(hasTitleBar: v)),
            value: data.hasTitleBar,
            title: const Text('Title bar visibility'),
            subtitle: const Text(
              'Whether the simulator window should have a native title bar.',
            ),
          ),
        ],
      ),
    );
  }

  @override
  WindowProperties createInitialState(Map<String, dynamic>? json) {
    if (json != null) {
      return WindowProperties.fromJson(json);
    }

    return const WindowProperties(alwaysOnTop: false, hasTitleBar: false);
  }

  @override
  String get id => 'window';

  @override
  Map<String, dynamic> toJson(WindowProperties data) => data.toJson();
}
