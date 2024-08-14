import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';
import 'package:simulator/src/utils/duration_utils.dart';
import 'package:simulator/src/widgets/curve_graph_widget.dart';
import 'package:simulator/src/widgets/curve_editor_window.dart';
import 'package:simulator/src/widgets/duration_editor_window.dart';
import 'package:simulator/src/widgets/expansion_tile.dart';

class AnimationControllerWindow extends StatelessWidget {
  const AnimationControllerWindow({super.key, required this.animation});

  final InterceptableAnimation animation;

  @override
  Widget build(BuildContext context) {
    final controller = animation.controller;

    return SectionList(
      children: [
        if (controller != null) ...[
          SmExpansionTile(
            leading: const Icon(Icons.motion_photos_on_rounded),
            title: const Text('Controller'),
            subtitle: Text(describeIdentity(controller)),
            child: _AnimationControllerWidget(controller: controller),
          ),
        ],
        if (animation.parent is CurvedAnimation) ...[
          SmExpansionTile(
            leading: const Icon(Icons.show_chart_rounded),
            title: const Text('Curve'),
            subtitle: const Text('Preview/edit the easing'),
            child: _CurvedAnimationEditorWidget(
              animation: animation.parent as CurvedAnimation,
              controller: controller,
            ),
          ),
        ],
      ],
    );
  }
}

class _AnimationControllerWidget extends StatefulWidget {
  const _AnimationControllerWidget({
    required this.controller,
  });

  final AnimationController controller;

  @override
  State<_AnimationControllerWidget> createState() =>
      _AnimationControllerWidgetState();
}

class _AnimationControllerWidgetState
    extends State<_AnimationControllerWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return SectionList(
          children: [
            SliderTile(
              title: 'Value',
              subtitle: 'Current value of the controller',
              value: widget.controller.value,
              onChanged: (value) {
                widget.controller.value = value;
              },
              resetValue: widget.controller.lowerBound,
              min: widget.controller.lowerBound,
              max: widget.controller.upperBound,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: 64.0,
                    child: IconButton(
                      icon: const RotatedBox(
                        quarterTurns: 2,
                        child: Icon(Icons.replay_rounded),
                      ),
                      onPressed: () => widget.controller.forward(from: 0.0),
                    ),
                  ),
                  const Spacer(),
                  SizedBox.square(
                    dimension: 64.0,
                    child: IconButton(
                      icon: const RotatedBox(
                        quarterTurns: 2,
                        child: Icon(Icons.play_arrow_rounded),
                      ),
                      onPressed: widget.controller.reverse,
                    ),
                  ),
                  SizedBox.square(
                    dimension: 64.0,
                    child: IconButton(
                      icon: const Icon(Icons.pause_rounded),
                      onPressed: widget.controller.stop,
                    ),
                  ),
                  SizedBox.square(
                    dimension: 64.0,
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow_rounded),
                      onPressed: widget.controller.forward,
                    ),
                  ),
                  const Spacer(),
                  SizedBox.square(
                    dimension: 64.0,
                    child: IconButton(
                      icon: const Icon(Icons.replay_rounded),
                      onPressed: () => widget.controller.reverse(from: 1.0),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () async {
                final duration = await showDurationEditorWindow(
                  context,
                  initialDuration: widget.controller.duration,
                );

                if (duration != null) {
                  widget.controller.duration = duration;
                  setState(() {});
                }
              },
              leading: const Icon(Icons.timer_rounded),
              trailing: const Icon(Icons.chevron_right_rounded),
              title: Text(
                widget.controller.duration?.toFormattedString() ?? 'none',
              ),
              subtitle: const Text('Duration'),
            ),
            ListTile(
              onTap: () async {
                final duration = await showDurationEditorWindow(
                  context,
                  initialDuration: widget.controller.reverseDuration,
                );

                if (duration != null) {
                  widget.controller.reverseDuration = duration;
                  setState(() {});
                }
              },
              leading: const Icon(Icons.timer_rounded),
              trailing: const Icon(Icons.chevron_right_rounded),
              title: Text(
                widget.controller.reverseDuration?.toFormattedString() ??
                    'none',
              ),
              subtitle: const Text('Reverse duration'),
            ),
          ],
        );
      },
    );
  }
}

class _CurvedAnimationEditorWidget extends StatefulWidget {
  const _CurvedAnimationEditorWidget({
    required this.animation,
    this.controller,
  });

  final AnimationController? controller;
  final CurvedAnimation animation;

  @override
  State<_CurvedAnimationEditorWidget> createState() =>
      _CurvedAnimationEditorWidgetState();
}

class _CurvedAnimationEditorWidgetState
    extends State<_CurvedAnimationEditorWidget> {
  double? _controllerValue;

  @override
  void initState() {
    super.initState();

    widget.controller?.addListener(_onControllerChanged);
    _controllerValue = widget.controller?.value;
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {
      _controllerValue = widget.controller?.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasReverseCurve = widget.animation.reverseCurve != null;

    return Column(
      children: [
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CurvePreviewGraphWidget(
              transform: widget.animation.curve.transform,
              curveColor: Colors.blue,
              currentX: !hasReverseCurve ||
                      widget.animation.status == AnimationStatus.forward
                  ? _controllerValue
                  : null,
            ),
            if (widget.animation.reverseCurve != null) ...[
              const SizedBox(width: 16.0),
              CurvePreviewGraphWidget(
                transform: widget.animation.reverseCurve!.transform,
                curveColor: Colors.pink,
                currentX: widget.animation.status == AnimationStatus.reverse
                    ? _controllerValue
                    : null,
              ),
            ],
          ],
        ),
        ListTile(
          onTap: () {
            showCurveEditorWindow(
              context,
              initialCurve: widget.animation.curve,
              onCurveChanged: (v) {
                widget.animation.curve = v;
                setState(() {});
              },
            );
          },
          leading: const Icon(Icons.data_object_rounded),
          trailing: const Icon(Icons.chevron_right_rounded),
          title: Text(findCurveName(widget.animation.curve)),
          subtitle: const Text('Curve'),
        ),
        ListTile(
          onTap: () {
            showCurveEditorWindow(
              context,
              initialCurve: widget.animation.reverseCurve,
              onCurveChanged: (v) {
                widget.animation.reverseCurve = v;
                setState(() {});
              },
            );
          },
          leading: const Icon(Icons.data_object_rounded),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: () {
                  widget.animation.reverseCurve = null;
                  setState(() {});
                },
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
          title: Text(findCurveName(widget.animation.reverseCurve)),
          subtitle: const Text('Reverse curve'),
        ),
      ],
    );
  }
}
