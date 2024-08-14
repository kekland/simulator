import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simulator/src/widgets/windows/root_page.dart';
import 'package:simulator/src/widgets/windows/window_route.dart';

final windowRootNavigatorStateKey = GlobalKey<WindowRootNavigatorState>();
final _windowRootNavigatorKey = GlobalKey<NavigatorState>();

class WindowRootNavigator extends StatefulWidget {
  WindowRootNavigator() : super(key: windowRootNavigatorStateKey);

  @override
  State<WindowRootNavigator> createState() => WindowRootNavigatorState();
}

class WindowRootNavigatorState extends State<WindowRootNavigator> {
  final _pages = <Page>[];
  Offset? _pointerPosition;

  Future<T?> pushWindow<T>(
    WidgetBuilder builder, {
    Widget? title,
    Widget? icon,
  }) async {
    final pageKey = UniqueKey();
    final completer = Completer<T?>();

    final page = WindowPage<T>(
      key: pageKey,
      onInteractedWith: () {
        // Move the page to the front
        final index = _pages.indexWhere((element) => element.key == pageKey);
        if (index != -1) {
          final page = _pages.removeAt(index);
          _pages.add(page);
          setState(() {});
        }
      },
      onPop: (result) {
        completer.complete(result);
        _pages.removeWhere((element) => element.key == pageKey);
        setState(() {});
      },
      pointerOffset: _pointerPosition,
      initialRect: Rect.fromCenter(
        center: _pointerPosition!,
        width: 400,
        height: 640,
      ),
      title: title,
      icon: icon,
      builder: builder,
    );

    _pages.add(page);
    setState(() {});

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerHover: (event) {
        _pointerPosition = event.localPosition;
      },
      child: Navigator(
        key: _windowRootNavigatorKey,
        onPopPage: (route, result) {
          return route.didPop(result);
        },
        pages: [
          const WindowsNavigatorRootPage(),
          ..._pages,
        ],
      ),
    );
  }
}
