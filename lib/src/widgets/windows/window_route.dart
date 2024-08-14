import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:simulator/src/widgets/windows/transparent_route.dart';
import 'package:simulator/src/widgets/windows/window_widget.dart';

class WindowPage<T> extends Page<T> {
  const WindowPage({
    super.key,
    this.icon,
    this.title,
    this.pointerOffset,
    this.initialRect,
    required this.onPop,
    required this.onInteractedWith,
    required this.builder,
  });

  final Offset? pointerOffset;
  final Rect? initialRect;
  final Widget? icon;
  final Widget? title;
  final void Function(T?) onPop;
  final VoidCallback onInteractedWith;
  final WidgetBuilder builder;

  @override
  Route<T> createRoute(BuildContext context) {
    return WindowRoute<T>(
      settings: this,
      title: title,
      icon: icon,
      initialRect: initialRect,
      pointerOffset: pointerOffset,
      onPop: onPop,
      onInteractedWith: onInteractedWith,
      builder: builder,
    );
  }
}

class WindowRoute<T> extends TransparentRoute<T> {
  WindowRoute({
    required this.builder,
    required this.onPop,
    required this.onInteractedWith,
    this.title,
    this.icon,
    this.initialRect,
    this.pointerOffset,
    super.filter,
    super.settings,
    super.traversalEdgeBehavior,
  });

  final void Function(T?) onPop;
  final VoidCallback onInteractedWith;
  final Widget? icon;
  final Widget? title;
  final Rect? initialRect;
  final Offset? pointerOffset;
  final WidgetBuilder builder;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final child = LayoutBuilder(
      builder: (context, constraints) {
        Rect initialRect =
            this.initialRect ?? const Rect.fromLTWH(0, 0, 100, 100);

        final screenRect = Offset.zero & constraints.biggest;

        // Constrain the initial rect to the screen rect
        initialRect = _constrainWindowRect(
          initialRect,
          screenRect,
        );

        return Stack(
          clipBehavior: Clip.none,
          children: [
            _MovableWindow(
              onPop: onPop,
              onInteractedWith: onInteractedWith,
              initialRect: initialRect,
              screenRect: screenRect,
              initialOffset: pointerOffset,
              animation: animation,
              title: title,
              icon: icon,
              child: builder(context),
            ),
          ],
        );
      },
    );

    return child;
  }

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);
}

class _MovableWindow<T> extends StatefulWidget {
  const _MovableWindow({
    super.key,
    required this.animation,
    required this.screenRect,
    required this.initialRect,
    required this.child,
    required this.onPop,
    required this.onInteractedWith,
    this.title,
    this.icon,
    this.initialOffset,
  });

  final void Function(T?) onPop;
  final VoidCallback onInteractedWith;
  final Animation<double> animation;
  final Rect screenRect;
  final Rect initialRect;
  final Offset? initialOffset;
  final Widget? title;
  final Widget? icon;
  final Widget child;

  @override
  State<_MovableWindow<T>> createState() => _MovableWindowState<T>();
}

class _MovableWindowState<T> extends State<_MovableWindow<T>>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  late final _animation = CurvedAnimation(
    parent: _animationController,
    curve: Easing.emphasizedDecelerate,
  );

  RectTween? _rectTween;

  var _isMinimized = false;
  late var _rect = widget.initialRect;
  late var _rectBeforeMinimize = _rect;
  late var _offset = widget.initialOffset;

  Rect? _lastMinimizedRect;

  @override
  void initState() {
    super.initState();

    _clearOffsetAfterAnimation();
    _animationController.addListener(() {
      if (_rectTween != null) {
        _rect = _rectTween!.evaluate(_animation)!;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _clearOffsetAfterAnimation() {
    void _statusListener(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _offset = null;
        });

        widget.animation.removeStatusListener(_statusListener);
      }
    }

    widget.animation.addStatusListener(_statusListener);
  }

  void _onMinimize() {
    _isMinimized = true;

    _rectBeforeMinimize = _rect;
    _rectTween = MaterialRectArcTween(
      begin: _rect,
      end: _constrainWindowRect(
        _lastMinimizedRect ?? Rect.fromLTWH(_rect.left, _rect.top, 256.0, 64.0),
        widget.screenRect,
      ),
    );

    _lastMinimizedRect = _rectTween!.end!;
    _animationController.forward(from: 0.0);
    setState(() {});
  }

  void _onMaximize() {
    _isMinimized = false;

    _rectTween = MaterialRectArcTween(
      begin: _rect,
      end: _constrainWindowRect(
        Rect.fromLTWH(
          _rect.left,
          _rect.top,
          _rectBeforeMinimize.width,
          _rectBeforeMinimize.height,
        ),
        widget.screenRect,
      ),
    );

    _animationController.forward(from: 0.0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final child = TransformableBox(
      rect: _rect,
      onChanged: (result, _) {
        setState(() {
          _rect = result.rect;
        });

        if (_isMinimized) {
          _lastMinimizedRect = _rect;
        }
      },
      draggable: true,
      resizable: !_isMinimized,
      allowFlippingWhileResizing: false,
      allowContentFlipping: false,
      cornerHandleBuilder: (context, handle) => const SizedBox.shrink(),
      sideHandleBuilder: (context, handle) => const SizedBox.shrink(),
      contentBuilder: (context, rect, flip) {
        final Widget child;

        child = Listener(
          onPointerDown: (v) => widget.onInteractedWith(),
          child: WindowWidget(
            onMinimize: !_isMinimized ? _onMinimize : null,
            onMaximize: _isMinimized ? _onMaximize : null,
            title: widget.title,
            icon: widget.icon,
            child: widget.child,
          ),
        );

        return Navigator(
          clipBehavior: Clip.none,
          onPopPage: (route, result) {
            widget.onPop(result);
            return false;
          },
          pages: [
            MaterialPage(
              child: _WindowAnimator(
                offset: _offset,
                rect: _rect,
                animation: widget.animation,
                child: child,
              ),
            ),
          ],
        );
      },
    );

    return child;
  }
}

class _WindowAnimator extends StatelessWidget {
  const _WindowAnimator({
    required this.offset,
    required this.rect,
    required this.animation,
    required this.child,
  });

  final Rect rect;
  final Offset? offset;
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Alignment alignment;

    if (offset != null) {
      final localOffset = Offset(
        offset!.dx - rect.left,
        offset!.dy - rect.top,
      );

      final localFractionalOffset = FractionalOffset.fromOffsetAndSize(
        localOffset,
        rect.size,
      );

      alignment = Alignment(localFractionalOffset.x, localFractionalOffset.y);
    } else {
      alignment = Alignment.center;
    }

    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Easing.emphasizedDecelerate,
        reverseCurve: Easing.standardAccelerate,
      ),
      alignment: alignment,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
          reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
        ),
        child: child,
      ),
    );
  }
}

Rect _constrainWindowRect(Rect windowRect, Rect screenRect) {
  final width = clampDouble(windowRect.width, 64.0, screenRect.width);
  final height = clampDouble(windowRect.height, 64.0, screenRect.height);

  final left = clampDouble(windowRect.left, 0.0, screenRect.width - width);
  final top = clampDouble(windowRect.top, 0.0, screenRect.height - height);

  return Rect.fromLTWH(left, top, width, height);
}
