import 'package:flutter/material.dart';
import 'package:simulator/src/platform_channels/platform_channel_interceptors.dart';
import 'package:simulator/src/utils/simulated_ime.dart';

class InheritedKeyboardWidget extends InheritedWidget {
  const InheritedKeyboardWidget({
    super.key,
    required this.brightness,
    required this.ime,
    required super.child,
  });

  final Brightness brightness;
  final SimulatedIME? ime;

  static InheritedKeyboardWidget of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedKeyboardWidget>()!;
  }

  @override
  bool updateShouldNotify(InheritedKeyboardWidget oldWidget) {
    return brightness != oldWidget.brightness || ime != oldWidget.ime;
  }
}

class KeyboardThemeProvider extends StatefulWidget {
  const KeyboardThemeProvider({super.key, required this.child});

  final Widget child;

  @override
  State<KeyboardThemeProvider> createState() => _KeyboardThemeProviderState();
}

class _KeyboardThemeProviderState extends State<KeyboardThemeProvider> {
  Brightness? _lastBrightness;

  @override
  Widget build(BuildContext context) {
    final textInput = PlatformChannelInterceptors.textInput;

    return ValueListenableBuilder(
      valueListenable: textInput.activeIMEIdNotifier,
      builder: (context, imeId, _) {
        final ime = textInput.maybeActiveIME;
        final brightness = ime?.configuration.keyboardAppearance ??
            _lastBrightness ??
            Brightness.light;

        if (ime?.configuration.keyboardAppearance != null) {
          _lastBrightness = ime?.configuration.keyboardAppearance;
        }

        return InheritedKeyboardWidget(
          brightness: brightness,
          ime: ime,
          child: widget.child,
        );
      },
    );
  }
}
