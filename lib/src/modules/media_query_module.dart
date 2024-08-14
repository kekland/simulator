import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/modules/device_module.dart';
import 'package:simulator/src/state/simulator_state.dart';
import 'package:simulator/src/utils/compute_padding.dart';
import 'package:simulator/src/utils/utils.dart';

class SimulatorMediaQueryData {
  SimulatorMediaQueryData({
    this.platformBrightness = ui.Brightness.light,
    this.textScaler = TextScaler.noScaling,
    this.viewInsets = EdgeInsets.zero,
    this.systemGestureInsets = EdgeInsets.zero,
    this.viewPadding = EdgeInsets.zero,
    this.alwaysUse24HourFormat = false,
    this.accessibleNavigation = false,
    this.invertColors = false,
    this.highContrast = false,
    this.onOffSwitchLabels = false,
    this.disableAnimations = false,
    this.boldText = false,
    this.navigationMode = NavigationMode.traditional,
    this.gestureSettings = const DeviceGestureSettings(touchSlop: kTouchSlop),
    this.displayFeatures = const <ui.DisplayFeature>[],
  });

  factory SimulatorMediaQueryData.fromJson(Map<String, dynamic> json) {
    return SimulatorMediaQueryData(
      platformBrightness: ui.Brightness.values[json['platformBrightness']],
      textScaler: TextScaler.linear(json['textScaler']),
      viewInsets: EdgeInsets.fromLTRB(
        json['viewInsets']['left'],
        json['viewInsets']['top'],
        json['viewInsets']['right'],
        json['viewInsets']['bottom'],
      ),
      systemGestureInsets: EdgeInsets.fromLTRB(
        json['systemGestureInsets']['left'],
        json['systemGestureInsets']['top'],
        json['systemGestureInsets']['right'],
        json['systemGestureInsets']['bottom'],
      ),
      viewPadding: EdgeInsets.fromLTRB(
        json['viewPadding']['left'],
        json['viewPadding']['top'],
        json['viewPadding']['right'],
        json['viewPadding']['bottom'],
      ),
      alwaysUse24HourFormat: json['alwaysUse24HourFormat'],
      accessibleNavigation: json['accessibleNavigation'],
      invertColors: json['invertColors'],
      highContrast: json['highContrast'],
      onOffSwitchLabels: json['onOffSwitchLabels'],
      disableAnimations: json['disableAnimations'],
      boldText: json['boldText'],
      navigationMode: NavigationMode.values[json['navigationMode']],
      // gestureSettings: DeviceGestureSettings.fromJson(json['gestureSettings']),
      // displayFeatures: (json['displayFeatures'] as List)
      //     .map((feature) => ui.DisplayFeature.fromJson(feature))
      //     .toList(),
    );
  }

  final ui.Brightness platformBrightness;
  final TextScaler textScaler;

  final EdgeInsets viewInsets;
  final EdgeInsets viewPadding;

  final EdgeInsets systemGestureInsets;
  final bool alwaysUse24HourFormat;
  final bool accessibleNavigation;
  final bool invertColors;
  final bool highContrast;
  final bool onOffSwitchLabels;
  final bool disableAnimations;
  final bool boldText;
  final NavigationMode navigationMode;
  final DeviceGestureSettings gestureSettings;
  final List<ui.DisplayFeature> displayFeatures;

  EdgeInsets get padding => computePadding(
        viewInsets: viewInsets,
        viewPadding: viewPadding,
      );

  MediaQueryData get mediaQueryData => MediaQueryData(
        textScaler: textScaler,
        platformBrightness: platformBrightness,
        padding: padding,
        viewInsets: viewInsets,
        systemGestureInsets: systemGestureInsets,
        viewPadding: viewPadding,
        alwaysUse24HourFormat: alwaysUse24HourFormat,
        accessibleNavigation: accessibleNavigation,
        invertColors: invertColors,
        highContrast: highContrast,
        disableAnimations: disableAnimations,
        boldText: boldText,
        navigationMode: navigationMode,
        gestureSettings: gestureSettings,
        displayFeatures: displayFeatures,
      );

