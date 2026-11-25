import 'package:flutter_test/flutter_test.dart';
import 'package:electro_calc/logic/motor_current.dart';

void main() {
  test('5.5 kW three-phase, 400 V, eff 0.9, pf 0.85 is about 10.38 A', () {
    final r = motorCurrent(
      threePhase: true,
      ratedKw: 5.5,
      volts: 400,
      efficiency: 0.9,
      pf: 0.85,
    )!;
    expect(r.amps, closeTo(10.378, 0.01));
    expect(r.inputKw, closeTo(6.111, 0.01));
  });

  test('1.5 kW single-phase, 230 V, eff 0.8, pf 0.8 is about 10.19 A', () {
    final r = motorCurrent(
      threePhase: false,
      ratedKw: 1.5,
      volts: 230,
      efficiency: 0.8,
      pf: 0.8,
    )!;
    expect(r.amps, closeTo(10.190, 0.01));
  });

  test('HP converts to kW', () {
    expect(hpToKw(10), closeTo(7.457, 0.001));
  });

  test('bad efficiency is rejected', () {
    expect(
      motorCurrent(
        threePhase: true,
        ratedKw: 5.5,
        volts: 400,
        efficiency: 1.5,
        pf: 0.85,
      ),
      isNull,
    );
  });
}
