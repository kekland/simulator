import 'package:flutter/material.dart';
import 'package:simulator/src/widgets/windows/transparent_route.dart';

class WindowsNavigatorRootPage extends Page {
  const WindowsNavigatorRootPage();

  @override
  Route createRoute(BuildContext context) {
    return _TransparentRoute(settings: this);
  }
}

class _TransparentRoute extends TransparentRoute {
  _TransparentRoute({super.settings});

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return const IgnorePointer();
  }

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration.zero;
}