  SimulatorMediaQueryData copyWith({
    TextScaler? textScaler,
    ui.Brightness? platformBrightness,
    EdgeInsets? viewInsets,
    EdgeInsets? viewPadding,
    EdgeInsets? systemGestureInsets,
    bool? alwaysUse24HourFormat,
    bool? accessibleNavigation,
    bool? invertColors,
    bool? highContrast,
    bool? onOffSwitchLabels,
    bool? disableAnimations,
    bool? boldText,
    NavigationMode? navigationMode,
    DeviceGestureSettings? gestureSettings,
    List<ui.DisplayFeature>? displayFeatures,
  }) {
    return SimulatorMediaQueryData(
      textScaler: textScaler ?? this.textScaler,
      platformBrightness: platformBrightness ?? this.platformBrightness,
      viewInsets: viewInsets ?? this.viewInsets,
      viewPadding: viewPadding ?? this.viewPadding,
      systemGestureInsets: systemGestureInsets ?? this.systemGestureInsets,
      alwaysUse24HourFormat:
          alwaysUse24HourFormat ?? this.alwaysUse24HourFormat,
      accessibleNavigation: accessibleNavigation ?? this.accessibleNavigation,
      invertColors: invertColors ?? this.invertColors,
      highContrast: highContrast ?? this.highContrast,
      onOffSwitchLabels: onOffSwitchLabels ?? this.onOffSwitchLabels,
      disableAnimations: disableAnimations ?? this.disableAnimations,
      boldText: boldText ?? this.boldText,
      navigationMode: navigationMode ?? this.navigationMode,
      gestureSettings: gestureSettings ?? this.gestureSettings,
      displayFeatures: displayFeatures ?? this.displayFeatures,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platformBrightness': platformBrightness.index,
      'textScaler': textScaler.scale(1.0),
      'viewInsets': {
        'left': viewInsets.left,
        'top': viewInsets.top,
        'right': viewInsets.right,
        'bottom': viewInsets.bottom,
      },
      'viewPadding': {
        'left': viewPadding.left,
        'top': viewPadding.top,
        'right': viewPadding.right,
        'bottom': viewPadding.bottom,
      },
      'systemGestureInsets': {
        'left': systemGestureInsets.left,
        'top': systemGestureInsets.top,
        'right': systemGestureInsets.right,
        'bottom': systemGestureInsets.bottom,
      },
      'alwaysUse24HourFormat': alwaysUse24HourFormat,
      'accessibleNavigation': accessibleNavigation,
      'invertColors': invertColors,
      'highContrast': highContrast,
      'onOffSwitchLabels': onOffSwitchLabels,
      'disableAnimations': disableAnimations,
      'boldText': boldText,
      'navigationMode': navigationMode.index,
      // 'gestureSettings': gestureSettings.toJson(),
      // 'displayFeatures': displayFeatures.map((feature) => feature.toJson()).toList(),
    };
  }
}

class MediaQueryModule extends SimulatorModule<SimulatorMediaQueryData> {
  const MediaQueryModule();

  @override
  String get id => 'media_query';

  @override
  SimulatorMediaQueryData createInitialState(json) {
    if (json != null) {
      return SimulatorMediaQueryData.fromJson(json);
    }

    return SimulatorMediaQueryData();
  }

  @override
  Map<String, dynamic> toJson(SimulatorMediaQueryData data) {
    return data.toJson();
  }

  @override
  Widget buildPanel(
    BuildContext context,
    SimulatorState state,
    ValueChanged<SimulatorMediaQueryData> onChanged,
  ) {
    final data = getDataFromState(state);
    final deviceData = state.maybeGet<DeviceModuleState>('device');

    return MediaQuerySection(
      value: data,
      onChanged: onChanged,
      isViewPaddingOverridden: deviceData?.device != null,
    );
  }

  @override
  Widget wrapApp(
    BuildContext context,
    SimulatorState state,
    Widget child,
  ) {
    final data = getDataFromState(state);

    return MediaQuery(
      data: data.mediaQueryData,
      child: child,
    );
  }
}

