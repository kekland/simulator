import 'package:flutter/material.dart';
import 'package:simulator/src/utils/utils.dart';
import 'package:simulator/src/widgets/number_text_field.dart';

class SectionCard extends StatefulWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.leading,
  });

  final Widget? leading;
  final Widget title;
  final Widget child;

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard>
    with AutomaticKeepAliveClientMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListTileTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(16.0),
        elevation: 4.0,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            SectionTitle(
              leading: widget.leading,
              title: widget.title,
              isExpanded: _isExpanded,
              onToggle: () {
                _isExpanded = !_isExpanded;
                setState(() {});
              },
            ),
            AnimatedCrossFade(
              firstChild: Container(height: 0.0),
              secondChild: widget.child,
              firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
              secondCurve:
                  const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
              sizeCurve: Curves.fastOutSlowIn,
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 150),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
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
    required this.title,
    required this.isExpanded,
    required this.onToggle,
  });

  final Widget? leading;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onToggle,
      title: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleMedium!,
        child: title,
      ),
      leading: leading,
      trailing: RotatedBox(
        quarterTurns: isExpanded ? 3 : 1,
        child: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class SliderTile extends StatelessWidget {
  const SliderTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
  });

  final String title;
  final String subtitle;

  final double value;
  final ValueChanged<double> onChanged;

  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          contentPadding: const EdgeInsets.only(left: 16.0, right: 8.0),
          trailing: TextButton(
            onPressed: () {
              onChanged(1.0);
            },
            child: const Text('RESET'),
          ),
          subtitle: Text(
            subtitle,
          ),
        ),
        Slider(
          min: 0.5,
          max: 5.0,
          value: value,
          onChanged: (value) {
            onChanged(value);
          },
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
