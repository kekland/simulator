import 'package:flutter/widgets.dart';

class SidePanelRevealAnimator extends StatelessWidget {
  const SidePanelRevealAnimator({
    super.key,
    required this.isVisible,
    required this.width,
    required this.child,
  });

  final bool isVisible;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: isVisible ? width : 0.0,
      clipBehavior: Clip.none,
      child: OverflowBox(
        alignment: Alignment.topLeft,
        minWidth: width,
        maxWidth: width,
        child: child,
      ),
    );
  }
}
