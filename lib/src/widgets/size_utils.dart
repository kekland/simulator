import 'package:flutter/widgets.dart';

String _doubleToString(double v) {
  if (v.truncateToDouble() == v) {
    return v.toStringAsFixed(0);
  } else {
    return v.toStringAsFixed(2);
  }
}

extension ToFormattedString on Size {
  String toFormattedString() {
    return '${_doubleToString(width)} x ${_doubleToString(height)}';
  }
}
