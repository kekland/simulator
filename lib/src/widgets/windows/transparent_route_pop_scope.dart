import 'package:flutter/material.dart';
import 'package:simulator/src/widgets/windows/transparent_route.dart';

class TransparentRoutePopScope extends StatefulWidget {
  const TransparentRoutePopScope({
    super.key,
    required this.child,
    this.canPop = true,
    this.onPopInvoked,
  });

  final Widget child;
  final PopInvokedWithResultCallback? onPopInvoked;
  final bool canPop;

  @override
  State<TransparentRoutePopScope> createState() =>
      _TransparentRoutePopScopeState();
}

class _TransparentRoutePopScopeState<T> extends State<TransparentRoutePopScope>
    implements PopEntry<T> {
  TransparentRoute<dynamic>? _route;

  @override
  void onPopInvoked(bool didPop) {
    widget.onPopInvoked?.call(didPop, null);
  }

  @override
  void onPopInvokedWithResult(bool didPop, T? result) {
    widget.onPopInvoked?.call(didPop, result);
  }

  @override
  late final ValueNotifier<bool> canPopNotifier;

  @override
  void initState() {
    super.initState();
    canPopNotifier = ValueNotifier<bool>(widget.canPop);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final TransparentRoute<dynamic>? nextRoute = TransparentRoute.of(context);
    if (nextRoute != _route) {
      _route?.unregisterPopEntry(this);
      _route = nextRoute;
      _route?.registerPopEntry(this);
    }
  }

  @override
  void didUpdateWidget(TransparentRoutePopScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    canPopNotifier.value = widget.canPop;
  }

  @override
  void dispose() {
    _route?.unregisterPopEntry(this);
    canPopNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
