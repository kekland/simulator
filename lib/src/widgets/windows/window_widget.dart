import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simulator/src/widgets/material_wrapper.dart';

class WindowWidget extends StatelessWidget {
  const WindowWidget({
    super.key,
    required this.child,
    this.icon,
    this.title,
    this.onMinimize,
    this.onMaximize,
  });

  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Widget? icon;
  final Widget? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialWrapper(
      wrapWithNavigator: false,
      child: Builder(builder: (context) {
        final theme = Theme.of(context);

        return Card(
          elevation: 8.0,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Material(
                child: InkWell(
                  onTap: onMaximize ?? onMinimize,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          icon!,
                          const SizedBox(width: 16.0),
                        ],
                        Flexible(
                          child: DefaultTextStyle(
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            child: title ?? const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      if (onMinimize != null)
                        IconButton(
                          icon: const Icon(Icons.minimize_rounded),
                          onPressed: onMinimize,
                        ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => OverflowBox(
                    alignment: Alignment.topLeft,
                    minWidth: 400.0,
                    maxWidth: max(400.0, constraints.maxWidth),
                    child: SingleChildScrollView(
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class MinimizedWindowWidget extends StatelessWidget {
  const MinimizedWindowWidget(
      {super.key, required this.onMaximize, this.title});

  final VoidCallback onMaximize;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return MaterialWrapper(
      wrapWithNavigator: false,
      child: Card(
        elevation: 8.0,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onMaximize,
          child: AppBar(
            backgroundColor: Colors.transparent,
            title: title,
            actions: [
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
