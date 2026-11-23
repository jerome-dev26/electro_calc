import 'dart:math';

class OhmsResult {
  final double voltage;
  final double current;
  final double resistance;
  final double power;
  const OhmsResult(this.voltage, this.current, this.resistance, this.power);
}

/// Give exactly two of the four values. Returns all four, or null if invalid.
OhmsResult? solveOhms({double? v, double? i, double? r, double? p}) {
  final values = [v, i, r, p];
  if (values.where((x) => x != null).length != 2) return null;
  if (values.any((x) => x != null && x <= 0)) return null;

  if (v != null && i != null) {
    r = v / i;
    p = v * i;
  } else if (v != null && r != null) {
    i = v / r;
    p = v * v / r;
  } else if (v != null && p != null) {
    i = p / v;
    r = v * v / p;
  } else if (i != null && r != null) {
    v = i * r;
    p = i * i * r;
  } else if (i != null && p != null) {
    v = p / i;
    r = p / (i * i);
  } else if (r != null && p != null) {
    v = sqrt(p * r);
    i = sqrt(p / r);
  }
  return OhmsResult(v!, i!, r!, p!);
}
