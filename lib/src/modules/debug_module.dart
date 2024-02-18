import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/state/simulator_state.dart';

class DebugModuleProperties {
  const DebugModuleProperties({
    this.timeDilation = 1.0,
    this.isPointerAreaHighlightEnabled = false,
    this.isVisualizeViewPaddingsEnabled = false,
    this.paintPointersEnabled = false,
    this.invertOversizedImages = false,
    this.disableShadows = false,
    this.repaintRainbowEnabled = false,
    this.paintSizeEnabled = false,
    this.paintLayerBordersEnabled = false,
    this.paintBaselinesEnabled = false,
  });

  factory DebugModuleProperties.fromJson(Map<String, dynamic> json) {
    return DebugModuleProperties(
      timeDilation: json['timeDilation'] ?? 1.0,
      isPointerAreaHighlightEnabled:
          json['isPointerAreaHighlightEnabled'] ?? false,
      isVisualizeViewPaddingsEnabled:
          json['isVisualizeViewPaddingsEnabled'] ?? false,
      paintPointersEnabled: json['paintPointersEnabled'] ?? false,
      invertOversizedImages: json['invertOversizedImages'] ?? false,
      disableShadows: json['disableShadows'] ?? false,
      repaintRainbowEnabled: json['repaintRainbowEnabled'] ?? false,
      paintSizeEnabled: json['paintSizeEnabled'] ?? false,
      paintLayerBordersEnabled: json['paintLayerBordersEnabled'] ?? false,
      paintBaselinesEnabled: json['paintBaselinesEnabled'] ?? false,
    );
  }

  final bool isPointerAreaHighlightEnabled;
  final bool isVisualizeViewPaddingsEnabled;
  final double timeDilation;
  final bool invertOversizedImages;
  final bool disableShadows;
  final bool repaintRainbowEnabled;
  final bool paintSizeEnabled;
  final bool paintPointersEnabled;
  final bool paintLayerBordersEnabled;
  final bool paintBaselinesEnabled;

  DebugModuleProperties copyWith({
    bool? isPointerAreaHighlightEnabled,
    bool? isVisualizeViewPaddingsEnabled,
    double? timeDilation,
    bool? invertOversizedImages,
    bool? disableShadows,
    bool? repaintRainbowEnabled,
    bool? paintSizeEnabled,
    bool? paintPointersEnabled,
    bool? paintLayerBordersEnabled,
    bool? paintBaselinesEnabled,
  }) {
    return DebugModuleProperties(
      isPointerAreaHighlightEnabled:
          isPointerAreaHighlightEnabled ?? this.isPointerAreaHighlightEnabled,
      isVisualizeViewPaddingsEnabled:
          isVisualizeViewPaddingsEnabled ?? this.isVisualizeViewPaddingsEnabled,
      timeDilation: timeDilation ?? this.timeDilation,
      invertOversizedImages:
          invertOversizedImages ?? this.invertOversizedImages,
      disableShadows: disableShadows ?? this.disableShadows,
      repaintRainbowEnabled:
          repaintRainbowEnabled ?? this.repaintRainbowEnabled,
      paintSizeEnabled: paintSizeEnabled ?? this.paintSizeEnabled,
      paintPointersEnabled: paintPointersEnabled ?? this.paintPointersEnabled,
      paintLayerBordersEnabled:
          paintLayerBordersEnabled ?? this.paintLayerBordersEnabled,
      paintBaselinesEnabled:
          paintBaselinesEnabled ?? this.paintBaselinesEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isPointerAreaHighlightEnabled': isPointerAreaHighlightEnabled,
      'isVisualizeViewPaddingsEnabled': isVisualizeViewPaddingsEnabled,
      'timeDilation': timeDilation,
      'invertOversizedImages': invertOversizedImages,
      'disableShadows': disableShadows,
      'repaintRainbowEnabled': repaintRainbowEnabled,
      'paintSizeEnabled': paintSizeEnabled,
      'paintPointersEnabled': paintPointersEnabled,
      'paintLayerBordersEnabled': paintLayerBordersEnabled,
      'paintBaselinesEnabled': paintBaselinesEnabled,
    };
  }
}

class DebugModule extends SimulatorModule<DebugModuleProperties> {
  const DebugModule();

  @override
  String get id => 'debug';

  @override
  DebugModuleProperties createInitialState(json) => json != null
      ? DebugModuleProperties.fromJson(json)
      : const DebugModuleProperties();

  @override
  Map<String, dynamic> toJson(DebugModuleProperties data) => data.toJson();

