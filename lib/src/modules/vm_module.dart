import 'package:flutter/material.dart';
import 'package:simulator/simulator.dart';
import 'package:simulator/src/app/properties_panel/widgets.dart';
import 'package:simulator/src/modules/_module.dart';
import 'package:simulator/src/state/simulator_state.dart';

class VmModule extends SimulatorModule<Object> {
  const VmModule();

  @override
  Object createInitialState(json) {
    return Object();
  }

  @override
  Map<String, dynamic> toJson(Object data) {
    return {};
  }

  @override
  String get id => 'vm';

  @override
  Widget buildPanel(
    BuildContext context,
    SimulatorState state,
    ValueChanged<Object> onChanged,
  ) {
    return const VmSection();
  }
}

class VmSection extends StatefulWidget {
  const VmSection({super.key});

  @override
  State<VmSection> createState() => _VmSectionState();
}

class _VmSectionState extends State<VmSection> {
  // VmService? _vmService;
  // VM? _vm;
  // final _memoryUsage = <String, MemoryUsage>{};
  // Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    // _connectToVmService();
  }

  // Future<void> _connectToVmService() async {
  //   final info = await developer.Service.getInfo();
  //   _vmService = await vmServiceConnectUri(info.serverWebSocketUri.toString());
  //   _vm = await _vmService!.getVM();

  //   setState(() {});

  //   _updateTimer = Timer.periodic(
  //     const Duration(milliseconds: 250),
  //     _update,
  //   );
  // }

  // Future<void> _update(_) async {
  //   final isolates = _vm!.isolates!;

  //   _memoryUsage.clear();
  //   for (final isolate in isolates) {
  //     _memoryUsage[isolate.name!] =
  //         await _vmService!.getMemoryUsage(isolate.id!);
  //   }

  //   setState(() {});
  // }

  // @override
  // void dispose() {
  //   _updateTimer?.cancel();
  //   _vmService?.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final List<Widget> body;

    // if (_vmService == null) {
    //   body = [
    //     const SizedBox(height: 8.0),
    //     const Center(child: CircularProgressIndicator()),
    //     const SizedBox(height: 8.0),
    //   ];
    // } else {
    body = [
      // for (final isolateEntry in _memoryUsage.entries)
      //   ListTile(
      //     title: Text('Heap usage (${isolateEntry.key})'),
      //     subtitle: Text(_formatMemoryUsage(isolateEntry.value)),
      //   ),
      ListTile(
        onTap: () {
          SimulatorWidgetsFlutterBinding.instance.handleMemoryPressure();
        },
        title: const Text('Fire memory pressure event'),
      ),
    ];
    // }

    return SectionCard(
      leading: const Icon(Icons.memory_rounded),
      title: const Text('VM'),
      child: SectionList(
        children: [
          ...body,
        ],
      ),
    );
  }
}

// String _formatMemoryUsage(MemoryUsage memoryUsage) {
//   final used = _formatBytes(memoryUsage.heapUsage!);
//   final capacity = _formatBytes(memoryUsage.heapCapacity!);
//   final percentage = (memoryUsage.heapUsage! / memoryUsage.heapCapacity! * 100)
//       .toStringAsFixed(2);

//   return '$used / $capacity ($percentage%)';
// }

// String _formatBytes(int bytes) {
//   if (bytes < 1024) {
//     return '$bytes B';
//   } else if (bytes < 1024 * 1024) {
//     return '${(bytes / 1024).toStringAsFixed(2)} KB';
//   } else if (bytes < 1024 * 1024 * 1024) {
//     return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
//   } else {
//     return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
//   }
// }
