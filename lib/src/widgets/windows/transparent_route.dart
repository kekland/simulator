// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class _DismissModalAction extends DismissAction {
  _DismissModalAction(this.context);

  final BuildContext context;

  @override
  bool isEnabled(DismissIntent intent) {
    final ModalRoute<dynamic> route = ModalRoute.of<dynamic>(context)!;
    return route.barrierDismissible;
  }

  @override
  Object invoke(DismissIntent intent) {
    return Navigator.of(context).maybePop();
  }
}

class _ModalScopeStatus extends InheritedWidget {
  const _ModalScopeStatus({
    required this.isCurrent,
    required this.canPop,
    required this.impliesAppBarDismissal,
    required this.route,
    required super.child,
  });

  final bool isCurrent;
  final bool canPop;
  final bool impliesAppBarDismissal;
  final Route<dynamic> route;

  @override
  bool updateShouldNotify(_ModalScopeStatus old) {
    return isCurrent != old.isCurrent ||
           canPop != old.canPop ||
           impliesAppBarDismissal != old.impliesAppBarDismissal ||
           route != old.route;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(FlagProperty('isCurrent', value: isCurrent, ifTrue: 'active', ifFalse: 'inactive'));
    description.add(FlagProperty('canPop', value: canPop, ifTrue: 'can pop'));
    description.add(FlagProperty('impliesAppBarDismissal', value: impliesAppBarDismissal, ifTrue: 'implies app bar dismissal'));
  }
}

class _ModalScope<T> extends StatefulWidget {
  const _ModalScope({
    super.key,
    required this.route,
  });

  final TransparentRoute<T> route;

  @override
  _ModalScopeState<T> createState() => _ModalScopeState<T>();
}

class _ModalScopeState<T> extends State<_ModalScope<T>> {
  // We cache the result of calling the route's buildPage, and clear the cache
  // whenever the dependencies change. This implements the contract described in
  // the documentation for buildPage, namely that it gets called once, unless
  // something like a ModalRoute.of() dependency triggers an update.
  Widget? _page;

  // This is the combination of the two animations for the route.
  late Listenable _listenable;

