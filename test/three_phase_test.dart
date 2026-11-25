import 'package:flutter_test/flutter_test.dart';
import 'package:electro_calc/logic/three_phase.dart';

void main() {
  test('400 V, 10 A, pf 0.8', () {
    final r = fromAmps(volts: 400, amps: 10, pf: 0.8)!;
    expect(r.kva, closeTo(6.928, 0.01));
    expect(r.kw, closeTo(5.543, 0.01));
    expect(r.kvar, closeTo(4.157, 0.01));
  });

  test('5.5 kW, 400 V, pf 0.8 draws about 9.92 A', () {
    final r = fromKw(volts: 400, kw: 5.5, pf: 0.8)!;
    expect(r.amps, closeTo(9.923, 0.01));
    expect(r.kva, closeTo(6.875, 0.01));
  });

  test('power factor above 1 is rejected', () {
    expect(fromAmps(volts: 400, amps: 10, pf: 1.2), isNull);
    expect(fromKw(volts: 400, kw: 5, pf: 0), isNull);
  });
}
