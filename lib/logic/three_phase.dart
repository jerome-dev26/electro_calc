import 'dart:math';

class ThreePhaseResult {
  final double kw;
  final double kva;
  final double kvar;
  final double amps;
  const ThreePhaseResult(this.kw, this.kva, this.kvar, this.amps);
}

/// Line-to-line voltage, current in amps, power factor between 0 and 1.
ThreePhaseResult? fromAmps({
  required double volts,
  required double amps,
  required double pf,
}) {
  if (volts <= 0 || amps <= 0 || pf <= 0 || pf > 1) return null;
  final kva = sqrt(3) * volts * amps / 1000;
  final kw = kva * pf;
  final kvar = kva * sqrt(1 - pf * pf);
  return ThreePhaseResult(kw, kva, kvar, amps);
}

/// Real power in kW, line-to-line voltage, power factor between 0 and 1.
ThreePhaseResult? fromKw({
  required double volts,
  required double kw,
  required double pf,
}) {
  if (volts <= 0 || kw <= 0 || pf <= 0 || pf > 1) return null;
  final amps = kw * 1000 / (sqrt(3) * volts * pf);
  final kva = kw / pf;
  final kvar = kva * sqrt(1 - pf * pf);
  return ThreePhaseResult(kw, kva, kvar, amps);
}
