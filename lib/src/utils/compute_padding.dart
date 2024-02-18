import 'dart:math';

import 'package:flutter/widgets.dart';

EdgeInsets computePadding({
  required EdgeInsets viewInsets,
  required EdgeInsets viewPadding,
}) {
  return EdgeInsets.only(
    top: max(0, viewPadding.top - viewInsets.top),
    bottom: max(0, viewPadding.bottom - viewInsets.bottom),
    left: max(0, viewPadding.left - viewInsets.left),
    right: max(0, viewPadding.right - viewInsets.right),
  );
}
