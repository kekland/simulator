import 'dart:ui';

extension InverseBrightness on Brightness {
  Brightness get inverse =>
      this == Brightness.light ? Brightness.dark : Brightness.light;
}

extension IntersperseIterable<T> on Iterable<T> {
  Iterable<T> intersperse(T element) sync* {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return;
    yield iterator.current;
    while (iterator.moveNext()) {
      yield element;
      yield iterator.current;
    }
  }
}
