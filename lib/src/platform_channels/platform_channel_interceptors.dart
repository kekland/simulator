import 'package:flutter/widgets.dart';
import 'package:simulator/src/platform_channels/system_platform_channel_interceptor.dart';
import 'package:simulator/src/platform_channels/system_text_input_channel_interceptor.dart';

class PlatformChannelInterceptors extends ChangeNotifier {
  PlatformChannelInterceptors._();

  static PlatformChannelInterceptors? _instance;
  static PlatformChannelInterceptors get instance {
    return _instance ??= PlatformChannelInterceptors._();
  }

  static PlatformChannelInterceptors ensureInitialized() {
    SystemPlatformChannelInterceptor.ensureInitialized();
    SystemTextInputChannelInterceptor.ensureInitialized();

    return instance;
  }

  static SystemPlatformChannelInterceptor get system =>
      SystemPlatformChannelInterceptor.instance;

  static SystemTextInputChannelInterceptor get textInput =>
      SystemTextInputChannelInterceptor.instance;
}
