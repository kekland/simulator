import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/platform_channels/system_text_input_channel_interceptor.dart';

class KeyboardIMEHandler extends StatefulWidget {
  const KeyboardIMEHandler({
    super.key,
    required this.child,
  });

  static KeyboardIMEHandlerState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<KeyboardIMEHandlerState>();
  }

  static KeyboardIMEHandlerState of(BuildContext context) => maybeOf(context)!;

  static void handleCharacter(BuildContext context, String character) {
    of(context).handleCharacter(character);
  }

  final Widget child;

  @override
  State<KeyboardIMEHandler> createState() => KeyboardIMEHandlerState();
}

class KeyboardIMEHandlerState extends State<KeyboardIMEHandler> {
  void handleCharacter(String character) {
    SystemTextInputChannelInterceptor.instance.activeIME.handleKeyEvent(
      KeyDownEvent(
        character: character,
        logicalKey: _kSimulatorLogicalKeyMap[character]!,
        physicalKey: _kSimulatorPhysicalKeyMap[character]!,
        timeStamp: Duration.zero,
        synthesized: true,
      ),
    );

    SystemTextInputChannelInterceptor.instance.activeIME.handleKeyEvent(
      KeyUpEvent(
        logicalKey: _kSimulatorLogicalKeyMap[character]!,
        physicalKey: _kSimulatorPhysicalKeyMap[character]!,
        timeStamp: Duration.zero,
        synthesized: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

const _kSimulatorLogicalKeyMap = {
  '1': LogicalKeyboardKey.digit1,
  '2': LogicalKeyboardKey.digit2,
  '3': LogicalKeyboardKey.digit3,
  '4': LogicalKeyboardKey.digit4,
  '5': LogicalKeyboardKey.digit5,
  '6': LogicalKeyboardKey.digit6,
  '7': LogicalKeyboardKey.digit7,
  '8': LogicalKeyboardKey.digit8,
  '9': LogicalKeyboardKey.digit9,
  '0': LogicalKeyboardKey.digit0,
  'q': LogicalKeyboardKey.keyQ,
  'w': LogicalKeyboardKey.keyW,
  'e': LogicalKeyboardKey.keyE,
  'r': LogicalKeyboardKey.keyR,
  't': LogicalKeyboardKey.keyT,
  'y': LogicalKeyboardKey.keyY,
  'u': LogicalKeyboardKey.keyU,
  'i': LogicalKeyboardKey.keyI,
  'o': LogicalKeyboardKey.keyO,
  'p': LogicalKeyboardKey.keyP,
  'a': LogicalKeyboardKey.keyA,
  's': LogicalKeyboardKey.keyS,
  'd': LogicalKeyboardKey.keyD,
  'f': LogicalKeyboardKey.keyF,
  'g': LogicalKeyboardKey.keyG,
  'h': LogicalKeyboardKey.keyH,
  'j': LogicalKeyboardKey.keyJ,
  'k': LogicalKeyboardKey.keyK,
  'l': LogicalKeyboardKey.keyL,
  'z': LogicalKeyboardKey.keyZ,
  'x': LogicalKeyboardKey.keyX,
  'c': LogicalKeyboardKey.keyC,
  'v': LogicalKeyboardKey.keyV,
  'b': LogicalKeyboardKey.keyB,
  'n': LogicalKeyboardKey.keyN,
  'm': LogicalKeyboardKey.keyM,
  '\n': LogicalKeyboardKey.enter,
  '\r': LogicalKeyboardKey.enter,
  ' ': LogicalKeyboardKey.space,
  '.': LogicalKeyboardKey.period,
  ',': LogicalKeyboardKey.comma,
  '\b': LogicalKeyboardKey.backspace,
  '\t': LogicalKeyboardKey.tab,
};

const _kSimulatorPhysicalKeyMap = {
  '1': PhysicalKeyboardKey.digit1,
  '2': PhysicalKeyboardKey.digit2,
  '3': PhysicalKeyboardKey.digit3,
  '4': PhysicalKeyboardKey.digit4,
  '5': PhysicalKeyboardKey.digit5,
  '6': PhysicalKeyboardKey.digit6,
  '7': PhysicalKeyboardKey.digit7,
  '8': PhysicalKeyboardKey.digit8,
  '9': PhysicalKeyboardKey.digit9,
  '0': PhysicalKeyboardKey.digit0,
  'q': PhysicalKeyboardKey.keyQ,
  'w': PhysicalKeyboardKey.keyW,
  'e': PhysicalKeyboardKey.keyE,
  'r': PhysicalKeyboardKey.keyR,
  't': PhysicalKeyboardKey.keyT,
  'y': PhysicalKeyboardKey.keyY,
  'u': PhysicalKeyboardKey.keyU,
  'i': PhysicalKeyboardKey.keyI,
  'o': PhysicalKeyboardKey.keyO,
  'p': PhysicalKeyboardKey.keyP,
  'a': PhysicalKeyboardKey.keyA,
  's': PhysicalKeyboardKey.keyS,
  'd': PhysicalKeyboardKey.keyD,
  'f': PhysicalKeyboardKey.keyF,
  'g': PhysicalKeyboardKey.keyG,
  'h': PhysicalKeyboardKey.keyH,
  'j': PhysicalKeyboardKey.keyJ,
  'k': PhysicalKeyboardKey.keyK,
  'l': PhysicalKeyboardKey.keyL,
  'z': PhysicalKeyboardKey.keyZ,
  'x': PhysicalKeyboardKey.keyX,
  'c': PhysicalKeyboardKey.keyC,
  'v': PhysicalKeyboardKey.keyV,
  'b': PhysicalKeyboardKey.keyB,
  'n': PhysicalKeyboardKey.keyN,
  'm': PhysicalKeyboardKey.keyM,
  '\n': PhysicalKeyboardKey.enter,
  '\r': PhysicalKeyboardKey.enter,
  ' ': PhysicalKeyboardKey.space,
  '.': PhysicalKeyboardKey.period,
  ',': PhysicalKeyboardKey.comma,
  '\b': PhysicalKeyboardKey.backspace,
  '\t': PhysicalKeyboardKey.tab,
};
