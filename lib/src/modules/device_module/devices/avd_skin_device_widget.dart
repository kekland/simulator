import 'package:flutter/material.dart';

class AvdSkinDeviceWidget extends StatelessWidget {
  const AvdSkinDeviceWidget({
    super.key,
    required this.screen,
    required this.size,
    required this.displaySize,
    required this.backgroundAsset,
    this.displayOffset = Offset.zero,
    this.foregroundAsset,
    this.package = 'simulator',
    this.screenRadius = BorderRadius.zero,
  });

  final Size size;
  final Size displaySize;
  final Offset displayOffset;

  final String backgroundAsset;
  final String? foregroundAsset;

  final Widget screen;

  final String package;

  final BorderRadius screenRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Image.asset(
            backgroundAsset,
            package: package,
          ),
          Positioned(
            left: displayOffset.dx,
            top: displayOffset.dy,
            child: ColoredBox(
              color: Colors.black,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: screenRadius,
                    child: SizedBox(
                      width: displaySize.width,
                      height: displaySize.height,
                      child: FittedBox(child: screen),
                    ),
                  ),
                  if (foregroundAsset != null)
                    IgnorePointer(
                      child: Image.asset(
                        foregroundAsset!,
                        package: package,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
