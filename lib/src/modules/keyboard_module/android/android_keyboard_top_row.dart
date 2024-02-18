import 'package:flutter/material.dart';

class AndroidKeyboardTopRow extends StatelessWidget
    implements PreferredSizeWidget {
  const AndroidKeyboardTopRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        height: preferredSize.height,
        child: Row(
          children: [
            const SizedBox(width: 18 / 3),
            SizedBox.square(
              dimension: 102 / 3,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  elevation: 0.0,
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  foregroundColor: theme.colorScheme.onSecondaryContainer,
                ),
                child: const Icon(Icons.apps_rounded),
              ),
            ),
            const SizedBox(width: 18 / 3),
            Expanded(
              child: InkResponse(
                onTap: () {},
                child: Center(
                  child: Icon(
                    Icons.sticky_note_2_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkResponse(
                onTap: () {},
                child: Center(
                  child: Icon(
                    Icons.assignment_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkResponse(
                onTap: () {},
                child: Center(
                  child: Icon(
                    Icons.settings_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkResponse(
                onTap: () {},
                child: Center(
                  child: Icon(
                    Icons.palette_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkResponse(
                onTap: () {},
                child: Center(
                  child: Icon(
                    Icons.mic_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(132 / 3);
}
