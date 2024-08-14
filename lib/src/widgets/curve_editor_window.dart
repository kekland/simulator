import 'package:flutter/material.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';
import 'package:simulator/src/widgets/cubic_editor_window.dart';
import 'package:simulator/src/widgets/curve_graph_widget.dart';
import 'package:simulator/src/widgets/windows/window_root_navigator.dart';

Future<Curve?> showCurveEditorWindow(
  BuildContext context, {
  ValueChanged<Curve>? onCurveChanged,
  Curve? initialCurve,
}) async {
  return windowRootNavigatorStateKey.currentState!.pushWindow(
    title: const Text('Edit curve'),
    icon: const Icon(Icons.show_chart_rounded),
    (context) => CurveEditorWindow(
      initialCurve: initialCurve,
      onCurveChanged: onCurveChanged,
    ),
  );
}

class CurveEditorWindow extends StatefulWidget {
  const CurveEditorWindow({
    super.key,
    this.initialCurve,
    this.onCurveChanged,
  });

  final ValueChanged<Curve>? onCurveChanged;
  final Curve? initialCurve;

  @override
  State<CurveEditorWindow> createState() => _CurveEditorWindowState();
}

class _CurveEditorWindowState extends State<CurveEditorWindow> {
  late Curve? _curve = widget.initialCurve;

  double get _intervalBegin =>
      _curve is Interval ? (_curve as Interval).begin : 0.0;

  double get _intervalEnd =>
      _curve is Interval ? (_curve as Interval).end : 1.0;

  Curve? get _internalCurve =>
      _curve is Interval ? (_curve as Interval).curve : _curve;

  void _setNewCurve({
    double? intervalBegin,
    double? intervalEnd,
    Curve? curve,
  }) {
    final _intervalBegin = intervalBegin ?? this._intervalBegin;
    final _intervalEnd = intervalEnd ?? this._intervalEnd;
    final newCurve = curve ?? _internalCurve;

    if (_intervalBegin == 0.0 && _intervalEnd == 1.0) {
      _curve = newCurve;
    } else {
      _curve = Interval(
        _intervalBegin,
        _intervalEnd,
        curve: newCurve ?? Curves.linear,
      );
    }

    widget.onCurveChanged?.call(_curve!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Cubic;
    return Column(
      children: [
        const ListTile(
          leading: Icon(Icons.compare_arrows_rounded),
          title: Text('Interval options'),
        ),
        SliderTile(
          onChanged: (v) => _setNewCurve(intervalBegin: v),
          title: 'Begin',
          subtitle: 'Curve\'s start point',
          value: _intervalBegin,
          min: 0.0,
          max: 1.0,
          resetValue: 0.0,
        ),
        SliderTile(
          onChanged: (v) => _setNewCurve(intervalEnd: v),
          title: 'End',
          subtitle: 'Curve\'s end point',
          value: _intervalEnd,
          min: 0.0,
          max: 1.0,
          resetValue: 1.0,
        ),
        const Divider(),
        ListTile(
          onTap: () {
            showCubicEditorWindow(
              context,
              initialCurve: _internalCurve,
              onCurveChanged: (v) => _setNewCurve(curve: v),
            );
          },
          leading: const Icon(Icons.edit_rounded),
          trailing: const Icon(Icons.chevron_right_rounded),
          title: const Text('Edit cubic curve'),
        ),
        for (final entry in defaultCurves.entries)
          RadioListTile(
            onChanged: (value) => _setNewCurve(curve: value),
            value: entry.value,
            groupValue: _internalCurve,
            title: Text(entry.key),
            subtitle: Text(entry.value.toString()),
            secondary: CurvePreviewGraphWidget(
              size: 48.0,
              transform: entry.value.transform,
            ),
          ),
      ],
    );
  }
}

const defaultCurves = {
  'Curves.linear': Curves.linear,
  'Curves.decelerate': Curves.decelerate,
  'Curves.fastLinearToSlowEaseIn': Curves.fastLinearToSlowEaseIn,
  'Curves.fastEaseInToSlowEaseOut': Curves.fastEaseInToSlowEaseOut,
  'Curves.ease': Curves.ease,
  'Curves.easeIn': Curves.easeIn,
  'Curves.easeInToLinear': Curves.easeInToLinear,
  'Curves.easeInSine': Curves.easeInSine,
  'Curves.easeInQuad': Curves.easeInQuad,
  'Curves.easeInCubic': Curves.easeInCubic,
  'Curves.easeInQuart': Curves.easeInQuart,
  'Curves.easeInQuint': Curves.easeInQuint,
  'Curves.easeInExpo': Curves.easeInExpo,
  'Curves.easeInCirc': Curves.easeInCirc,
  'Curves.easeInBack': Curves.easeInBack,
  'Curves.easeOut': Curves.easeOut,
  'Curves.linearToEaseOut': Curves.linearToEaseOut,
  'Curves.easeOutSine': Curves.easeOutSine,
  'Curves.easeOutQuad': Curves.easeOutQuad,
  'Curves.easeOutCubic': Curves.easeOutCubic,
  'Curves.easeOutQuart': Curves.easeOutQuart,
  'Curves.easeOutQuint': Curves.easeOutQuint,
  'Curves.easeOutExpo': Curves.easeOutExpo,
  'Curves.easeOutCirc': Curves.easeOutCirc,
  'Curves.easeOutBack': Curves.easeOutBack,
  'Curves.easeInOut': Curves.easeInOut,
  'Curves.easeInOutSine': Curves.easeInOutSine,
  'Curves.easeInOutQuad': Curves.easeInOutQuad,
  'Curves.easeInOutCubic': Curves.easeInOutCubic,
  'Curves.easeInOutQuart': Curves.easeInOutQuart,
  'Curves.easeInOutQuint': Curves.easeInOutQuint,
  'Curves.easeInOutExpo': Curves.easeInOutExpo,
  'Curves.easeInOutCirc': Curves.easeInOutCirc,
  'Curves.easeInOutBack': Curves.easeInOutBack,
  'Curves.fastOutSlowIn': Curves.fastOutSlowIn,
  'Curves.slowMiddle': Curves.slowMiddle,
  'Curves.bounceIn': Curves.bounceIn,
  'Curves.bounceOut': Curves.bounceOut,
  'Curves.bounceInOut': Curves.bounceInOut,
  'Curves.elasticIn': Curves.elasticIn,
  'Curves.elasticOut': Curves.elasticOut,
  'Curves.elasticInOut': Curves.elasticInOut,
  'Easing.emphasizedAccelerate': Easing.emphasizedAccelerate,
  'Easing.emphasizedDecelerate': Easing.emphasizedDecelerate,
  'Easing.standard': Easing.standard,
  'Easing.standardAccelerate': Easing.standardAccelerate,
  'Easing.standardDecelerate': Easing.standardDecelerate,
  'Easing.legacy': Easing.legacy,
  'Easing.legacyAccelerate': Easing.legacyAccelerate,
  'Easing.legacyDecelerate': Easing.legacyDecelerate,
};

String findCurveName(Curve? curve) {
  if (curve is Interval) {
    return 'Interval (${curve.begin.toStringAsFixed(2)} - ${curve.end.toStringAsFixed(2)}): ${findCurveName(curve.curve)}';
  }

  final entry = defaultCurves.entries
      .where(
        (entry) => entry.value == curve,
      )
      .firstOrNull;

  return entry?.key ?? curve.toString();
}
