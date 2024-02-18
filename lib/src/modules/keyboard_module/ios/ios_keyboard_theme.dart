import 'package:flutter/material.dart';
import 'package:simulator/src/utils/simulated_ime.dart';

class IOSKeyboardTheme {
  const IOSKeyboardTheme({
    required this.keyColor,
    required this.keyForegroundColor,
    required this.specialKeyColor,
    required this.keyShadowColor,
    required this.suggestionsForegroundColor,
    required this.suggestionsDividerColor,
    required this.trailingForegroundColor,
    required this.keyboardBackgroundColor,
  });

  final Color keyColor;
  final Color keyForegroundColor;
  final Color specialKeyColor;
  final Color keyShadowColor;
  final Color suggestionsForegroundColor;
  final Color suggestionsDividerColor;
  final Color trailingForegroundColor;
  final Color keyboardBackgroundColor;

  static IOSKeyboardTheme of(BuildContext context) {
    return IOSInheritedKeyboardWidget.of(context).theme;
  }

  static const light = IOSKeyboardTheme(
    keyColor: Color(0xFFFDFDFE),
    keyForegroundColor: Color(0xFF000000),
    specialKeyColor: Color(0xFFB3BAC3),
    keyShadowColor: Color(0xFF888A8D),
    suggestionsForegroundColor: Color(0xFF141515),
    suggestionsDividerColor: Color(0xFFBDBFC3),
    trailingForegroundColor: Color(0xFF51555B),
    keyboardBackgroundColor: Color(0xFFD1D4D9),
  );

  static const dark = IOSKeyboardTheme(
    keyColor: Color(0xFF535353),
    keyForegroundColor: Color(0xFFFFFFFF),
    specialKeyColor: Color(0xFF2D2D2D),
    keyShadowColor: Color(0xFF535353),
    suggestionsForegroundColor: Color(0xFFE7E7E7),
    suggestionsDividerColor: Color(0xFFBDBFC3),
    trailingForegroundColor: Color(0xFFFFFFFF),
    keyboardBackgroundColor: Color(0xFF0A0A0A),
  );
}

class IOSInheritedKeyboardWidget extends InheritedWidget {
  const IOSInheritedKeyboardWidget({
    super.key,
    required this.theme,
    this.ime,
    required super.child,
  });

  final IOSKeyboardTheme theme;
  final SimulatedIME? ime;

  static IOSInheritedKeyboardWidget of(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<IOSInheritedKeyboardWidget>();
    return inherited!;
  }

  @override
  bool updateShouldNotify(IOSInheritedKeyboardWidget oldWidget) =>
      theme != oldWidget.theme || ime != oldWidget.ime;
}