  @override
  Widget buildPanel(
    BuildContext context,
    SimulatorState state,
    ValueChanged<DebugModuleProperties> onChanged,
  ) {
    final data = getDataFromState(state);

    void _onChanged(DebugModuleProperties value) {
      SimulatorWidgetsFlutterBinding.instance.forceRebuildApp();
      onChanged(value);
    }

    return SectionCard(
      leading: const Icon(Icons.bug_report_rounded),
      title: const Text('Debug'),
      child: SectionList(
        children: <Widget>[
          CheckboxListTile(
            title: const Text('Pointer area highlight'),
            value: data.isPointerAreaHighlightEnabled,
            onChanged: (v) {
              _onChanged(
                data.copyWith(isPointerAreaHighlightEnabled: v),
              );
            },
          ),
          CheckboxListTile(
            title: const Text('Visualize view paddings'),
            value: data.isVisualizeViewPaddingsEnabled,
            onChanged: (v) {
              _onChanged(
                data.copyWith(isVisualizeViewPaddingsEnabled: v),
              );
            },
          ),
          SliderTile(
            title: 'Time dilation',
            subtitle: 'timeDilation = ${data.timeDilation.toStringAsFixed(2)}',
            value: data.timeDilation,
            onChanged: (v) {
              timeDilation = v;

              onChanged(
                data.copyWith(timeDilation: v),
              );
            },
            min: 0.5,
            max: 8.0,
          ),
          CheckboxListTile(
            title: const Text('Invert oversized images'),
            subtitle: const Text('invertOversizedImages'),
            value: data.invertOversizedImages,
            onChanged: (v) {
              debugInvertOversizedImages = v!;

              _onChanged(
                data.copyWith(invertOversizedImages: v),
              );
            },
          ),
          CheckboxListTile(
            title: const Text('Disable shadows'),
            subtitle: const Text('disableShadows'),
            value: data.disableShadows,
            onChanged: (v) {
              debugDisableShadows = v!;

              _onChanged(
                data.copyWith(disableShadows: v),
              );
            },
          ),
          CheckboxListTile(
            title: const Text('Repaint rainbow'),
            subtitle: const Text('repaintRainbowEnabled'),
            value: data.repaintRainbowEnabled,
            onChanged: (v) {
              debugRepaintRainbowEnabled = v!;

              _onChanged(
                data.copyWith(repaintRainbowEnabled: v),
              );
            },
          ),
          CheckboxListTile(
            title: const Text('Paint size'),
            subtitle: const Text('paintSizeEnabled'),
            value: data.paintSizeEnabled,
            onChanged: (v) {
              debugPaintSizeEnabled = v!;

              _onChanged(
                data.copyWith(paintSizeEnabled: v),
              );
            },
          ),
          CheckboxListTile(
            title: const Text('Paint pointers'),
            subtitle: const Text('paintPointersEnabled'),
            value: data.paintPointersEnabled,
            onChanged: (v) {
              debugPaintPointersEnabled = v!;

              _onChanged(
                data.copyWith(paintPointersEnabled: v),
              );
            },
          ),
          CheckboxListTile(
            title: const Text('Paint layer borders'),
            subtitle: const Text('paintLayerBordersEnabled'),
            value: data.paintLayerBordersEnabled,
            onChanged: (v) {
              debugPaintLayerBordersEnabled = v!;

              _onChanged(
                data.copyWith(paintLayerBordersEnabled: v),
              );
            },
          ),
          CheckboxListTile(
            title: const Text('Paint baselines'),
            subtitle: const Text('paintBaselinesEnabled'),
            value: data.paintBaselinesEnabled,
            onChanged: (v) {
              debugPaintBaselinesEnabled = v!;

              _onChanged(
                data.copyWith(paintBaselinesEnabled: v),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget? buildOverlay(
    BuildContext context,
    SimulatorState state,
  ) {
    final data = getDataFromState(state);

    if (!data.isPointerAreaHighlightEnabled) return null;

    return SimulatorWidgetsFlutterBinding.instance
        .buildPointerListenerOverlay();
  }

  @override
  int get wrapAppPriority => 1000;

  @override
  Widget wrapApp(
    BuildContext context,
    SimulatorState state,
    Widget child,
  ) {
    final data = getDataFromState(state);

    Widget _child = child;

    if (data.isVisualizeViewPaddingsEnabled) {
      final mediaQuery = MediaQuery.of(context);

      return _ViewPaddingsVisualizer(
        viewPadding: mediaQuery.viewPadding,
        viewInsets: mediaQuery.viewInsets,
        child: _child,
      );
    }

    return _child;
  }
}

class _ViewPaddingsVisualizer extends StatelessWidget {
  const _ViewPaddingsVisualizer({
    required this.viewPadding,
    required this.viewInsets,
    required this.child,
  });

  final EdgeInsets viewPadding;
  final EdgeInsets viewInsets;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        Positioned(
          left: 0.0,
          top: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: IgnorePointer(
            child: CustomPaint(
              painter: _EdgeInsetsPainter(
                edgeInsets: viewPadding,
                color: Colors.orange.withOpacity(0.5),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0.0,
          top: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: IgnorePointer(
            child: CustomPaint(
              painter: _EdgeInsetsPainter(
                edgeInsets: viewInsets,
                color: Colors.blue.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EdgeInsetsPainter extends CustomPainter {
  _EdgeInsetsPainter({
    required this.edgeInsets,
    required this.color,
  });

  final EdgeInsets edgeInsets;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw top
    canvas.drawRect(
      Rect.fromLTWH(
        0.0,
        0.0,
        size.width,
        edgeInsets.top,
      ),
      paint,
    );

    // Draw left
    canvas.drawRect(
      Rect.fromLTWH(
        0.0,
        edgeInsets.top,
        edgeInsets.left,
        size.height - edgeInsets.bottom - edgeInsets.top,
      ),
      paint,
    );

    // Draw right
    canvas.drawRect(
      Rect.fromLTWH(
        size.width - edgeInsets.right,
        edgeInsets.top,
        edgeInsets.right,
        size.height - edgeInsets.bottom - edgeInsets.top,
      ),
      paint,
    );

    // Draw bottom
    canvas.drawRect(
      Rect.fromLTWH(
        0.0,
        size.height - edgeInsets.bottom,
        size.width,
        edgeInsets.bottom,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
