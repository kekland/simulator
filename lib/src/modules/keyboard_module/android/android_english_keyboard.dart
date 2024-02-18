import 'package:flutter/material.dart';
import 'package:simulator/src/modules/keyboard_module/android/android_keyboard_key.dart';
import 'package:simulator/src/utils/utils.dart';

class AndroidEnglishKeyboard extends StatelessWidget
    implements PreferredSizeWidget {
  const AndroidEnglishKeyboard({super.key});

  static const double columnGap = 21 / 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12 / 3),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final theme = Theme.of(context);

          const keyGap = 12 / 3;

          final keyWidth = (constraints.maxWidth - keyGap * 9) / 10;
          final shiftWidth =
              (constraints.maxWidth - keyWidth * 7 - keyGap * 8) / 2;

          return Column(
            children: [
              _AndroidKeyboardRow(
                characters: const [
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  '0',
                ],
                gap: keyGap,
                keyWidth: keyWidth,
                isNumberRow: true,
              ),
              const SizedBox(height: columnGap),
              _AndroidKeyboardRow(
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
                  'p',
                ],
                gap: keyGap,
                keyWidth: keyWidth,
              ),
              const SizedBox(height: columnGap),
              _AndroidKeyboardRow(
                characters: const [
                  'a',
                  's',
                  'd',
                  'f',
                  'g',
                  'h',
                  'j',
                  'k',
                  'l',
                ],
                gap: keyGap,
                keyWidth: keyWidth,
              ),
              const SizedBox(height: columnGap),
              _AndroidKeyboardRow(
                characters: const [
                  'z',
                  'x',
                  'c',
                  'v',
                  'b',
                  'n',
                  'm',
                ],
                gap: keyGap,
                keyWidth: keyWidth,
                leading: const _AndroidKeyboardSpecialKey(
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    size: 20.0,
                  ),
                ),
                trailing: const _AndroidKeyboardSpecialKey(
                  child: Icon(
                    Icons.backspace_rounded,
                    size: 20.0,
                  ),
                ),
              ),
              const SizedBox(height: columnGap),
              Row(
                children: [
                  SizedBox(
                    width: shiftWidth,
                    height: AndroidKeyboardKey.letterKeyHeight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        elevation: 0.0,
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: const Text('?123'),
                    ),
                  ),
                  const SizedBox(width: keyGap),
                  _AndroidKeyboardSpecialKey(
                    width: keyWidth,
                    child: const Text(','),
                  ),
                  const SizedBox(width: keyGap),
                  AndroidKeyboardKey(
                    width: keyWidth,
                    child: Icon(
                      Icons.language_rounded,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(width: keyGap),
                  AndroidKeyboardKey(
                    width: keyWidth * 4 + keyGap * 3,
                    child: const Text(
                      'English',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: keyGap),
                  _AndroidKeyboardSpecialKey(
                    width: keyWidth,
                    child: const Text('.'),
                  ),
                  const SizedBox(width: keyGap),
                  SizedBox(
                    width: shiftWidth,
                    height: AndroidKeyboardKey.letterKeyHeight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        elevation: 0.0,
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: const Icon(Icons.send_rounded, size: 20.0),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
        AndroidKeyboardKey.numberKeyHeight +
            AndroidKeyboardKey.letterKeyHeight * 4 +
            columnGap * 4,
      );
}

class _AndroidKeyboardRow extends StatelessWidget {
  const _AndroidKeyboardRow({
    required this.characters,
    required this.gap,
    required this.keyWidth,
    this.isNumberRow = false,
    this.leading,
    this.trailing,
  });

  final List<String> characters;
  final double gap;
  final double keyWidth;
  final bool isNumberRow;

  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          SizedBox(width: gap),
        ] else
          const Spacer(),
        ...characters
            .map<Widget>(
              (v) => AndroidKeyboardKey(
                width: keyWidth,
                isNumberKey: isNumberRow,
                child: Text(v),
              ),
            )
            .intersperse(SizedBox(width: gap)),
        if (trailing != null) ...[
          SizedBox(width: gap),
          trailing!,
        ] else
          const Spacer(),
      ],
    );
  }
}

class _AndroidKeyboardSpecialKey extends StatelessWidget {
  const _AndroidKeyboardSpecialKey({
    required this.child,
    this.width,
  });

  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final child = Material(
      type: MaterialType.card,
      color: theme.colorScheme.primary.withOpacity(0.5),
      borderRadius: BorderRadius.circular(6.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          height: AndroidKeyboardKey.letterKeyHeight,
          child: Center(
            child: IconTheme(
              data: IconThemeData(
                color: theme.colorScheme.onPrimary,
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 20,
                ),
                child: this.child,
              ),
            ),
          ),
        ),
      ),
    );

    if (width != null) {
      return SizedBox(
        width: width,
        child: child,
      );
    }

    return Expanded(child: child);
  }
}
