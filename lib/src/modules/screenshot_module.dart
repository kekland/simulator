import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/modules/device_module.dart';
import 'package:simulator/src/platform_channels/platform_channel_interceptors.dart';
import 'package:simulator/src/state/simulator_state.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum CaptureType {
  screen,
  withDeviceFrame,
}

class ScreenshotModuleState {
  const ScreenshotModuleState({required this.captureType});

  factory ScreenshotModuleState.fromJson(Map<String, dynamic> json) {
    return ScreenshotModuleState(
      captureType: CaptureType.values[json['captureType']],
    );
  }

  final CaptureType captureType;

  ScreenshotModuleState copyWith({CaptureType? captureType}) {
    return ScreenshotModuleState(
      captureType: captureType ?? this.captureType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'captureType': captureType.index,
    };
  }
}

class ScreenshotModule extends SimulatorModule<ScreenshotModuleState> {
  const ScreenshotModule();

  @override
  String get id => 'screenshot';

  @override
  ScreenshotModuleState createInitialState(json) {
    if (json != null) {
      return ScreenshotModuleState.fromJson(json);
    }

    return const ScreenshotModuleState(captureType: CaptureType.screen);
  }

  @override
  Map<String, dynamic> toJson(ScreenshotModuleState data) => data.toJson();

  @override
  Widget buildPanel(
    BuildContext context,
    SimulatorState state,
    ValueChanged<ScreenshotModuleState> onChanged,
  ) {
    final data = getDataFromState(state);

    return SectionCard(
      leading: const Icon(Icons.photo_camera_rounded),
      title: const Text('Screenshot'),
      builder: (context) =>  SectionList(
        automaticallyImplyDividers: false,
        children: [
          RadioListTile(
            onChanged: (v) => onChanged(data.copyWith(captureType: v)),
            value: CaptureType.screen,
            groupValue: data.captureType,
            title: const Text('Only screen'),
            subtitle: const Text('Ignores any overlays'),
          ),
          RadioListTile(
            onChanged: (v) => onChanged(data.copyWith(captureType: v)),
            value: CaptureType.withDeviceFrame,
            groupValue: data.captureType,
            title: const Text('With device frame'),
            subtitle: const Text('Includes the device frame'),
          ),
          const Divider(height: 0.0),
          ListTile(
            onTap: () {
              _captureAndSaveScreenshot(
                [
                  if (data.captureType == CaptureType.withDeviceFrame)
                    SimulatorWidgetsFlutterBinding
                        .instance.appWithDeviceFrameKey,
                  SimulatorWidgetsFlutterBinding.instance.appKey,
                ],
                pixelRatio: state
                        .maybeGet<DeviceModuleState>('device')
                        ?.device
                        ?.devicePixelRatio ??
                    1.0,
              );
            },
            leading: const Icon(Icons.photo_camera_rounded),
            title: const Text('Take screenshot'),
          ),
          const ListTile(
            onTap: null,
            enabled: false,
            leading: Icon(Icons.videocam_rounded),
            title: Text('Start recording'),
            subtitle: Text('Coming soon'),
          ),
          ListTile(
            onTap: () async {
              final dir = await _getScreenshotDirectory();
              await launchUrlString(dir.path);
            },
            leading: const Icon(Icons.folder_rounded),
            title: const Text('Open folder'),
          ),
        ],
      ),
    );
  }
}

Future<Directory> _getScreenshotDirectory() async {
  final directory = await getTemporaryDirectory();

  final appName = PlatformChannelInterceptors.system.label ?? 'unknown';
  final safeAppName = appName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');

  final appDirectory = Directory(
    '${directory.path}/flutter-simulator/$safeAppName',
  );

  if (!await appDirectory.exists()) {
    await appDirectory.create(recursive: true);
  }

  return appDirectory;
}

Future<void> _captureAndSaveScreenshot(
  List<GlobalKey> keys, {
  double pixelRatio = 1.0,
}) async {
  RenderRepaintBoundary? renderObject;

  for (final key in keys) {
    final currentContext = key.currentContext;

    if (currentContext != null) {
      renderObject = currentContext.findRenderObject() as RenderRepaintBoundary;
      break;
    }
  }

  if (renderObject == null) {
    throw Exception('No render object found');
  }

  final image = await renderObject.toImage(pixelRatio: pixelRatio);
  final png = await image.toByteData(format: ImageByteFormat.png);

  final directory = await _getScreenshotDirectory();

  final file = File(
    '${directory.path}/${DateTime.now().toIso8601String().replaceAll(':', '_')}.png',
  );

  await file.create();
  await file.writeAsBytes(png!.buffer.asUint8List());
}
