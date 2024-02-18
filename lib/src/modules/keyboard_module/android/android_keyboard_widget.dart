import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simulator/src/modules/keyboard_module/android/android_english_keyboard.dart';
import 'package:simulator/src/modules/keyboard_module/android/android_keyboard_theme_provider.dart';
import 'package:simulator/src/modules/keyboard_module/android/android_keyboard_top_row.dart';
import 'package:simulator/src/modules/keyboard_module/ios/ios_keyboard_animation.dart';
import 'package:simulator/src/modules/keyboard_module/keyboard_widget.dart';
import 'package:simulator/src/utils/utils.dart';

class AndroidKeyboardWidget extends StatelessWidget {
  const AndroidKeyboardWidget({
    super.key,
    required this.isVisible,
    required this.child,
  });

  final bool isVisible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IOSKeyboardAnimatedBuilder(
      isVisible: isVisible,
      builder: (context, value) {
        final bottomPadding =
            max(MediaQuery.of(context).viewPadding.bottom, 16.0);

        const topRow = AndroidKeyboardTopRow();
        const englishKeyboard = AndroidEnglishKeyboard();

        final height = topRow.preferredSize.height +
            englishKeyboard.preferredSize.height +
            bottomPadding +
            24 / 3;

        final keyboard = AndroidKeyboardThemeProvider(
          child: Builder(
            builder: (context) {
              final theme = Theme.of(context);

              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  systemNavigationBarColor:
                      theme.colorScheme.secondaryContainer.withOpacity(0.0),
                  systemNavigationBarIconBrightness: theme.brightness.inverse,
                ),
                child: Material(
                  type: MaterialType.card,
                  color: theme.colorScheme.secondaryContainer,
                  elevation: 4.0,
                  child: Column(
                    children: [
                      const AndroidKeyboardTopRow(),
                      const SizedBox(height: 24 / 3),
                      const AndroidEnglishKeyboard(),
                      SizedBox(height: bottomPadding),
                    ],
                  ),
                ),
              );
            },
          ),
        );

        return KeyboardWidget(
          animationValue: value,
          keyboardHeight: height,
          keyboard: keyboard,
          child: child,
        );
      },
    );
  }
}
