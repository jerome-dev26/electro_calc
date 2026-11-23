import 'package:flutter_test/flutter_test.dart';
import 'package:electro_calc/logic/voltage_drop.dart';

void main() {
  test('single-phase copper: 20 A, 30 m, 2.5 mm2, 230 V', () {
    final r = calcVoltageDrop(
      phase: Phase.single,
      conductor: Conductor.copper,
      supplyVoltage: 230,
      currentAmps: 20,
      lengthMetres: 30,
      areaMm2: 2.5,
    )!;
    expect(r.dropVolts, closeTo(8.4, 0.01));
    expect(r.dropPercent, closeTo(3.652, 0.01));
  });

  test('three-phase copper: 20 A, 30 m, 2.5 mm2, 400 V', () {
    final r = calcVoltageDrop(
      phase: Phase.three,
      conductor: Conductor.copper,
      supplyVoltage: 400,
      currentAmps: 20,
      lengthMetres: 30,
      areaMm2: 2.5,
    )!;
    expect(r.dropVolts, closeTo(7.275, 0.01));
  });

  test('zero or negative input returns null', () {
    expect(
      calcVoltageDrop(
        phase: Phase.single,
        conductor: Conductor.copper,
        supplyVoltage: 230,
        currentAmps: 0,
        lengthMetres: 30,
        areaMm2: 2.5,
      ),
      isNull,
    );
  });
}
