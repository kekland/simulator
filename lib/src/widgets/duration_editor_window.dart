import 'package:flutter/material.dart';
import 'package:simulator/src/widgets/windows/window_root_navigator.dart';

Future<Duration?> showDurationEditorWindow(
  BuildContext context, {
  Duration? initialDuration,
}) {
  return windowRootNavigatorStateKey.currentState!.pushWindow(
    title: const Text('Duration'),
    icon: const Icon(Icons.timer_rounded),
    (context) => DurationEditorWindow(
      initialDuration: initialDuration,
    ),
  );
}

class DurationEditorWindow extends StatefulWidget {
  const DurationEditorWindow({super.key, this.initialDuration});

  final Duration? initialDuration;

  @override
  State<DurationEditorWindow> createState() => _DurationEditorWindowState();
}

class _DurationEditorWindowState extends State<DurationEditorWindow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.initialDuration?.inMilliseconds.toString() ?? '0',
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

  bool get _isValid => int.tryParse(_controller.text) != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Duration (ms)',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  if (!_isValid) return;

                  final duration = Duration(
                    milliseconds: int.parse(_controller.text),
                  );

                  Navigator.of(context).pop(duration);
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
