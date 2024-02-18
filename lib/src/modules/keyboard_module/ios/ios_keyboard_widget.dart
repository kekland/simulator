import 'package:flutter/material.dart';
import 'package:simulator/src/modules/keyboard_module/ios/ios_english_keyboard.dart';
import 'package:simulator/src/modules/keyboard_module/ios/ios_keyboard_animation.dart';
import 'package:simulator/src/modules/keyboard_module/ios/ios_keyboard_suggestions_row.dart';
import 'package:simulator/src/modules/keyboard_module/ios/ios_keyboard_theme.dart';
import 'package:simulator/src/modules/keyboard_module/ios/ios_keyboard_trailing.dart';
import 'package:simulator/src/modules/keyboard_module/keyboard_theme_provider.dart';
import 'package:simulator/src/modules/keyboard_module/keyboard_widget.dart';

class IOSKeyboardWidget extends StatelessWidget {
  const IOSKeyboardWidget({
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
        const suggestionsRow = IOSKeyboardSuggestionsRow();
        const keys = IOSEnglishKeyboard();
        final trailing = IOSKeyboardTrailing(
          height: IOSKeyboardTrailing.computeHeight(context),
        );

        final keyboard = Column(
          children: [
            suggestionsRow,
            const SizedBox(height: 2.0),
            keys,
            trailing,
          ],
        );

        final height = suggestionsRow.preferredSize.height +
            2.0 +
            keys.preferredSize.height +
            trailing.preferredSize.height;

        return KeyboardWidget(
          animationValue: value,
          keyboardHeight: height,
          keyboard: KeyboardThemeProvider(
            child: Builder(builder: (context) {
              final inherited = InheritedKeyboardWidget.of(context);

              final theme = inherited.brightness == Brightness.dark
                  ? IOSKeyboardTheme.dark
                  : IOSKeyboardTheme.light;

              return IOSInheritedKeyboardWidget(
                theme: theme,
                ime: inherited.ime,
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    color: theme.suggestionsForegroundColor,
                  ),
                  child: Container(
                    color: theme.keyboardBackgroundColor,
                    child: keyboard,
                  ),
                ),
              );
            }),
          ),
          child: child,
        );
      },
    );
  }
}
