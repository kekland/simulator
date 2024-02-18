import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:simulator/src/modules/keyboard_module/ios/ios_keyboard_theme.dart';

class IOSKeyboardTrailing extends StatelessWidget
    implements PreferredSizeWidget {
  const IOSKeyboardTrailing({
    super.key,
    required this.height,
  });

  final double height;

  static double computeHeight(BuildContext context) {
    final viewPadding = MediaQuery.of(context).viewPadding;
    return max(viewPadding.bottom, 16.0) + 44.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = IOSKeyboardTheme.of(context);

    return SizedBox(
      height: height,
      child: Row(
        children: [
          SizedBox.square(
            dimension: height,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: Icon(
                CupertinoIcons.globe,
                color: theme.trailingForegroundColor,
                size: 27.0,
              ),
            ),
          ),
          const Spacer(),
          SizedBox.square(
            dimension: height,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: Icon(
                CupertinoIcons.mic,
                color: theme.trailingForegroundColor,
                size: 27.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
