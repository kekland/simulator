import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/modules/inspector_module/render_inspector_selection.dart';

class InspectorSelectionGestureOverlay extends StatefulWidget {
  const InspectorSelectionGestureOverlay({
    super.key,
    required this.onRenderObjectSelected,
  });

  final ValueChanged<RenderObject> onRenderObjectSelected;

  @override
  State<InspectorSelectionGestureOverlay> createState() =>
      _InspectorSelectionGestureOverlayState();
}

class _InspectorSelectionGestureOverlayState
    extends State<InspectorSelectionGestureOverlay> {
  final _renderInspectorSelectionKey = GlobalKey();
  RenderBox? _selectedRenderObject;

  RenderInspectorSelectionOverlay? get _renderInspectorSelection {
    final context = _renderInspectorSelectionKey.currentContext;

    if ((context as Element?)?.debugIsActive == true) {
      return context!.findRenderObject() as RenderInspectorSelectionOverlay?;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onPointerHover(Offset position) {
    final appRenderObject =
        SimulatorWidgetsFlutterBinding.instance.appRepaintBoundary;

    final result = BoxHitTestResult();
    appRenderObject.hitTest(result, position: position);

    final hitChild = result.path
        .where((v) => v.target is RenderBox)
        .firstOrNull
        ?.target as RenderBox?;

    _selectedRenderObject = hitChild;

    _renderInspectorSelection?.selectedRenderObject = hitChild;
    _renderInspectorSelection?.pointerOffset = position;
  }

  void _onPointerUp() {
    if (_selectedRenderObject != null) {
      widget.onRenderObjectSelected(_selectedRenderObject!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InspectorSelectionOverlay(
          rendererKey: _renderInspectorSelectionKey,
          onDetached: () {
            _selectedRenderObject = null;
          },
        ),
        Listener(
          behavior: HitTestBehavior.opaque,
          onPointerHover: (event) => _onPointerHover(event.localPosition),
          onPointerUp: (event) => _onPointerUp(),
          child: const SizedBox.expand(),
        ),
      ],
    );
  }
}
