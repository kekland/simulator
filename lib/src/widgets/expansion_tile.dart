import 'package:flutter/material.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';

class SmExpansionTile extends StatefulWidget {
  const SmExpansionTile({
    super.key,
    this.leading,
    this.onOpenInWindow,
    required this.title,
    this.subtitle,
    required this.child,
    this.isElevated = false,
  });

  final Widget? leading;
  final VoidCallback? onOpenInWindow;
  final Widget title;
  final Widget? subtitle;
  final Widget child;
  final bool isElevated;

  @override
  State<SmExpansionTile> createState() => _SmExpansionTileState();
}

class _SmExpansionTileState extends State<SmExpansionTile>
    with AutomaticKeepAliveClientMixin {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListTileTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        borderRadius:
            widget.isElevated ? BorderRadius.circular(16.0) : BorderRadius.zero,
        elevation: widget.isElevated ? 4.0 : 0.0,
        clipBehavior: Clip.antiAlias,
        type:
            widget.isElevated ? MaterialType.canvas : MaterialType.transparency,
        child: Column(
          children: [
            SectionTitle(
              leading: widget.leading,
              title: widget.title,
              subtitle: widget.subtitle,
              isExpanded: _isExpanded,
              onOpenInWindow: widget.onOpenInWindow != null
                  ? () {
                      _isExpanded = false;
                      widget.onOpenInWindow!();
                      setState(() {});
                    }
                  : null,
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
                  const Interval(0.0, 0.75, curve: Curves.fastOutSlowIn),
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
