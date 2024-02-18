import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:simulator/src/modules/keyboard_module/ios/ios_keyboard_key.dart';
import 'package:simulator/src/modules/keyboard_module/ios/ios_keyboard_theme.dart';
import 'package:simulator/src/platform_channels/system_text_input_channel_interceptor.dart';
import 'package:simulator/src/utils/utils.dart';

class IOSEnglishKeyboard extends StatelessWidget
    implements PreferredSizeWidget {
  const IOSEnglishKeyboard({super.key});

  void _onCharacterTap(String character) {
    final eventData = RawKeyEventDataIos(
      characters: character,
      charactersIgnoringModifiers: character,
      keyCode: 0,
      modifiers: 0,
    );

    SystemTextInputChannelInterceptor.instance.activeIME.handleKeyEvent(
      RawKeyDownEvent(
        data: eventData,
        character: character,
        repeat: false,
      ),
    );

    SystemTextInputChannelInterceptor.instance.activeIME.handleKeyEvent(
      RawKeyUpEvent(
        data: eventData,
        character: character,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = IOSKeyboardTheme.of(context);
    const gap = 6.0;

    return SizedBox.fromSize(
      size: preferredSize,
      child: Column(
        children: [
          _IOSKeyboardKeyRow(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            characters: const [
              'q',
              'w',
              'e',
              'r',
              't',
              'y',
              'u',
              'i',
              'o',
              'p'
            ],
            gap: gap,
            onCharacterTap: _onCharacterTap,
          ),
          const SizedBox(height: 11.0),
          _IOSKeyboardKeyRow(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            characters: const ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
            gap: gap,
            onCharacterTap: _onCharacterTap,
          ),
          const SizedBox(height: 11.0),
          _IOSKeyboardKeyRow(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            characters: const ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
            gap: gap,
            onCharacterTap: _onCharacterTap,
            leading: [
              IOSKeyboardKey(
                size: const Size(44, 43),
                foregroundColor: theme.specialKeyColor,
                onTap: () {},
                child: Icon(
                  CupertinoIcons.shift,
                  size: 20.0,
                  color: theme.keyForegroundColor,
                ),
              ),
            ],
            trailing: [
              IOSKeyboardKey(
                size: const Size(44, 43),
                foregroundColor: theme.specialKeyColor,
                onTap: () {
                  SystemTextInputChannelInterceptor.instance.activeIME
                      .handleBackspacePress();
                },
                child: Icon(
                  CupertinoIcons.delete_left,
                  size: 20.0,
                  color: theme.keyForegroundColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11.0),
          _IOSKeyboardKeyRow(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            characters: const [],
            gap: gap,
            onCharacterTap: _onCharacterTap,
            leading: [
              IOSKeyboardKey(
                size: const Size(42, 43),
                foregroundColor: theme.specialKeyColor,
                child: Icon(
                  CupertinoIcons.textformat_123,
                  size: 20.0,
                  color: theme.keyForegroundColor,
                ),
              ),
              const SizedBox(width: gap),
              IOSKeyboardKey(
                size: const Size(42, 43),
                foregroundColor: theme.specialKeyColor,
                // TODO: Insert the proper icon here
                child: Icon(
                  CupertinoIcons.smiley,
                  size: 20.0,
                  color: theme.keyForegroundColor,
                ),
              ),
              const SizedBox(width: gap),
              Expanded(
                child: IOSKeyboardKey(
                  onTap: () {
                    _onCharacterTap(' ');
                  },
                  child: const Text(
                    'space',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: gap),
            ],
            trailing: [
              IOSKeyboardKey(
                size: const Size(91, 43),
                foregroundColor: theme.specialKeyColor,
                onTap: () {
                  SystemTextInputChannelInterceptor.instance.activeIME
                      .handleNewlinePress();
                },
                child: const Text(
                  'return',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(205);
}

class _IOSKeyboardKeyRow extends StatelessWidget {
  const _IOSKeyboardKeyRow({
    required this.padding,
    required this.characters,
    required this.onCharacterTap,
    required this.gap,
    this.leading = const [],
    this.trailing = const [],
  });

  final EdgeInsets padding;
  final List<String> characters;
  final List<Widget> leading;
  final List<Widget> trailing;
  final ValueChanged<String> onCharacterTap;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var width = constraints.maxWidth;
        width -= padding.horizontal;

        double? gap;

        if (leading.isNotEmpty || trailing.isNotEmpty) {
          gap = this.gap;
        } else {
          final charactersWidth = IOSKeyboardKey.width * characters.length;
          gap = (width - charactersWidth) / (characters.length - 1);

          if (gap > this.gap) {
            gap = this.gap;
          }
        }

        return Padding(
          padding: padding,
          child: Row(
            children: [
              ...leading,
              if (characters.isNotEmpty) const Spacer(),
              ...characters
                  .map<Widget>(
                    (v) => IOSKeyboardKey.character(
                      v,
                      onTap: () => onCharacterTap(v),
                    ),
                  )
                  .intersperse(SizedBox(width: gap))
                  .toList(),
              if (characters.isNotEmpty) const Spacer(),
              ...trailing,
            ],
          ),
        );
      },
    );
  }
}
