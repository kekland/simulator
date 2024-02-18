import 'package:flutter/foundation.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/bindings/pipeline_owner.dart';
import 'dart:ui' as ui;

typedef AppImageListener = void Function(ui.Image image);

mixin AppImageExtractorBinding on BindingBase {
  @override
  void initInstances() {
    super.initInstances();

    Future.microtask(() {
      _initialize();
    });
  }

  final _appImageListeners = <AppImageListener>[];

  void addAppImageListener(AppImageListener listener) {
    _appImageListeners.add(listener);
  }

  void removeAppImageListener(AppImageListener listener) {
    _appImageListeners.remove(listener);
  }

  void _initialize() {
    final pipelineOwner = SimulatorWidgetsFlutterBinding
        .instance.rootPipelineOwner as SimulatorPipelineOwner;

    pipelineOwner.onAfterFlushPaint = _onAfterFlushPaint;
  }

  void _onAfterFlushPaint() {
    final appRepaintBoundary =
        SimulatorWidgetsFlutterBinding.instance.appRepaintBoundary;

    final image = appRepaintBoundary.toImageSync();

    for (final listener in _appImageListeners) {
      listener(image);
    }

    image.dispose();
  }
}
