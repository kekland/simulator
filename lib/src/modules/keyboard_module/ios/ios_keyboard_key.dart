import 'package:flutter/material.dart';
import 'package:simulator/src/modules/keyboard_module/ios/ios_keyboard_theme.dart';

const _keySize = Size.fromHeight(43);
const _characterKeySize = Size(33, 43);
const _keyRadius = Radius.circular(5.0);

class IOSKeyboardKey extends StatelessWidget {
  const IOSKeyboardKey({
    super.key,
    required this.child,
    this.onTap,
    this.foregroundColor,
    this.size = _keySize,
  });

  IOSKeyboardKey.character(
    String character, {
    super.key,
    this.onTap,
    this.size = _characterKeySize,
    this.foregroundColor,
  }) : child = Transform.translate(
          offset: const Offset(0, -1),
          child: Text(character),
        );

  final Size size;
  final Widget child;
  final Color? foregroundColor;
  final VoidCallback? onTap;

  static double get width => _characterKeySize.width;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox.fromSize(
          size: size,
          child: Container(
            height: size.height,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(_keyRadius),
              color: IOSKeyboardTheme.of(context).keyShadowColor,
            ),
            child: Container(
              height: size.height - 1,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(_keyRadius),
                color: foregroundColor ?? IOSKeyboardTheme.of(context).keyColor,
              ),
              child: Center(
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    fontSize: 24.0,
                    height: 1.0,
                    color: IOSKeyboardTheme.of(context).keyForegroundColor,
                    fontWeight: FontWeight.w300,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
