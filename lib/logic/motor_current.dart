import 'dart:math';

const double kwPerHp = 0.7457; // mechanical horsepower

class MotorResult {
  final double outputKw;
  final double inputKw;
  final double amps;
  const MotorResult(this.outputKw, this.inputKw, this.amps);
}

double hpToKw(double hp) => hp * kwPerHp;

/// ratedKw is the motor's OUTPUT (shaft) power. Efficiency and power
/// factor are between 0 and 1.
MotorResult? motorCurrent({
  required bool threePhase,
  required double ratedKw,
  required double volts,
  required double efficiency,
  required double pf,
}) {
  if (ratedKw <= 0 || volts <= 0) return null;
  if (efficiency <= 0 || efficiency > 1) return null;
  if (pf <= 0 || pf > 1) return null;
  final k = threePhase ? sqrt(3) : 1.0;
  final amps = ratedKw * 1000 / (k * volts * efficiency * pf);
  return MotorResult(ratedKw, ratedKw / efficiency, amps);
}
