import 'package:flutter_test/flutter_test.dart';
import 'package:electro_calc/logic/ohms_law.dart';

void main() {
  test('12 V and 2 A gives 6 ohms and 24 W', () {
    final r = solveOhms(v: 12, i: 2)!;
    expect(r.resistance, closeTo(6, 0.0001));
    expect(r.power, closeTo(24, 0.0001));
  });

  test('230 V and 1000 W gives about 4.348 A', () {
    final r = solveOhms(v: 230, p: 1000)!;
    expect(r.current, closeTo(4.3478, 0.001));
  });

  test('wrong number of inputs returns null', () {
    expect(solveOhms(v: 12), isNull);
    expect(solveOhms(v: 12, i: 2, r: 6), isNull);
  });
}
