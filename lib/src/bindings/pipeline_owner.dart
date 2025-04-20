import 'package:flutter/rendering.dart';
import 'package:simulator/simulator.dart';

final class SimulatorPipelineOwner extends PipelineOwner {
  final _onAfterFlushCompositingBits = <VoidCallback>[];
  final _onAfterFlushPaint = <VoidCallback>[];

  SimulatorPipelineOwner()
      : super(
          // Prevents crash on Linux from non-null assertion
          // (https://github.com/kekland/simulator/issues/1)
          onSemanticsUpdate: (_) {},
        );

  void addAfterFlushCompositingBitsCallback(VoidCallback callback) {
    _onAfterFlushCompositingBits.add(callback);
  }

  void addAfterFlushPaintCallback(VoidCallback callback) {
    _onAfterFlushPaint.add(callback);
  }

  void removeAfterFlushCompositingBitsCallback(VoidCallback callback) {
    _onAfterFlushCompositingBits.remove(callback);
  }

  void removeAfterFlushPaintCallback(VoidCallback callback) {
    _onAfterFlushPaint.remove(callback);
  }

  @override
  void flushCompositingBits() {
    super.flushCompositingBits();

    for (final cb in _onAfterFlushCompositingBits) {
      cb();
    }
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
      for (final cb in _onAfterFlushPaint) {
        cb();
      }
    }
  }
}
