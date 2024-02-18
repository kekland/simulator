import 'package:flutter/material.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/state/simulator_state.dart';

class GesturesModuleState {
  const GesturesModuleState({
    required this.convertMouseToTouch,
    required this.enableZoomGesture,
  });

  factory GesturesModuleState.fromJson(Map<String, dynamic> json) {
    return GesturesModuleState(
      convertMouseToTouch: json['convertMouseToTouch'],
      enableZoomGesture: json['enableZoomGesture'],
    );
  }

  final bool convertMouseToTouch;
  final bool enableZoomGesture;

  GesturesModuleState copyWith({
    bool? convertMouseToTouch,
    bool? enableZoomGesture,
  }) {
    return GesturesModuleState(
      convertMouseToTouch: convertMouseToTouch ?? this.convertMouseToTouch,
      enableZoomGesture: enableZoomGesture ?? this.enableZoomGesture,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'convertMouseToTouch': convertMouseToTouch,
      'enableZoomGesture': enableZoomGesture,
    };
  }

  void _apply() {
    final binding = SimulatorWidgetsFlutterBinding.instance;
    binding.convertMouseToTouch = convertMouseToTouch;
    binding.zoomGestureEnabled = enableZoomGesture;
  }
}

class GesturesModule extends SimulatorModule<GesturesModuleState> {
  const GesturesModule();

  @override
  String get id => 'gestures';

  @override
  GesturesModuleState createInitialState(Map<String, dynamic>? json) {
    final GesturesModuleState state;

    if (json != null) {
      state = GesturesModuleState.fromJson(json);
    } else {
      state = const GesturesModuleState(
        convertMouseToTouch: false,
        enableZoomGesture: false,
      );
    }

    state._apply();
    return state;
  }

  @override
  Map<String, dynamic> toJson(GesturesModuleState data) => data.toJson();

  @override
  Widget buildPanel(
    BuildContext context,
    SimulatorState state,
    ValueChanged<GesturesModuleState> onChanged,
  ) {
    void _onChanged(GesturesModuleState data) {
      data._apply();
      onChanged(data);
    }

    final data = getDataFromState(state);

    return SectionCard(
      leading: const Icon(Icons.touch_app_rounded),
      title: const Text('Gestures'),
      child: SectionList(
        children: [
          CheckboxListTile(
            title: const Text('Convert mouse to touch events'),
            value: data.convertMouseToTouch,
            onChanged: (value) {
              _onChanged(data.copyWith(convertMouseToTouch: value));
            },
          ),
          CheckboxListTile(
            title: const Text('Enable zoom gesture'),
            subtitle: const Text('Press and hold Control to simulate pinch'),
            value: data.enableZoomGesture,
            onChanged: (value) {
              _onChanged(data.copyWith(enableZoomGesture: value));
            },
          ),
        ],
      ),
    );
  }
}
