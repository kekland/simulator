import 'package:flutter/material.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/utils/utils.dart';
import 'package:simulator/src/widgets/expansion_tile.dart';
import 'package:simulator/src/widgets/number_text_field.dart';
import 'package:simulator/src/widgets/windows/window_root_navigator.dart';

class SectionCard extends StatefulWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.builder,
    this.leading,
  });

  final Widget? leading;
  final Widget title;
  final WidgetBuilder builder;

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  @override
  Widget build(BuildContext context) {
    return SmExpansionTile(
      isElevated: true,
      leading: widget.leading,
      title: widget.title,
      onOpenInWindow: () {
        windowRootNavigatorStateKey.currentState!.pushWindow(
          (context) {
            InheritedSimulatorState.of(context);
            return widget.builder(context);
          },
          icon: widget.leading,
          title: widget.title,
        );
      },
      child: widget.builder(context),
    );
  }
}

class SectionList extends StatelessWidget {
  const SectionList({
    super.key,
    required this.children,
    this.automaticallyImplyDividers = true,
  });

  final List<Widget> children;
  final bool automaticallyImplyDividers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: automaticallyImplyDividers
          ? children.intersperse(const Divider(height: 0.0)).toList()
          : children,
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    this.leading,
    this.subtitle,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    this.onOpenInWindow,
  });

  final Widget? leading;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback? onOpenInWindow;
  final Widget title;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onToggle,
      title: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleMedium!,
        child: title,
      ),
      subtitle: subtitle,
      leading: leading,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onOpenInWindow != null)
            IconButton(
              onPressed: onOpenInWindow,
              icon: const Icon(Icons.open_in_new_rounded),
            ),
          RotatedBox(
            quarterTurns: isExpanded ? 3 : 1,
            child: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

class SliderTile extends StatelessWidget {
  const SliderTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    this.divisions,
    this.resetValue = 1.0,
  });

  final String title;
  final String? subtitle;

  final double value;
  final ValueChanged<double> onChanged;

  final double min;
  final double max;

  final int? divisions;

  final double resetValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          contentPadding: const EdgeInsets.only(left: 16.0, right: 8.0),
          trailing: TextButton(
            onPressed: () {
              onChanged(resetValue);
            },
            child: const Text('RESET'),
          ),
          subtitle: subtitle != null ? Text(subtitle!) : null,
        ),
        SliderTheme(
          data: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          ),
          child: Slider(
            min: min,
            max: max,
            value: value,
            label: value.toStringAsFixed(2),
            divisions: divisions,
            onChanged: (value) {
              onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}

class EdgeInsetsTile extends StatelessWidget {
  const EdgeInsetsTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;

  final EdgeInsets value;
  final ValueChanged<EdgeInsets>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          contentPadding: const EdgeInsets.only(left: 16.0, right: 8.0),
          trailing: TextButton(
            onPressed: onChanged != null
                ? () {
                    onChanged!(EdgeInsets.zero);
                  }
                : null,
            child: const Text('RESET'),
          ),
        ),
        const SizedBox(height: 12.0),
        Row(
          children: [
            const SizedBox(width: 16.0),
            const Spacer(flex: 1),
            Expanded(
              flex: 2,
              child: NumberTextField(
                value: value.top,
                onChanged: onChanged != null
                    ? (value) {
                        onChanged!(this.value.copyWith(top: value));
                      }
                    : null,
                prefixIcon: const Icon(Icons.border_top_rounded),
              ),
            ),
            const Spacer(flex: 1),
            const SizedBox(width: 16.0),
          ],
        ),
        const SizedBox(height: 12.0),
        Row(
          children: [
            const SizedBox(width: 16.0),
            Expanded(
              child: NumberTextField(
                value: value.left,
                onChanged: onChanged != null
                    ? (value) {
                        onChanged!(this.value.copyWith(left: value));
                      }
                    : null,
                prefixIcon: const Icon(Icons.border_left_rounded),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: NumberTextField(
                value: value.right,
                onChanged: onChanged != null
                    ? (value) {
                        onChanged!(this.value.copyWith(right: value));
                      }
                    : null,
                prefixIcon: const Icon(Icons.border_right_rounded),
              ),
            ),
            const SizedBox(width: 16.0),
          ],
        ),
        const SizedBox(height: 12.0),
        Row(
          children: [
            const SizedBox(width: 16.0),
            const Spacer(flex: 1),
            Expanded(
              flex: 2,
              child: NumberTextField(
                value: value.bottom,
                onChanged: onChanged != null
                    ? (value) {
                        onChanged!(this.value.copyWith(bottom: value));
                      }
                    : null,
                prefixIcon: const Icon(Icons.border_bottom_rounded),
              ),
            ),
            const Spacer(flex: 1),
            const SizedBox(width: 16.0),
          ],
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
