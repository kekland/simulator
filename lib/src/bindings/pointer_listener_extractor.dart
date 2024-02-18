import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/bindings/pipeline_owner.dart';
import 'package:simulator/src/widgets/pointer_listener_overlay.dart';

mixin PointerListenerExtractorBinding on SchedulerBinding, RendererBinding {
  @override
  void initInstances() {
    super.initInstances();

    (rootPipelineOwner as SimulatorPipelineOwner).onAfterFlushCompositingBits =
        _capturePointerListeners;
  }

  final pointerListenerOverlayKey = GlobalKey();

  RenderPointerListenerOverlay? get _pointerListenerOverlay {
    final context = pointerListenerOverlayKey.currentContext;

    if (context != null && (context as Element).debugIsActive) {
      return pointerListenerOverlayKey.currentContext?.findRenderObject()
          as RenderPointerListenerOverlay?;
    }

    return null;
  }

  Widget buildPointerListenerOverlay() {
    return MouseRegion(
      onHover: (event) {
        _pointerListenerOverlay?.pointerOffset = event.localPosition;
      },
      onEnter: (event) {
        _pointerListenerOverlay?.pointerOffset = event.localPosition;
      },
      onExit: (event) {
        _pointerListenerOverlay?.pointerOffset = null;
      },
      hitTestBehavior: HitTestBehavior.translucent,
      child: PointerListenerOverlay(key: pointerListenerOverlayKey),
    );
  }

  void _capturePointerListeners() {
    final renderObject =
        SimulatorWidgetsFlutterBinding.instance.appRepaintBoundary;

    final pointerListeners = <RenderPointerListener>[];
    final queue = <RenderObject>[renderObject];

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      if (current is RenderPointerListener) {
        pointerListeners.add(current);
      }

      current.visitChildren((child) {
        queue.add(child);
      });
    }

    _pointerListenerOverlay?.pointerListeners = pointerListeners;
    _pointerListenerOverlay?.subtreeRenderObject = renderObject;
  }

  @override
  void drawFrame() {
    super.drawFrame();
  }
}
