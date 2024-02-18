import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/platform_channels/platform_channel_interceptors.dart';

class DeviceWidget extends StatelessWidget {
  const DeviceWidget({
    super.key,
    required this.frameBuilder,
    required this.child,
    this.screenOverlays = const [],
  });

  final Widget Function(BuildContext context, Widget screen) frameBuilder;
  final List<Widget> screenOverlays;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screen = Stack(
      children: [
        child,
        Positioned.fill(
          child: MediaQuery.withNoTextScaling(
            child: Stack(
              children: screenOverlays,
            ),
          ),
        ),
      ],
    );

    return frameBuilder(context, screen);
  }
}

class DeviceSystemUiOverlayWidget extends StatefulWidget {
  const DeviceSystemUiOverlayWidget({super.key, required this.builder});

  final Widget Function(
    BuildContext context,
    SystemUiOverlayStyle style,
  ) builder;

  @override
  State<DeviceSystemUiOverlayWidget> createState() =>
      _DeviceSystemUiOverlayWidgetState();
}

class _DeviceSystemUiOverlayWidgetState
    extends State<DeviceSystemUiOverlayWidget> {
  late SystemUiOverlayStyle _style;

  @override
  void initState() {
    super.initState();

    _onStyleUpdated();
    PlatformChannelInterceptors.system.addListener(_onStyleUpdated);
  }

  @override
  void dispose() {
    PlatformChannelInterceptors.system.removeListener(_onStyleUpdated);
    super.dispose();
  }

  void _onStyleUpdated() {
    _style = PlatformChannelInterceptors.system.systemUiOverlayStyle ??
        SystemUiOverlayStyle.dark;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _style,
    );
  }
}

class DeviceScreenDependentWidget extends StatefulWidget {
  const DeviceScreenDependentWidget({
    super.key,
    required this.builder,
  });

  final Widget Function(
    BuildContext context,
    ui.Image image,
    ByteData byteData,
  ) builder;

  @override
  State<DeviceScreenDependentWidget> createState() =>
      _DeviceScreenDependentWidgetState();
}

class _DeviceScreenDependentWidgetState
    extends State<DeviceScreenDependentWidget> {
  ui.Image? image;
  ByteData? byteData;

  @override
  void initState() {
    super.initState();

    SimulatorWidgetsFlutterBinding.instance
        .addAppImageListener(_onAppImageUpdated);
  }

  @override
  void dispose() {
    SimulatorWidgetsFlutterBinding.instance
        .removeAppImageListener(_onAppImageUpdated);

    byteData = null;
    image?.dispose();
    image = null;

    super.dispose();
  }

  Future<void> _onAppImageUpdated(ui.Image image) async {
    this.image?.dispose();
    this.image = image.clone();

    byteData = await image.toByteData();

    if (mounted) {
      setState(() {});
    } else {
      byteData = null;
      this.image?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (byteData == null) {
      return const SizedBox.shrink();
    }

    return widget.builder(context, image!, byteData!);
  }
}
