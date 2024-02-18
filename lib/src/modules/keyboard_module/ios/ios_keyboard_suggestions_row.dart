import 'package:flutter/material.dart';
import 'package:simulator/src/modules/keyboard_module/ios/ios_keyboard_theme.dart';

class IOSKeyboardSuggestionsRow extends StatelessWidget
    implements PreferredSizeWidget {
  const IOSKeyboardSuggestionsRow({super.key});

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1.0,
      height: 25.0,
      color: IOSKeyboardTheme.of(context).suggestionsDividerColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: preferredSize,
      child: Row(
        children: [
          const Expanded(
            child: Center(child: Text('suggestion 1')),
          ),
          _buildDivider(context),
          const Expanded(
            child: Center(child: Text('suggestion 2')),
          ),
          _buildDivider(context),
          const Expanded(
            child: Center(child: Text('suggestion 3')),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(51);
}