class MediaQuerySection extends StatelessWidget {
  const MediaQuerySection({
    super.key,
    required this.value,
    required this.onChanged,
    required this.isViewPaddingOverridden,
  });

  final SimulatorMediaQueryData value;
  final ValueChanged<SimulatorMediaQueryData> onChanged;
  final bool isViewPaddingOverridden;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      leading: const Icon(Icons.monitor_rounded),
      title: const Text('MediaQuery'),
      builder: (context) =>  SectionList(
        children: [
          ListTile(
            onTap: () {
              onChanged(
                value.copyWith(
                  platformBrightness: value.platformBrightness.inverse,
                ),
              );
            },
            title: const Text('Brightness'),
            subtitle: const Text('.platformBrightness'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            trailing: Icon(
              value.platformBrightness == Brightness.light
                  ? Icons.wb_sunny_rounded
                  : Icons.nightlight_round,
            ),
          ),
          SliderTile(
            title: 'Text scaler',
            subtitle:
                'linear (${value.textScaler.scale(1.0).toStringAsFixed(3)})',
            value: value.textScaler.scale(1.0),
            onChanged: (v) {
              onChanged(
                value.copyWith(textScaler: TextScaler.linear(v)),
              );
            },
            min: 0.5,
            max: 5.0,
          ),
          EdgeInsetsTile(
            title: 'View padding',
            subtitle: '.viewPadding',
            value: value.viewPadding,
            onChanged: isViewPaddingOverridden
                ? null
                : (v) {
                    onChanged(
                      value.copyWith(
                        viewPadding: v,
                      ),
                    );
                  },
          ),
          EdgeInsetsTile(
            title: 'View insets',
            subtitle: '.viewInsets',
            value: value.viewInsets,
            onChanged: isViewPaddingOverridden
                ? null
                : (v) {
                    onChanged(
                      value.copyWith(
                        viewInsets: v,
                      ),
                    );
                  },
          ),
          CheckboxListTile(
            title: const Text('24-hr format'),
            subtitle: const Text('.alwaysUse24HourFormat'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            value: value.alwaysUse24HourFormat,
            onChanged: (v) {
              onChanged(
                value.copyWith(
                  alwaysUse24HourFormat: v,
                ),
              );
            },
          ),
          CheckboxListTile(
            title: const Text('Accessible navigation'),
            subtitle: const Text('.accessibleNavigation'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            value: value.accessibleNavigation,
            onChanged: (v) {
              onChanged(
                value.copyWith(
                  accessibleNavigation: v,
                ),
              );
            },
          ),
          CheckboxListTile(
            title: const Text('Invert colors'),
            subtitle: const Text('.invertColors'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            value: value.invertColors,
            onChanged: (v) {
              onChanged(
                value.copyWith(
                  invertColors: v,
                ),
              );
            },
          ),
          CheckboxListTile(
            title: const Text('High contrast'),
            subtitle: const Text('.highContrast'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            value: value.highContrast,
            onChanged: (v) {
              onChanged(
                value.copyWith(
                  highContrast: v,
                ),
              );
            },
          ),
          CheckboxListTile(
            title: const Text('Disable animations'),
            subtitle: const Text('.disableAnimations'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            value: value.disableAnimations,
            onChanged: (v) {
              onChanged(
                value.copyWith(
                  disableAnimations: v,
                ),
              );
            },
          ),
          CheckboxListTile(
            title: const Text('Bold text'),
            subtitle: const Text('.boldText'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            value: value.boldText,
            onChanged: (v) {
              onChanged(
                value.copyWith(
                  boldText: v,
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Navigation mode'),
            subtitle: const Text('.navigationMode'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            trailing: DropdownButton<NavigationMode>(
              value: value.navigationMode,
              onChanged: (v) {
                onChanged(
                  value.copyWith(
                    navigationMode: v!,
                  ),
                );
              },
              items: NavigationMode.values
                  .map(
                    (mode) => DropdownMenuItem(
                      value: mode,
                      child: Text(mode.toString().split('.').last),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
