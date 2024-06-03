import 'package:flutter/material.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/state/simulator_state.dart';
import 'package:window_manager/window_manager.dart';

class WindowProperties {
  const WindowProperties({required this.alwaysOnTop});

  factory WindowProperties.fromJson(Map<String, dynamic> json) {
    return WindowProperties(
      alwaysOnTop: json['alwaysOnTop'],
    );
  }

  final bool alwaysOnTop;

  WindowProperties copyWith({
    bool? alwaysOnTop,
  }) {
    return WindowProperties(
      alwaysOnTop: alwaysOnTop ?? this.alwaysOnTop,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alwaysOnTop': alwaysOnTop,
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

    return SectionCard(
      leading: const Icon(Icons.window_rounded),
      title: const Text('Window'),
      child: SectionList(
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
        ],
      ),
    );
  }

  @override
  WindowProperties createInitialState(Map<String, dynamic>? json) {
    if (json != null) {
      return WindowProperties.fromJson(json);
    }

    return const WindowProperties(alwaysOnTop: false);
  }

  @override
  String get id => 'window';

  @override
  Map<String, dynamic> toJson(WindowProperties data) => data.toJson();
}
