import 'package:flutter/material.dart';
import 'package:simulator/src/widgets/window_draggable_area.dart';
import 'package:window_manager/window_manager.dart';

class SimulatorAppBar extends StatelessWidget {
  const SimulatorAppBar({
    super.key,
    this.appTitle,
    this.primaryColor,
    required this.onToggleSidePanel,
    required this.isSidePanelVisible,
  });

  final String? appTitle;
  final Color? primaryColor;

  static const double height = 64.0;

  final VoidCallback onToggleSidePanel;
  final bool isSidePanelVisible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final primaryColor = this.primaryColor ?? theme.primaryColor;
    final foregroundColor =
        primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return WindowDraggableArea(
      child: Material(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16.0),
        elevation: 4.0,
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: Row(
            children: [
              const SizedBox(width: 8.0),
              SizedBox.square(
                dimension: 48.0,
                child: IconButton(
                  onPressed: () {
                    windowManager.close();
                  },
                  color: foregroundColor,
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appTitle ?? 'Simulator',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(height: 1.0, color: foregroundColor),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'Simulator',
                      style: theme.textTheme.bodySmall?.copyWith(
                        height: 1.0,
                        color: foregroundColor.withOpacity(0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              SizedBox.square(
                dimension: 48.0,
                child: IconButton(
                  onPressed: () {},
                  color: foregroundColor,
                  icon: const Icon(Icons.camera_alt_rounded),
                ),
              ),
              SizedBox.square(
                dimension: 48.0,
                child: IconButton(
                  onPressed: onToggleSidePanel,
                  color: foregroundColor,
                  icon: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      isSidePanelVisible
                          ? Icons.chevron_left_rounded
                          : Icons.chevron_right_rounded,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
