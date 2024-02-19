import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/simulator.dart';

mixin MobileGestureSimulatorBinding on BindingBase {
  @override
  void initInstances() {
    super.initInstances();

    Future.microtask(() {
      _initialize();
    });
  }

  void _initialize() {
    SimulatorWidgetsFlutterBinding.instance.platformDispatcher
        .pointerDataPacketTransformer = _transformPointerDataPacket;

    RawKeyboard.instance.addListener(_onKeybordEvent);
  }

  var convertMouseToTouch = false;
  var zoomGestureEnabled = false;

  Offset? zoomGestureCenter;
  Offset? _lastPointerLocation;
  Offset? _lastPointerLocalLocation;

  void _onKeybordEvent(RawKeyEvent event) {
    if (zoomGestureEnabled &&
        event is RawKeyDownEvent &&
        event.isControlPressed &&
        !event.repeat) {
      _onZoomGestureStarted();
    }

    if (event is RawKeyUpEvent && !event.isControlPressed) {
      _onZoomGestureEnded();
    }
  }

  MobileGestureSimulatorRenderObject get renderObject =>
      _mobileGestureSimulatorWidgetKey.currentContext!.findRenderObject()
          as MobileGestureSimulatorRenderObject;

  Offset? _convertOffsetWithDevicePixelRatio(
    Offset? offset, {
    required int viewId,
  }) {
    if (offset == null) {
      return null;
    }

    return offset / platformDispatcher.view(id: viewId)!.devicePixelRatio;
  }

  Offset? _getLocalPosition(PointerData data) {
    return _convertOffsetWithDevicePixelRatio(
      Offset(data.physicalX, data.physicalY),
      viewId: data.viewId,
    );
  }

  void _onZoomGestureStarted() {
    zoomGestureCenter = _lastPointerLocation;
    renderObject.zoomGestureCenter = _lastPointerLocalLocation;

    renderObject.pointers = [];
  }

  void _onZoomGestureEnded() {
    zoomGestureCenter = null;
    renderObject.zoomGestureCenter = null;
  }

  PointerDataPacket _transformPointerDataPacket(PointerDataPacket packet) {
    final mouseData = packet.firstMouseData;

    if (mouseData != null) {
      _lastPointerLocation = Offset(mouseData.physicalX, mouseData.physicalY);
      _lastPointerLocalLocation = _getLocalPosition(mouseData);
    } else {
      _lastPointerLocation = null;
      _lastPointerLocalLocation = null;
    }

    return _convertMouseToTouch(_applyZoomGesture(packet));
  }

  PointerDataPacket _applyZoomGesture(PointerDataPacket packet) {
    if (!zoomGestureEnabled) {
      return packet;
    }

    if (zoomGestureCenter == null) {
      return packet;
    }

    final mouseData = packet.firstMouseData;

    if (mouseData == null) {
      return packet;
    }

    final mirroredMouseData = mouseData.copyWith(
      pointerIdentifier: mouseData.pointerIdentifier + 1,
      physicalX: zoomGestureCenter!.dx * 2 - mouseData.physicalX,
      physicalY: zoomGestureCenter!.dy * 2 - mouseData.physicalY,
      synthesized: true,
    );

    renderObject.pointers = [
      _getLocalPosition(mouseData)!,
      _getLocalPosition(mirroredMouseData)!,
    ];

    return PointerDataPacket(data: [
      ...packet.data,
      mirroredMouseData,
    ]);
  }

  PointerDataPacket _convertMouseToTouch(PointerDataPacket packet) {
    if (!convertMouseToTouch) {
      return packet;
    }

    return PointerDataPacket(
      data: packet.data.map((v) {
        final localPosition = _getLocalPosition(v);
        final appKey = SimulatorWidgetsFlutterBinding.instance.appKey;
        final renderObject =
            appKey.currentContext!.findRenderObject() as RenderBox;

        final deviceRect = renderObject.localToGlobal(
              Offset.zero,
              ancestor: renderObject,
            ) &
            renderObject.size;

        if (localPosition != null && !deviceRect.contains(localPosition)) {
          return v;
        }

        if (v.buttons != kPrimaryMouseButton) {
          return v;
        }

        return v.copyWith(
          kind: v.kind == PointerDeviceKind.mouse
              ? PointerDeviceKind.touch
              : v.kind,
        );
      }).toList(),
    );
  }
}

extension _PacketDataUtils on PointerDataPacket {
  PointerData? get firstMouseData {
    for (final event in data) {
      if (event.kind == PointerDeviceKind.mouse) {
        return event;
      }
    }

    return null;
  }
}

