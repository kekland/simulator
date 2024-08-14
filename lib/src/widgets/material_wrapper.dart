import 'package:flutter/material.dart';
import 'package:simulator/src/platform_channels/platform_channel_interceptors.dart';

class MaterialWrapper extends StatelessWidget {
  const MaterialWrapper({
    super.key,
    required this.child,
    this.wrapWithNavigator = true,
  });

  final bool wrapWithNavigator;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PlatformChannelInterceptors.system,
      builder: (context, child) {
        final primaryColor =
            PlatformChannelInterceptors.system.primaryColor ?? Colors.blue;

        return Theme(
          data: ThemeData(
            platform: TargetPlatform.android,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              brightness: Brightness.dark,
            ),
          ),
          child: child!,
        );
      },
      child: DefaultTextEditingShortcuts(
        child: Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Actions(
            actions: WidgetsApp.defaultActions,
            child: Localizations(
              locale: const Locale('en', 'US'),
              delegates: const [
                DefaultWidgetsLocalizations.delegate,
                DefaultMaterialLocalizations.delegate,
              ],
              child: ListTileTheme(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  type: MaterialType.transparency,
                  clipBehavior: Clip.none,
                  child: wrapWithNavigator
                      ? Navigator(
                          onPopPage: (route, result) => route.didPop(result),
                          pages: [
                            MaterialPage(child: child),
                          ],
                        )
                      : child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
