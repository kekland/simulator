import 'package:flutter/material.dart';

class AndroidKeyboardKey extends StatelessWidget
    implements PreferredSizeWidget {
  const AndroidKeyboardKey({
    super.key,
    required this.width,
    required this.child,
    this.isNumberKey = false,
  });

  final double width;
  final Widget child;

  final bool isNumberKey;

  static const double numberKeyHeight = 114 / 3;
  static const double letterKeyHeight = 121 / 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      type: MaterialType.card,
      color: theme.brightness == Brightness.light
          ? Colors.white.withOpacity(0.5)
          : Colors.black.withOpacity(0.5),
      borderRadius: BorderRadius.circular(6.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: SizedBox.fromSize(
          size: preferredSize,
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(
                fontFamily: 'Roboto',
                color: theme.colorScheme.onPrimaryContainer,
                fontSize: 20,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(
        width,
        isNumberKey ? numberKeyHeight : letterKeyHeight,
      );
}