extension _PointerDataCopyWith on PointerData {
  PointerData copyWith({
    PointerChange? change,
    PointerDeviceKind? kind,
    double? pressure,
    double? pressureMin,
    double? pressureMax,
    double? distance,
    double? distanceMax,
    double? size,
    double? radiusMajor,
    double? radiusMinor,
    double? radiusMin,
    double? radiusMax,
    double? orientation,
    double? tilt,
    int? device,
    int? pointerIdentifier,
    int? buttons,
    Duration? timeStamp,
    int? embedderId,
    bool? obscured,
    bool? synthesized,
    double? panDeltaX,
    double? panDeltaY,
    double? scrollDeltaX,
    double? scrollDeltaY,
    double? panX,
    double? panY,
    double? physicalDeltaX,
    double? physicalDeltaY,
    double? physicalX,
    double? physicalY,
    int? platformData,
    double? rotation,
    double? scale,
    PointerSignalKind? signalKind,
    int? viewId,
  }) {
    return PointerData(
      change: change ?? this.change,
      kind: kind ?? this.kind,
      pressure: pressure ?? this.pressure,
      pressureMin: pressureMin ?? this.pressureMin,
      pressureMax: pressureMax ?? this.pressureMax,
      distance: distance ?? this.distance,
      distanceMax: distanceMax ?? this.distanceMax,
      size: size ?? this.size,
      radiusMajor: radiusMajor ?? this.radiusMajor,
      radiusMinor: radiusMinor ?? this.radiusMinor,
      radiusMin: radiusMin ?? this.radiusMin,
      radiusMax: radiusMax ?? this.radiusMax,
      orientation: orientation ?? this.orientation,
      tilt: tilt ?? this.tilt,
      device: device ?? this.device,
      pointerIdentifier: pointerIdentifier ?? this.pointerIdentifier,
      buttons: buttons ?? this.buttons,
      timeStamp: timeStamp ?? this.timeStamp,
      embedderId: embedderId ?? this.embedderId,
      obscured: obscured ?? this.obscured,
      synthesized: synthesized ?? this.synthesized,
      panDeltaX: panDeltaX ?? this.panDeltaX,
      panDeltaY: panDeltaY ?? this.panDeltaY,
      scrollDeltaX: scrollDeltaX ?? this.scrollDeltaX,
      scrollDeltaY: scrollDeltaY ?? this.scrollDeltaY,
      panX: panX ?? this.panX,
      panY: panY ?? this.panY,
      physicalDeltaX: physicalDeltaX ?? this.physicalDeltaX,
      physicalDeltaY: physicalDeltaY ?? this.physicalDeltaY,
      physicalX: physicalX ?? this.physicalX,
      physicalY: physicalY ?? this.physicalY,
      platformData: platformData ?? this.platformData,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      signalKind: signalKind ?? this.signalKind,
      viewId: viewId ?? this.viewId,
    );
  }
}

final _mobileGestureSimulatorWidgetKey = GlobalKey();

class MobileGestureSimulatorWidget extends LeafRenderObjectWidget {
  const MobileGestureSimulatorWidget({super.key});

  static Key get requiredKey => _mobileGestureSimulatorWidgetKey;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MobileGestureSimulatorRenderObject();
  }

  @override
  void updateRenderObject(
    BuildContext context,
    MobileGestureSimulatorRenderObject renderObject,
  ) {}
}

class MobileGestureSimulatorRenderObject extends RenderBox {
  Offset? _zoomGestureCenter;
  List<Offset> _pointers = [];

  set zoomGestureCenter(Offset? value) {
    if (_zoomGestureCenter != value) {
      _zoomGestureCenter = value;
      markNeedsPaint();
    }
  }

  set pointers(List<Offset> value) {
    if (!listEquals(_pointers, value)) {
      _pointers = value;
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color.fromRGBO(255, 255, 255, 0.25)
      ..strokeWidth = 2;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color.fromRGBO(0, 0, 0, 0.25);

    if (_zoomGestureCenter != null) {
      context.canvas.drawCircle(_zoomGestureCenter!, 16, borderPaint);
      context.canvas.drawCircle(_zoomGestureCenter!, 16, fillPaint);

      for (final pointer in _pointers) {
        context.canvas.drawCircle(pointer, 8, borderPaint);
        context.canvas.drawCircle(pointer, 8, fillPaint);
      }
    }
  }
}
