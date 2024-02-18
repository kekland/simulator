import 'package:flutter/rendering.dart';
import 'package:simulator/simulator.dart';

class SimulatorPipelineOwner extends PipelineOwner {
  VoidCallback? onAfterFlushCompositingBits;
  VoidCallback? onAfterFlushPaint;

  @override
  void flushCompositingBits() {
    super.flushCompositingBits();
    onAfterFlushCompositingBits?.call();
  }

  bool get _isAppRepaintBoundaryDirty {
    final queue = <RenderObject>[
      SimulatorWidgetsFlutterBinding.instance.appRepaintBoundary
    ];

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      if (current.debugNeedsPaint) {
        return true;
      }

      current.visitChildren((child) {
        queue.add(child);
      });
    }

    return false;
  }

  @override
  void flushPaint() {
    final wasAppDirty = _isAppRepaintBoundaryDirty;

    super.flushPaint();

    if (wasAppDirty) {
      onAfterFlushPaint?.call();
    }
  }
}
