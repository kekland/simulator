import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberTextField extends StatefulWidget {
  const NumberTextField({
    super.key,
    required this.value,
    required this.onChanged,
    this.prefixIcon,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final Widget? prefixIcon;

  @override
  State<NumberTextField> createState() => _NumberTextFieldState();
}

class _NumberTextFieldState extends State<NumberTextField> {
  final _controller = TextEditingController();
  var _isErrored = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value.toString();
    _controller.addListener(_updateValue);
  }

  @override
  void didUpdateWidget(NumberTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _setUpdatedValue();
    }
  }

  void _setUpdatedValue() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.value - widget.value.toInt() == 0) {
        _controller.text = widget.value.toInt().toString();
      } else {
        _controller.text = widget.value.toString();
      }
    });
  }

  void _updateValue() {
    final value = double.tryParse(_controller.text);

    if (value != null) {
      widget.onChanged?.call(value);
      _isErrored = false;
    } else {
      _isErrored = true;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      decoration: InputDecoration(
        enabled: widget.onChanged != null,
        border: const OutlineInputBorder(),
        prefixIcon: widget.prefixIcon,
        errorText: _isErrored ? '' : null,
        errorStyle: const TextStyle(fontSize: 0.0),
      ),
    );
  }
}