  /// The node this scope will use for its root [FocusScope] widget.
  final FocusScopeNode focusScopeNode = FocusScopeNode(
    debugLabel: '$_ModalScopeState Focus Scope',
  );
  final ScrollController primaryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final List<Listenable> animations = <Listenable>[
      if (widget.route.animation != null) widget.route.animation!,
      if (widget.route.secondaryAnimation != null) widget.route.secondaryAnimation!,
    ];
    _listenable = Listenable.merge(animations);
  }

  @override
  void didUpdateWidget(_ModalScope<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.route == oldWidget.route);
    _updateFocusScopeNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _page = null;
    _updateFocusScopeNode();
  }

  void _updateFocusScopeNode() {
    final TraversalEdgeBehavior traversalEdgeBehavior;
    final TransparentRoute<T> route = widget.route;
    if (route.traversalEdgeBehavior != null) {
      traversalEdgeBehavior = route.traversalEdgeBehavior!;
    } else {
      traversalEdgeBehavior = route.navigator!.widget.routeTraversalEdgeBehavior;
    }
    focusScopeNode.traversalEdgeBehavior = traversalEdgeBehavior;
    if (route.isCurrent && _shouldRequestFocus) {
      route.navigator!.focusNode.enclosingScope?.setFirstFocus(focusScopeNode);
    }
  }

  void _forceRebuildPage() {
    setState(() {
      _page = null;
    });
  }

  @override
  void dispose() {
    focusScopeNode.dispose();
    primaryScrollController.dispose();
    super.dispose();
  }

  bool get _shouldIgnoreFocusRequest {
    return widget.route.animation?.status == AnimationStatus.reverse ||
      (widget.route.navigator?.userGestureInProgress ?? false);
  }

  bool get _shouldRequestFocus {
    return widget.route.navigator!.widget.requestFocus;
  }

  // This should be called to wrap any changes to route.isCurrent, route.canPop,
  // and route.offstage.
  void _routeSetState(VoidCallback fn) {
    if (widget.route.isCurrent && !_shouldIgnoreFocusRequest && _shouldRequestFocus) {
      widget.route.navigator!.focusNode.enclosingScope?.setFirstFocus(focusScopeNode);
    }
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    // Only top most route can participate in focus traversal.
    focusScopeNode.skipTraversal = !widget.route.isCurrent;
    return AnimatedBuilder(
      animation: widget.route.restorationScopeId,
      builder: (BuildContext context, Widget? child) {
        assert(child != null);
        return RestorationScope(
          restorationId: widget.route.restorationScopeId.value,
          child: child!,
        );
      },
      child: _ModalScopeStatus(
        route: widget.route,
        isCurrent: widget.route.isCurrent, // _routeSetState is called if this updates
        canPop: widget.route.canPop, // _routeSetState is called if this updates
        impliesAppBarDismissal: widget.route.impliesAppBarDismissal,
        child: Offstage(
          offstage: widget.route.offstage, // _routeSetState is called if this updates
          child: PageStorage(
            bucket: widget.route._storageBucket, // immutable
            child: Builder(
              builder: (BuildContext context) {
                return Actions(
                  actions: <Type, Action<Intent>>{
                    DismissIntent: _DismissModalAction(context),
                  },
                  child: PrimaryScrollController(
                    controller: primaryScrollController,
                    child: FocusScope.withExternalFocusNode(
                      focusScopeNode: focusScopeNode, // immutable
                      child: RepaintBoundary(
                        child: ListenableBuilder(
                          listenable: _listenable, // immutable
                          builder: (BuildContext context, Widget? child) {
                            return widget.route.buildTransitions(
                              context,
                              widget.route.animation!,
                              widget.route.secondaryAnimation!,
                              // This additional ListenableBuilder is include because if the
                              // value of the userGestureInProgressNotifier changes, it's
                              // only necessary to rebuild the IgnorePointer widget and set
                              // the focus node's ability to focus.
                              ListenableBuilder(
                                listenable: widget.route.navigator?.userGestureInProgressNotifier ?? ValueNotifier<bool>(false),
                                builder: (BuildContext context, Widget? child) {
                                  final bool ignoreEvents = _shouldIgnoreFocusRequest;
                                  focusScopeNode.canRequestFocus = !ignoreEvents;
                                  return IgnorePointer(
                                    ignoring: ignoreEvents,
                                    child: child,
                                  );
                                },
                                child: child,
                              ),
                            );
                          },
                          child: _page ??= RepaintBoundary(
                            key: widget.route._subtreeKey, // immutable
                            child: Builder(
                              builder: (BuildContext context) {
                                return widget.route.buildPage(
                                  context,
                                  widget.route.animation!,
                                  widget.route.secondaryAnimation!,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// A route that blocks interaction with previous routes.
///
/// [ModalRoute]s cover the entire [Navigator]. They are not necessarily
/// [opaque], however; for example, a pop-up menu uses a [ModalRoute] but only
/// shows the menu in a small box overlapping the previous route.
///
/// The `T` type argument is the return value of the route. If there is no
/// return value, consider using `void` as the return value.
///
/// See also:
///
///  * [Route], which further documents the meaning of the `T` generic type argument.
abstract class TransparentRoute<T> extends TransitionRoute<T> with LocalHistoryRoute<T> {
  /// Creates a route that blocks interaction with previous routes.
  TransparentRoute({
    super.settings,
    this.filter,
    this.traversalEdgeBehavior,
  });

  /// The filter to add to the barrier.
  ///
  /// If given, this filter will be applied to the modal barrier using
  /// [BackdropFilter]. This allows blur effects, for example.
  final ui.ImageFilter? filter;

  /// Controls the transfer of focus beyond the first and the last items of a
  /// [FocusScopeNode].
  ///
  /// If set to null, [Navigator.routeTraversalEdgeBehavior] is used.
  final TraversalEdgeBehavior? traversalEdgeBehavior;

  // The API for general users of this class

  /// Returns the modal route most closely associated with the given context.
  ///
  /// Returns null if the given context is not associated with a modal route.
  ///
  /// {@tool snippet}
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ModalRoute<int>? route = ModalRoute.of<int>(context);
  /// ```
  /// {@end-tool}
  ///
  /// The given [BuildContext] will be rebuilt if the state of the route changes
  /// while it is visible (specifically, if [isCurrent] or [canPop] change value).
  @optionalTypeArgs
  static TransparentRoute<T>? of<T extends Object?>(BuildContext context) {
    final _ModalScopeStatus? widget = context.dependOnInheritedWidgetOfExactType<_ModalScopeStatus>();
    return widget?.route as TransparentRoute<T>?;
  }

  /// Schedule a call to [buildTransitions].
  ///
  /// Whenever you need to change internal state for a [ModalRoute] object, make
  /// the change in a function that you pass to [setState], as in:
  ///
  /// ```dart
  /// setState(() { _myState = newValue; });
  /// ```
  ///
  /// If you just change the state directly without calling [setState], then the
  /// route will not be scheduled for rebuilding, meaning that its rendering
  /// will not be updated.
  @protected
  void setState(VoidCallback fn) {
    if (_scopeKey.currentState != null) {
      _scopeKey.currentState!._routeSetState(fn);
    } else {
      // The route isn't currently visible, so we don't have to call its setState
      // method, but we do still need to call the fn callback, otherwise the state
      // in the route won't be updated!
      fn();
    }
  }

  /// Returns a predicate that's true if the route has the specified name and if
  /// popping the route will not yield the same route, i.e. if the route's
  /// [willHandlePopInternally] property is false.
  ///
  /// This function is typically used with [Navigator.popUntil()].
  static RoutePredicate withName(String name) {
    return (Route<dynamic> route) {
      return !route.willHandlePopInternally
          && route is ModalRoute
          && route.settings.name == name;
    };
  }

  // The API for subclasses to override - used by _ModalScope

  /// Override this method to build the primary content of this route.
  ///
  /// The arguments have the following meanings:
  ///
  ///  * `context`: The context in which the route is being built.
  ///  * [animation]: The animation for this route's transition. When entering,
  ///    the animation runs forward from 0.0 to 1.0. When exiting, this animation
  ///    runs backwards from 1.0 to 0.0.
  ///  * [secondaryAnimation]: The animation for the route being pushed on top of
  ///    this route. This animation lets this route coordinate with the entrance
  ///    and exit transition of routes pushed on top of this route.
  ///
  /// This method is only called when the route is first built, and rarely
  /// thereafter. In particular, it is not automatically called again when the
  /// route's state changes unless it uses [ModalRoute.of]. For a builder that
  /// is called every time the route's state changes, consider
  /// [buildTransitions]. For widgets that change their behavior when the
  /// route's state changes, consider [ModalRoute.of] to obtain a reference to
  /// the route; this will cause the widget to be rebuilt each time the route
  /// changes state.
  ///
  /// In general, [buildPage] should be used to build the page contents, and
  /// [buildTransitions] for the widgets that change as the page is brought in
  /// and out of view. Avoid using [buildTransitions] for content that never
  /// changes; building such content once from [buildPage] is more efficient.
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation);

  /// Override this method to wrap the [child] with one or more transition
  /// widgets that define how the route arrives on and leaves the screen.
  ///
  /// By default, the child (which contains the widget returned by [buildPage])
  /// is not wrapped in any transition widgets.
  ///
  /// The [buildTransitions] method, in contrast to [buildPage], is called each
  /// time the [Route]'s state changes while it is visible (e.g. if the value of
  /// [canPop] changes on the active route).
  ///
  /// The [buildTransitions] method is typically used to define transitions
  /// that animate the new topmost route's comings and goings. When the
  /// [Navigator] pushes a route on the top of its stack, the new route's
  /// primary [animation] runs from 0.0 to 1.0. When the Navigator pops the
  /// topmost route, e.g. because the use pressed the back button, the
  /// primary animation runs from 1.0 to 0.0.
  ///
  /// {@tool snippet}
  /// The following example uses the primary animation to drive a
  /// [SlideTransition] that translates the top of the new route vertically
  /// from the bottom of the screen when it is pushed on the Navigator's
  /// stack. When the route is popped the SlideTransition translates the
  /// route from the top of the screen back to the bottom.
  ///
  /// We've used [PageRouteBuilder] to demonstrate the [buildTransitions] method
  /// here. The body of an override of the [buildTransitions] method would be
  /// defined in the same way.
  ///
  /// ```dart
  /// PageRouteBuilder<void>(
  ///   pageBuilder: (BuildContext context,
  ///       Animation<double> animation,
  ///       Animation<double> secondaryAnimation,
  ///   ) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: const Text('Hello')),
  ///       body: const Center(
  ///         child: Text('Hello World'),
  ///       ),
  ///     );
  ///   },
  ///   transitionsBuilder: (
  ///       BuildContext context,
  ///       Animation<double> animation,
  ///       Animation<double> secondaryAnimation,
  ///       Widget child,
  ///    ) {
  ///     return SlideTransition(
  ///       position: Tween<Offset>(
  ///         begin: const Offset(0.0, 1.0),
  ///         end: Offset.zero,
  ///       ).animate(animation),
  ///       child: child, // child is the value returned by pageBuilder
  ///     );
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// When the [Navigator] pushes a route on the top of its stack, the
  /// [secondaryAnimation] can be used to define how the route that was on
  /// the top of the stack leaves the screen. Similarly when the topmost route
  /// is popped, the secondaryAnimation can be used to define how the route
  /// below it reappears on the screen. When the Navigator pushes a new route
  /// on the top of its stack, the old topmost route's secondaryAnimation
  /// runs from 0.0 to 1.0. When the Navigator pops the topmost route, the
  /// secondaryAnimation for the route below it runs from 1.0 to 0.0.
  ///
  /// {@tool snippet}
  /// The example below adds a transition that's driven by the
  /// [secondaryAnimation]. When this route disappears because a new route has
  /// been pushed on top of it, it translates in the opposite direction of
  /// the new route. Likewise when the route is exposed because the topmost
  /// route has been popped off.
  ///
  /// ```dart
  /// PageRouteBuilder<void>(
  ///   pageBuilder: (BuildContext context,
  ///       Animation<double> animation,
  ///       Animation<double> secondaryAnimation,
  ///   ) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: const Text('Hello')),
  ///       body: const Center(
  ///         child: Text('Hello World'),
  ///       ),
  ///     );
  ///   },
  ///   transitionsBuilder: (
  ///       BuildContext context,
  ///       Animation<double> animation,
  ///       Animation<double> secondaryAnimation,
  ///       Widget child,
  ///   ) {
  ///     return SlideTransition(
  ///       position: Tween<Offset>(
  ///         begin: const Offset(0.0, 1.0),
  ///         end: Offset.zero,
  ///       ).animate(animation),
  ///       child: SlideTransition(
  ///         position: Tween<Offset>(
  ///           begin: Offset.zero,
  ///           end: const Offset(0.0, 1.0),
  ///         ).animate(secondaryAnimation),
  ///         child: child,
  ///       ),
  ///      );
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// In practice the `secondaryAnimation` is used pretty rarely.
  ///
  /// The arguments to this method are as follows:
  ///
  ///  * `context`: The context in which the route is being built.
  ///  * [animation]: When the [Navigator] pushes a route on the top of its stack,
  ///    the new route's primary [animation] runs from 0.0 to 1.0. When the [Navigator]
  ///    pops the topmost route this animation runs from 1.0 to 0.0.
  ///  * [secondaryAnimation]: When the Navigator pushes a new route
  ///    on the top of its stack, the old topmost route's [secondaryAnimation]
  ///    runs from 0.0 to 1.0. When the [Navigator] pops the topmost route, the
  ///    [secondaryAnimation] for the route below it runs from 1.0 to 0.0.
  ///  * `child`, the page contents, as returned by [buildPage].
  ///
  /// See also:
  ///
  ///  * [buildPage], which is used to describe the actual contents of the page,
  ///    and whose result is passed to the `child` argument of this method.
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }

  @override
  void install() {
    super.install();
    _animationProxy = ProxyAnimation(super.animation);
    _secondaryAnimationProxy = ProxyAnimation(super.secondaryAnimation);
  }

  @override
  TickerFuture didPush() {
    if (_scopeKey.currentState != null && navigator!.widget.requestFocus) {
      navigator!.focusNode.enclosingScope?.setFirstFocus(_scopeKey.currentState!.focusScopeNode);
    }
    return super.didPush();
  }

  @override
  void didAdd() {
    if (_scopeKey.currentState != null && navigator!.widget.requestFocus) {
      navigator!.focusNode.enclosingScope?.setFirstFocus(_scopeKey.currentState!.focusScopeNode);
    }
    super.didAdd();
  }

  /// True if a back gesture (iOS-style back swipe or Android predictive back)
  /// is currently underway for this route.
  ///
  /// See also:
  ///
  ///  * [popGestureEnabled], which returns true if a user-triggered pop gesture
  ///    would be allowed.
  bool get popGestureInProgress => navigator!.userGestureInProgress;

  /// Whether a pop gesture can be started by the user for this route.
  ///
  /// Returns true if the user can edge-swipe to a previous route.
  ///
  /// This should only be used between frames, not during build.
  @override
  bool get popGestureEnabled {
    // If there's nothing to go back to, then obviously we don't support
    // the back gesture.
    if (isFirst) {
      return false;
    }
    // If the route wouldn't actually pop if we popped it, then the gesture
    // would be really confusing (or would skip internal routes), so disallow it.
    if (willHandlePopInternally) {
      return false;
    }
    // If attempts to dismiss this route might be vetoed such as in a page
    // with forms, then do not allow the user to dismiss the route with a swipe.
    if (hasScopedWillPopCallback ||
        popDisposition == RoutePopDisposition.doNotPop) {
      return false;
    }
    // If we're in an animation already, we cannot be manually swiped.
    if (animation!.status != AnimationStatus.completed) {
      return false;
    }
    // If we're being popped into, we also cannot be swiped until the pop above
    // it completes. This translates to our secondary animation being
    // dismissed.
    if (secondaryAnimation!.status != AnimationStatus.dismissed) {
      return false;
    }
    // If we're in a gesture already, we cannot start another.
    if (popGestureInProgress) {
      return false;
    }

    // Looks like a back gesture would be welcome!
    return true;
  }

  // The API for _ModalScope and HeroController

  /// Whether this route is currently offstage.
  ///
  /// On the first frame of a route's entrance transition, the route is built
  /// [Offstage] using an animation progress of 1.0. The route is invisible and
  /// non-interactive, but each widget has its final size and position. This
  /// mechanism lets the [HeroController] determine the final local of any hero
  /// widgets being animated as part of the transition.
  ///
  /// The modal barrier, if any, is not rendered if [offstage] is true (see
  /// [barrierColor]).
  ///
  /// Whenever this changes value, [changedInternalState] is called.
  bool get offstage => _offstage;
  bool _offstage = false;
  set offstage(bool value) {
    if (_offstage == value) {
      return;
    }
    setState(() {
      _offstage = value;
    });
    _animationProxy!.parent = _offstage ? kAlwaysCompleteAnimation : super.animation;
    _secondaryAnimationProxy!.parent = _offstage ? kAlwaysDismissedAnimation : super.secondaryAnimation;
    changedInternalState();
  }

  /// The build context for the subtree containing the primary content of this route.
  BuildContext? get subtreeContext => _subtreeKey.currentContext;

  @override
  Animation<double>? get animation => _animationProxy;
  ProxyAnimation? _animationProxy;

  @override
  Animation<double>? get secondaryAnimation => _secondaryAnimationProxy;
  ProxyAnimation? _secondaryAnimationProxy;

  final List<WillPopCallback> _willPopCallbacks = <WillPopCallback>[];

  final Set<PopEntry> _popEntries = <PopEntry>{};

  /// Returns [RoutePopDisposition.doNotPop] if any of callbacks added with
  /// [addScopedWillPopCallback] returns either false or null. If they all
  /// return true, the base [Route.willPop]'s result will be returned. The
  /// callbacks will be called in the order they were added, and will only be
  /// called if all previous callbacks returned true.
  ///
  /// Typically this method is not overridden because applications usually
  /// don't create modal routes directly, they use higher level primitives
  /// like [showDialog]. The scoped [WillPopCallback] list makes it possible
  /// for ModalRoute descendants to collectively define the value of [willPop].
  ///
  /// See also:
  ///
  ///  * [Form], which provides an `onWillPop` callback that uses this mechanism.
  ///  * [addScopedWillPopCallback], which adds a callback to the list this
  ///    method checks.
  ///  * [removeScopedWillPopCallback], which removes a callback from the list
  ///    this method checks.
  @Deprecated(
    'Use popDisposition instead. '
    'This feature was deprecated after v3.12.0-1.0.pre.',
  )
  @override
  Future<RoutePopDisposition> willPop() async {
    final _ModalScopeState<T>? scope = _scopeKey.currentState;
    assert(scope != null);
    for (final WillPopCallback callback in List<WillPopCallback>.of(_willPopCallbacks)) {
      if (!await callback()) {
        return RoutePopDisposition.doNotPop;
      }
    }
    return super.willPop();
  }

  /// Returns [RoutePopDisposition.doNotPop] if any of the [PopEntry] instances
  /// registered with [registerPopEntry] have [PopEntry.canPopNotifier] set to
  /// false.
  ///
  /// Typically this method is not overridden because applications usually
  /// don't create modal routes directly, they use higher level primitives
  /// like [showDialog]. The scoped [PopEntry] list makes it possible for
  /// ModalRoute descendants to collectively define the value of
  /// [popDisposition].
  ///
  /// See also:
  ///
  ///  * [Form], which provides an `onPopInvoked` callback that is similar.
  ///  * [registerPopEntry], which adds a [PopEntry] to the list this method
  ///    checks.
  ///  * [unregisterPopEntry], which removes a [PopEntry] from the list this
  ///    method checks.
  @override
  RoutePopDisposition get popDisposition {
    for (final PopEntry popEntry in _popEntries) {
      if (!popEntry.canPopNotifier.value) {
        return RoutePopDisposition.doNotPop;
      }
    }

    return super.popDisposition;
  }

  @override
  void onPopInvoked(bool didPop) {
    for (final PopEntry popEntry in _popEntries) {
      popEntry.onPopInvoked?.call(didPop);
    }
  }

  /// Enables this route to veto attempts by the user to dismiss it.
  ///
  /// This callback runs asynchronously and it's possible that it will be called
  /// after its route has been disposed. The callback should check [State.mounted]
  /// before doing anything.
  ///
  /// A typical application of this callback would be to warn the user about
  /// unsaved [Form] data if the user attempts to back out of the form. In that
  /// case, use the [Form.onWillPop] property to register the callback.
  ///
  /// See also:
  ///
  ///  * [WillPopScope], which manages the registration and unregistration
  ///    process automatically.
  ///  * [Form], which provides an `onWillPop` callback that uses this mechanism.
  ///  * [willPop], which runs the callbacks added with this method.
  ///  * [removeScopedWillPopCallback], which removes a callback from the list
  ///    that [willPop] checks.
  @Deprecated(
    'Use registerPopEntry or PopScope instead. '
    'This feature was deprecated after v3.12.0-1.0.pre.',
  )
  void addScopedWillPopCallback(WillPopCallback callback) {
    assert(_scopeKey.currentState != null, 'Tried to add a willPop callback to a route that is not currently in the tree.');
    _willPopCallbacks.add(callback);
  }

  /// Remove one of the callbacks run by [willPop].
  ///
  /// See also:
  ///
  ///  * [Form], which provides an `onWillPop` callback that uses this mechanism.
  ///  * [addScopedWillPopCallback], which adds callback to the list
  ///    checked by [willPop].
  @Deprecated(
    'Use unregisterPopEntry or PopScope instead. '
    'This feature was deprecated after v3.12.0-1.0.pre.',
  )
  void removeScopedWillPopCallback(WillPopCallback callback) {
    assert(_scopeKey.currentState != null, 'Tried to remove a willPop callback from a route that is not currently in the tree.');
    _willPopCallbacks.remove(callback);
  }

  /// Registers the existence of a [PopEntry] in the route.
  ///
  /// [PopEntry] instances registered in this way will have their
  /// [PopEntry.onPopInvoked] callbacks called when a route is popped or a pop
  /// is attempted. They will also be able to block pop operations with
  /// [PopEntry.canPopNotifier] through this route's [popDisposition] method.
  ///
  /// See also:
  ///
  ///  * [unregisterPopEntry], which performs the opposite operation.
  void registerPopEntry(PopEntry popEntry) {
    _popEntries.add(popEntry);
    popEntry.canPopNotifier.addListener(_handlePopEntryChange);
    _handlePopEntryChange();
  }

  /// Unregisters a [PopEntry] in the route's widget subtree.
  ///
  /// See also:
  ///
  ///  * [registerPopEntry], which performs the opposite operation.
  void unregisterPopEntry(PopEntry popEntry) {
    _popEntries.remove(popEntry);
    popEntry.canPopNotifier.removeListener(_handlePopEntryChange);
    _handlePopEntryChange();
  }

  void _handlePopEntryChange() {
    if (!isCurrent) {
      return;
    }
    final NavigationNotification notification = NavigationNotification(
      // canPop indicates that the originator of the Notification can handle a
      // pop. In the case of PopScope, it handles pops when canPop is
      // false. Hence the seemingly backward logic here.
      canHandlePop: popDisposition == RoutePopDisposition.doNotPop,
    );
    // Avoid dispatching a notification in the middle of a build.
    switch (SchedulerBinding.instance.schedulerPhase) {
      case SchedulerPhase.postFrameCallbacks:
        notification.dispatch(subtreeContext);
      case SchedulerPhase.idle:
      case SchedulerPhase.midFrameMicrotasks:
      case SchedulerPhase.persistentCallbacks:
      case SchedulerPhase.transientCallbacks:
        SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
          if (!(subtreeContext?.mounted ?? false)) {
            return;
          }
          notification.dispatch(subtreeContext);
        }, debugLabel: 'ModalRoute.dispatchNotification');
    }
  }

  /// True if one or more [WillPopCallback] callbacks exist.
  ///
  /// This method is used to disable the horizontal swipe pop gesture supported
  /// by [MaterialPageRoute] for [TargetPlatform.iOS] and
  /// [TargetPlatform.macOS]. If a pop might be vetoed, then the back gesture is
  /// disabled.
  ///
  /// The [buildTransitions] method will not be called again if this changes,
  /// since it can change during the build as descendants of the route add or
  /// remove callbacks.
  ///
  /// See also:
  ///
  ///  * [addScopedWillPopCallback], which adds a callback.
  ///  * [removeScopedWillPopCallback], which removes a callback.
  ///  * [willHandlePopInternally], which reports on another reason why
  ///    a pop might be vetoed.
  @Deprecated(
    'Use popDisposition instead. '
    'This feature was deprecated after v3.12.0-1.0.pre.',
  )
  @protected
  bool get hasScopedWillPopCallback {
    return _willPopCallbacks.isNotEmpty;
  }

  @override
  void didChangePrevious(Route<dynamic>? previousRoute) {
    super.didChangePrevious(previousRoute);
    changedInternalState();
  }

  @override
  void didChangeNext(Route<dynamic>? nextRoute) {
    super.didChangeNext(nextRoute);
    changedInternalState();
  }

  @override
  void didPopNext(Route<dynamic> nextRoute) {
    super.didPopNext(nextRoute);
    changedInternalState();
  }

  @override
  void changedInternalState() {
    super.changedInternalState();
    // No need to mark dirty if this method is called during build phase.
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.persistentCallbacks) {
      setState(() { /* internal state already changed */ });
    }
    _modalScope.maintainState = true;
  }

  @override
  void changedExternalState() {
    super.changedExternalState();
    
    if (_scopeKey.currentState != null) {
      _scopeKey.currentState!._forceRebuildPage();
    }
  }

  /// Whether this route can be popped.
  ///
  /// A route can be popped if there is at least one active route below it, or
  /// if [willHandlePopInternally] returns true.
  ///
  /// When this changes, if the route is visible, the route will
  /// rebuild, and any widgets that used [ModalRoute.of] will be
  /// notified.
  bool get canPop => hasActiveRouteBelow || willHandlePopInternally;

  /// Whether an [AppBar] in the route should automatically add a back button or
  /// close button.
  ///
  /// This getter returns true if there is at least one active route below it,
  /// or there is at least one [LocalHistoryEntry] with [impliesAppBarDismissal]
  /// set to true
  bool get impliesAppBarDismissal => hasActiveRouteBelow;

  // Internals

  final GlobalKey<_ModalScopeState<T>> _scopeKey = GlobalKey<_ModalScopeState<T>>();
  final GlobalKey _subtreeKey = GlobalKey();
  final PageStorageBucket _storageBucket = PageStorageBucket();

  // We cache the part of the modal scope that doesn't change from frame to
  // frame so that we minimize the amount of building that happens.
  Widget? _modalScopeCache;

  // one of the builders
  Widget _buildModalScope(BuildContext context) {
    // To be sorted before the _modalBarrier.
    return _modalScopeCache ??= Semantics(
      sortKey: const OrdinalSortKey(0.0),
      child: _ModalScope<T>(
        key: _scopeKey,
        route: this,
        // _ModalScope calls buildTransitions() and buildChild(), defined above
      ),
    );
  }

  late OverlayEntry _modalScope;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      _modalScope = OverlayEntry(builder: _buildModalScope, maintainState: true, canSizeOverlay: opaque),
    ];
  }

  @override
  String toString() => '${objectRuntimeType(this, 'ModalRoute')}($settings, animation)';
}
