import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/state/simulator_state.dart';

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
    return ReorderableList(
      itemCount: _moduleKeys.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          final moduleList = widget.state.moduleVisualOrder;
          final newModuleList = List<String>.from(moduleList);

          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          final item = newModuleList.removeAt(oldIndex);
          newModuleList.insert(newIndex, item);

          widget.onChanged(
            widget.state.copyWith(moduleVisualOrder: newModuleList),
          );
        });
      },
      itemBuilder: (context, i) {
        final module = widget.modules[i];

        return Column(
          key: _moduleKeys[module]!,
          children: [
            ReorderableDelayedDragStartListener(
              index: i,
              child: module.buildPanel(
                context,
                widget.state,
                (v) => widget.onChanged(
                  widget.state.copyWithModuleState(module.id, v),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
          ],
        );
      },
    );
  }
}
