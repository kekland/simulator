import 'package:flutter/material.dart';
import 'package:simulator/src/modules/keyboard_module/keyboard_theme_provider.dart';
import 'package:simulator/src/platform_channels/platform_channel_interceptors.dart';

class AndroidKeyboardThemeProvider extends StatelessWidget {
  const AndroidKeyboardThemeProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PlatformChannelInterceptors.system,
      child: child,
      builder: (context, child) {
        final primaryColor =
            PlatformChannelInterceptors.system.primaryColor ?? Colors.blue;

        return KeyboardThemeProvider(
          child: Builder(
            builder: (context) => Theme(
              data: ThemeData(
                platform: TargetPlatform.android,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: primaryColor,
                  brightness: InheritedKeyboardWidget.of(context).brightness,
                ),
              ),
              child: child!,
            ),
          ),
        );
      },
    );
  }
}
