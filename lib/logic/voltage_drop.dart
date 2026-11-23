import 'dart:math';

enum Phase { single, three }

enum Conductor { copper, aluminium }

// Resistivity in ohm * mm^2 / m (at about 20 C).
const _resistivity = {
  Conductor.copper: 0.0175,
  Conductor.aluminium: 0.0283,
};

class VoltageDropResult {
  final double dropVolts;
  final double dropPercent;
  final double loadVoltage;
  const VoltageDropResult(this.dropVolts, this.dropPercent, this.loadVoltage);
}

/// Length is ONE-WAY cable length in metres. Area is in mm^2.
VoltageDropResult? calcVoltageDrop({
  required Phase phase,
  required Conductor conductor,
  required double supplyVoltage,
  required double currentAmps,
  required double lengthMetres,
  required double areaMm2,
}) {
  if (supplyVoltage <= 0 ||
      currentAmps <= 0 ||
      lengthMetres <= 0 ||
      areaMm2 <= 0) {
    return null;
  }
  final k = phase == Phase.single ? 2.0 : sqrt(3);
  final drop =
      k * lengthMetres * currentAmps * _resistivity[conductor]! / areaMm2;
  return VoltageDropResult(
    drop,
    drop / supplyVoltage * 100,
    supplyVoltage - drop,
  );
}
