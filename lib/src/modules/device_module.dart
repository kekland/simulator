import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/modules/device_module/device_properties.dart';
import 'package:simulator/src/modules/device_module/devices/devices.dart';
import 'package:simulator/src/state/simulator_state.dart';
import 'package:simulator/src/utils/compute_padding.dart';
import 'package:simulator/src/utils/device_orientation.dart';

class DeviceModuleState {
  const DeviceModuleState({
    required this.device,
    required this.orientation,
  });

  factory DeviceModuleState.fromJson(
    Map<String, dynamic> json, {
    required List<DeviceProperties> devices,
  }) {
    final orientation = json['orientation'] != null
        ? DeviceOrientation.values[json['orientation']]
        : null;

    if (json['id'] != null) {
      for (final device in devices) {
        if (device.id == json['id']) {
          return DeviceModuleState(
            device: device,
            orientation: orientation ?? DeviceOrientation.portraitUp,
          );
        }
      }
    }

    return DeviceModuleState(
      device: null,
      orientation: orientation ?? DeviceOrientation.portraitUp,
    );
  }

  final DeviceProperties? device;
  final DeviceOrientation orientation;

  DeviceModuleState copyWith({
    DeviceProperties? device,
    DeviceOrientation? orientation,
  }) {
    return DeviceModuleState(
      device: device ?? this.device,
      orientation: orientation ?? this.orientation,
    );
  }

  DeviceModuleState copyWithDevice(DeviceProperties? device) {
    return DeviceModuleState(
      device: device,
      orientation: orientation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': device?.id,
      'orientation': orientation.index,
    };
  }
}

class DeviceModule extends SimulatorModule<DeviceModuleState> {
  const DeviceModule({
    this.devices = defaultDevices,
  });

  final List<DeviceProperties> devices;

  @override
  DeviceModuleState createInitialState(json) {
    if (json != null) {
      final result = DeviceModuleState.fromJson(json, devices: devices);
      debugDefaultTargetPlatformOverride = result.device?.platform;

      return result;
    }

    return const DeviceModuleState(
      device: null,
      orientation: DeviceOrientation.portraitUp,
    );
  }

  @override
  Map<String, dynamic> toJson(DeviceModuleState data) => data.toJson();

  @override
  String get id => 'device';

