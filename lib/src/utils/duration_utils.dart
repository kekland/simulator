extension FormattedDurationString on Duration {
  String toFormattedString() {
    final minutes = inMinutes;
    final seconds = inSeconds.remainder(60);
    final milliseconds = inMilliseconds.remainder(1000);
    final microseconds = inMicroseconds.remainder(1000);

    final map = {
      if (minutes > 0) 'm': minutes,
      if (seconds > 0) 's': seconds,
      if (milliseconds > 0) 'ms': milliseconds,
      if (microseconds > 0) 'μs': microseconds,
    };

    return map.entries.map((entry) {
      return '${entry.value}${entry.key}';
    }).join(' ');
  }
}
