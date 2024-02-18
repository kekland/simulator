import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/state/simulator_state.dart';
import 'package:simulator/src/utils/utils.dart';

class SimulatorPropertiesPanel extends StatefulWidget {
  const SimulatorPropertiesPanel({
    super.key,
    required this.modules,
    required this.state,
    required this.onChanged,
  });

  static const double width = 320.0;

  final List<SimulatorModule> modules;
  final SimulatorState state;
  final ValueChanged<SimulatorState> onChanged;

  @override
  State<SimulatorPropertiesPanel> createState() =>
      _SimulatorPropertiesPanelState();
}

class _SimulatorPropertiesPanelState extends State<SimulatorPropertiesPanel> {
  final _moduleKeys = <SimulatorModule, GlobalKey>{};

  @override
  void initState() {
    super.initState();

    for (final module in widget.modules) {
      _moduleKeys[module] = GlobalKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SimulatorPropertiesPanel.width,
      height: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: widget.modules
                .map<Widget>(
                  (module) => KeyedSubtree(
                    key: _moduleKeys[module]!,
                    child: module.buildPanel(
                      context,
                      widget.state,
                      (v) => widget.onChanged(
                        widget.state.copyWith(module.id, v),
                      ),
                    ),
                  ),
                )
                .intersperse(const SizedBox(height: 12.0))
                .toList(),
          ),
        ),
      ),
    );
  }
}
