import 'package:flutter/material.dart';
import 'package:simulator/src/utils/compute_padding.dart';

class KeyboardWidget extends StatelessWidget {
  const KeyboardWidget({
    super.key,
    required this.keyboard,
    required this.child,
    required this.keyboardHeight,
    required this.animationValue,
  });

  final double animationValue;
  final double keyboardHeight;
  final Widget keyboard;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var value = animationValue.clamp(0.0, 1.0);
    value = value < Tolerance.defaultTolerance.distance ? 0.0 : value;

    final mediaQuery = MediaQuery.of(context);
    final viewInsets = EdgeInsets.only(bottom: keyboardHeight * value);

    return Stack(
      fit: StackFit.passthrough,
      children: [
        MediaQuery(
          data: mediaQuery.copyWith(
            viewInsets: viewInsets,
            padding: computePadding(
              viewInsets: viewInsets,
              viewPadding: mediaQuery.viewPadding,
            ),
          ),
          child: child,
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Transform.translate(
            offset: Offset(0.0, (1.0 - value) * keyboardHeight),
            child: keyboard,
          ),
        ),
      ],
    );
  }
}
