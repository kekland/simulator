import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/modules/inspector_module/inspector_selection_gesture_overlay.dart';
import 'package:simulator/src/modules/inspector_module/render_inspector_selection.dart';
import 'package:simulator/src/state/simulator_state.dart';
import 'package:simulator/src/widgets/expansion_tile.dart';
import 'package:simulator/src/widgets/size_utils.dart';

class InspectorState {
  const InspectorState({
    this.selectedRenderObject,
    this.targetRenderObject,
    this.hoverRenderObject,
    this.isSelectionGestureEnabled = false,
  });

  final RenderObject? selectedRenderObject;
  final RenderObject? targetRenderObject;
  final RenderObject? hoverRenderObject;
  final bool isSelectionGestureEnabled;

  InspectorState copyWith({
    RenderObject? selectedRenderObject,
    RenderObject? targetRenderObject,
    RenderObject? hoverRenderObject,
    bool? isSelectionGestureEnabled,
  }) {
    return InspectorState(
      selectedRenderObject: selectedRenderObject ?? this.selectedRenderObject,
      targetRenderObject: targetRenderObject ?? this.targetRenderObject,
      hoverRenderObject: hoverRenderObject ?? this.hoverRenderObject,
      isSelectionGestureEnabled:
          isSelectionGestureEnabled ?? this.isSelectionGestureEnabled,
    );
  }

  InspectorState copyWithoutSelectedRenderObject() {
    return InspectorState(
      selectedRenderObject: null,
      targetRenderObject: null,
      hoverRenderObject: null,
      isSelectionGestureEnabled: isSelectionGestureEnabled,
    );
  }

  InspectorState copyWithoutHoverRenderObject() {
    return InspectorState(
      selectedRenderObject: selectedRenderObject,
      targetRenderObject: targetRenderObject,
      hoverRenderObject: null,
      isSelectionGestureEnabled: isSelectionGestureEnabled,
    );
  }
}

class InspectorModule extends SimulatorModule<InspectorState> {
  const InspectorModule();

  @override
  InspectorState createInitialState(json) => const InspectorState();

  @override
  Map<String, dynamic> toJson(Object data) => {};

  @override
  String get id => 'inspector';

  @override
  Widget buildPanel(
    BuildContext context,
    SimulatorState state,
    ValueChanged<InspectorState> onChanged,
  ) {
    return SectionCard(
      title: const Text('Inspector'),
      leading: const Icon(Icons.lens_blur_rounded),
      builder: (context) => _InspectorPanel(
        state: state.get<InspectorState>(id),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget buildOverlay(
    BuildContext context,
    SimulatorState state,
    ValueChanged<InspectorState> onChanged,
  ) {
    final data = state.get<InspectorState>(id);

    return Stack(
      children: [
        if (data.isSelectionGestureEnabled)
          InspectorSelectionGestureOverlay(
            onRenderObjectSelected: (v) {
              onChanged(
                data.copyWith(
                  selectedRenderObject: v,
                  targetRenderObject: v,
                  isSelectionGestureEnabled: false,
                ),
              );
            },
          ),
        if (data.targetRenderObject != null)
          InspectorSelectionOverlay(
            renderObject: data.hoverRenderObject ?? data.targetRenderObject,
            onDetached: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onChanged(data.copyWithoutSelectedRenderObject());
              });
            },
          ),
      ],
    );
  }
}

class _InspectorPanel extends StatefulWidget {
  const _InspectorPanel({
    required this.state,
    required this.onChanged,
  });

  final InspectorState state;
  final ValueChanged<InspectorState> onChanged;

  @override
  State<_InspectorPanel> createState() => _InspectorPanelState();
}

class _InspectorPanelState extends State<_InspectorPanel> {
  @override
  void initState() {
    super.initState();
  }

  List<RenderObject> _getAllParents(RenderObject object) {
    final list = <RenderObject>[object];

    var parent = object.parent;
    while (parent != null) {
      list.add(parent);
      parent = parent.parent;

      if (parent ==
          SimulatorWidgetsFlutterBinding.instance.appRepaintBoundary) {
        break;
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isSelecting = widget.state.isSelectionGestureEnabled;

    final allObjects = widget.state.selectedRenderObject != null
        ? _getAllParents(widget.state.selectedRenderObject!)
        : <RenderObject>[];

    return SectionList(
      children: [
        if (isSelecting)
          ListTile(
            onTap: () => widget.onChanged(
              widget.state.copyWith(
                isSelectionGestureEnabled: false,
              ),
            ),
            leading: const Icon(Icons.touch_app_rounded),
            title: const Text('Selecting RenderObject'),
            subtitle: const Text('Tap to cancel'),
          )
        else
          ListTile(
            onTap: () => widget.onChanged(
              const InspectorState(isSelectionGestureEnabled: true),
            ),
            leading: const Icon(Icons.touch_app_rounded),
            title: const Text('Select RenderObject'),
          ),
        if (widget.state.selectedRenderObject != null) ...[
          SmExpansionTile(
            leading: const Icon(Icons.account_tree_rounded),
            title: const Text('Selected RenderObject'),
            subtitle: Text(describeIdentity(widget.state.selectedRenderObject)),
            child: Column(
              children: [
                for (final object in allObjects)
                  _RenderObjectListTile(
                    onSelected: () => widget.onChanged(
                      widget.state.copyWith(
                        targetRenderObject: object,
                      ),
                    ),
                    groupValue: widget.state.targetRenderObject!,
                    object: object,
                    onMouseEnter: () {
                      widget.onChanged(
                        widget.state.copyWith(
                          hoverRenderObject: object,
                        ),
                      );
                    },
                    onMouseExit: () {
                      widget.onChanged(
                        widget.state.copyWithoutHoverRenderObject(),
                      );
                    },
                  ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              // windowRootNavigatorStateKey.currentState!.pushWindow();
            },
            leading: const Icon(Icons.info_rounded),
            title: const Text('Show properties window'),
          ),
        ],
      ],
    );
  }
}

class _RenderObjectListTile extends StatelessWidget {
  const _RenderObjectListTile({
    required this.object,
    required this.onSelected,
    required this.groupValue,
    required this.onMouseEnter,
    required this.onMouseExit,
  });

  final VoidCallback onMouseEnter;
  final VoidCallback onMouseExit;

  final VoidCallback onSelected;
  final RenderObject groupValue;
  final RenderObject object;

  @override
  Widget build(BuildContext context) {
    String title;

    if (object.debugCreator is DebugCreator) {
      final creator = object.debugCreator as DebugCreator;
      title = creator.element.widget.runtimeType.toString();
    } else {
      title = '${object.depth}';
    }

    Size? size;

    if (object.debugNeedsPaint) {
      size = null;
    } else {
      size = object.paintBounds.size;
    }

    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      onEnter: (_) => onMouseEnter(),
      onExit: (_) => onMouseExit(),
      child: RadioListTile(
        onChanged: (v) => onSelected(),
        value: object,
        groupValue: groupValue,
        title: Text(title),
        subtitle: Text(describeIdentity(object)),
        secondary: Text(size?.toFormattedString() ?? '<no size>'),
      ),
    );
  }
}
