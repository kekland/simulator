import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/modules/keyboard_module/android/android_keyboard_widget.dart';
import 'package:simulator/src/modules/keyboard_module/ios/ios_keyboard_widget.dart';
import 'package:simulator/src/platform_channels/platform_channel_interceptors.dart';
import 'package:simulator/src/state/simulator_state.dart';

enum KeyboardType {
  disabled,
  autoDetect,
  android,
  ios,
}

class KeyboardModuleState {
  const KeyboardModuleState({required this.keyboardType});

  factory KeyboardModuleState.fromJson(Map<String, dynamic> json) {
    return KeyboardModuleState(
      keyboardType: KeyboardType.values[json['keyboardType']],
    );
  }

  final KeyboardType keyboardType;

  KeyboardModuleState copyWith({KeyboardType? keyboardType}) {
    return KeyboardModuleState(
      keyboardType: keyboardType ?? this.keyboardType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keyboardType': keyboardType.index,
    };
  }
}

class KeyboardModule extends SimulatorModule<KeyboardModuleState> {
  const KeyboardModule();

  @override
  String get id => 'keyboard';

  @override
  KeyboardModuleState createInitialState(Map<String, dynamic>? json) {
    if (json != null) {
      return KeyboardModuleState.fromJson(json);
    }

    return const KeyboardModuleState(keyboardType: KeyboardType.autoDetect);
  }

  @override
  Map<String, dynamic> toJson(KeyboardModuleState data) => data.toJson();

  @override
  Widget buildPanel(
    BuildContext context,
    SimulatorState state,
    ValueChanged<KeyboardModuleState> onChanged,
  ) {
    final data = getDataFromState(state);

    return SectionCard(
      leading: const Icon(Icons.keyboard_rounded),
      title: const Text('Keyboard'),
      builder: (context) => SectionList(
        children: [
          RadioListTile<KeyboardType>(
            title: const Text('Disabled'),
            value: KeyboardType.disabled,
            groupValue: data.keyboardType,
            onChanged: (value) {
              onChanged(data.copyWith(keyboardType: value));
            },
          ),
          RadioListTile<KeyboardType>(
            title: const Text('Auto-detect'),
            value: KeyboardType.autoDetect,
            groupValue: data.keyboardType,
            onChanged: (value) {
              onChanged(data.copyWith(keyboardType: value));
            },
          ),
          RadioListTile<KeyboardType>(
            title: const Text('Android'),
            value: KeyboardType.android,
            groupValue: data.keyboardType,
            onChanged: (value) {
              onChanged(data.copyWith(keyboardType: value));
            },
          ),
          RadioListTile<KeyboardType>(
            title: const Text('iOS'),
            value: KeyboardType.ios,
            groupValue: data.keyboardType,
            onChanged: (value) {
              onChanged(data.copyWith(keyboardType: value));
            },
          ),
        ],
      ),
    );
  }

  @override
  int get wrapAppPriority => 12;

  @override
  Widget wrapApp(
    BuildContext context,
    SimulatorState state,
    Widget child,
  ) {
    final data = getDataFromState(state);

    if (data.keyboardType == KeyboardType.disabled) {
      return child;
    }

    return ValueListenableBuilder(
      valueListenable:
          PlatformChannelInterceptors.textInput.keyboardVisibilityNotifier,
      builder: (context, isVisible, child) {
        final bool isAndroid;

        if (data.keyboardType == KeyboardType.android) {
          isAndroid = true;
        } else if (data.keyboardType == KeyboardType.ios) {
          isAndroid = false;
        } else {
          isAndroid = defaultTargetPlatform == TargetPlatform.android;
        }

        if (isAndroid) {
          return AndroidKeyboardWidget(isVisible: isVisible, child: child!);
        }

        return IOSKeyboardWidget(isVisible: isVisible, child: child!);
      },
      child: child,
    );
  }
}