  @override
  Widget buildPanel(
    BuildContext context,
    SimulatorState state,
    ValueChanged<DeviceModuleState> onChanged,
  ) {
    final data = getDataFromState(state);

    void _onDeviceChanged(DeviceProperties? value) {
      debugDefaultTargetPlatformOverride = value?.platform;
      SimulatorWidgetsFlutterBinding.instance.forceRebuildApp();

      onChanged(data.copyWithDevice(value));
    }

    // Group devices by manufacturers
    final groupedDevices = <String, List<DeviceProperties>>{};

    for (final device in devices) {
      final manufacturer = device.manufacturer;

      if (!groupedDevices.containsKey(manufacturer)) {
        groupedDevices[manufacturer] = [];
      }

      groupedDevices[manufacturer]!.add(device);
    }

    return SectionCard(
      leading: const Icon(Icons.phone_android_rounded),
      title: const Text('Device'),
      child: SectionList(
        automaticallyImplyDividers: false,
        children: [
          _DeviceOrientationPicker(
            value: data.orientation,
            onChanged: (value) {
              onChanged(data.copyWith(orientation: value));
            },
          ),
          const Divider(height: 0.0),
          RadioListTile<DeviceProperties?>(
            value: null,
            groupValue: data.device,
            onChanged: _onDeviceChanged,
            title: const Text('None'),
            subtitle: const Text('Frameless, resizes to fit'),
          ),
          for (final manufacturer in groupedDevices.keys)
            ExpansionTile(
              title: Text(manufacturer),
              children: [
                for (final device in groupedDevices[manufacturer]!)
                  RadioListTile<DeviceProperties?>(
                    value: device,
                    groupValue: data.device,
                    onChanged: _onDeviceChanged,
                    title: Text(device.name),
                    subtitle: Text(
                        '${device.screenSize.width} × ${device.screenSize.height}'),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  int get wrapAppPriority => 10;

  @override
  Widget wrapApp(
    BuildContext context,
    SimulatorState state,
    Widget child,
  ) {
    final data = getDataFromState(state);

    Widget _child = child;

    final device = data.device;
    final orientation = data.orientation;

    if (device == null) {
      return _child;
    }

    final screenOrientation = device.getScreenOrientation(orientation);

    final viewPadding = device.viewPaddings[screenOrientation]!;
    const viewInsets = EdgeInsets.zero;

    _child = DeviceViewPaddings(
      viewPadding: viewPadding,
      viewInsets: viewInsets,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          viewPadding: viewPadding,
          viewInsets: viewInsets,
          padding: computePadding(
            viewInsets: viewInsets,
            viewPadding: viewPadding,
          ),
        ),
        child: RotatedBox(
          quarterTurns: -screenOrientation.quarterTurns,
          child: SizedBox.fromSize(
            size: device.getScreenSize(screenOrientation),
            child: RepaintBoundary(
              key: SimulatorWidgetsFlutterBinding.instance.deviceScreenKey,
              child: _child,
            ),
          ),
        ),
      ),
    );

    if (device.frameBuilder != null) {
      _child = RotatedBox(
        quarterTurns: orientation.quarterTurns,
        child: device.frameBuilder!(
          context,
          _child,
        ),
      );
    }

    return FittedBox(
      alignment: Alignment.topLeft,
      fit: BoxFit.contain,
      child: RepaintBoundary(
        key: SimulatorWidgetsFlutterBinding.instance.appWithDeviceFrameKey,
        child: _child,
      ),
    );
  }
}

class DeviceViewPaddings extends InheritedWidget {
  const DeviceViewPaddings({
    Key? key,
    required this.viewPadding,
    required this.viewInsets,
    required Widget child,
  }) : super(key: key, child: child);

  final EdgeInsets viewPadding;
  final EdgeInsets viewInsets;

  EdgeInsets get padding => computePadding(
        viewPadding: viewPadding,
        viewInsets: viewInsets,
      );

  static DeviceViewPaddings? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DeviceViewPaddings>();
  }

  @override
  bool updateShouldNotify(DeviceViewPaddings oldWidget) {
    return viewPadding != oldWidget.viewPadding ||
        viewInsets != oldWidget.viewInsets;
  }
}

class _DeviceOrientationPicker extends StatelessWidget {
  const _DeviceOrientationPicker({
    required this.value,
    required this.onChanged,
  });

  final DeviceOrientation value;
  final ValueChanged<DeviceOrientation> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          title: Text('Orientation'),
          subtitle: Text('Work in progress'),
        ),
        Material(
          type: MaterialType.transparency,
          child: Row(
            children: [
              Expanded(
                child: _OrientationButton(
                  selectedValue: value,
                  value: DeviceOrientation.portraitUp,
                  onTap: () => onChanged(DeviceOrientation.portraitUp),
                ),
              ),
              Expanded(
                child: _OrientationButton(
                  selectedValue: value,
                  value: DeviceOrientation.landscapeLeft,
                  onTap: () => onChanged(DeviceOrientation.landscapeLeft),
                ),
              ),
              Expanded(
                child: _OrientationButton(
                  selectedValue: value,
                  value: DeviceOrientation.portraitDown,
                  onTap: () => onChanged(DeviceOrientation.portraitDown),
                ),
              ),
              Expanded(
                child: _OrientationButton(
                  selectedValue: value,
                  value: DeviceOrientation.landscapeRight,
                  onTap: () => onChanged(DeviceOrientation.landscapeRight),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrientationButton extends StatelessWidget {
  const _OrientationButton({
    required this.value,
    required this.selectedValue,
    required this.onTap,
  });

  final DeviceOrientation value;
  final DeviceOrientation selectedValue;
  final VoidCallback onTap;

  String get _name {
    switch (value) {
      case DeviceOrientation.portraitUp:
        return 'up';
      case DeviceOrientation.landscapeLeft:
        return 'left';
      case DeviceOrientation.portraitDown:
        return 'down';
      case DeviceOrientation.landscapeRight:
        return 'right';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;
    final foregroundColor =
        isSelected ? Theme.of(context).colorScheme.primary : null;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 64.0,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                value == DeviceOrientation.portraitUp ||
                        value == DeviceOrientation.portraitDown
                    ? Icons.stay_primary_portrait_rounded
                    : Icons.stay_primary_landscape_rounded,
                color: foregroundColor,
              ),
              Text(
                _name,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: foregroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
