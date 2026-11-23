import 'package:flutter/material.dart';
import '../logic/voltage_drop.dart';

class VoltageDropScreen extends StatefulWidget {
  const VoltageDropScreen({super.key});

  @override
  State<VoltageDropScreen> createState() => _VoltageDropScreenState();
}

class _VoltageDropScreenState extends State<VoltageDropScreen> {
  final _volts = TextEditingController(text: '230');
  final _amps = TextEditingController();
  final _length = TextEditingController();
  final _area = TextEditingController();
  Phase _phase = Phase.single;
  Conductor _conductor = Conductor.copper;
  String _message = 'Fill in all the fields, then tap Calculate.';

  double? _read(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.'));

  void _calculate() {
    final result = calcVoltageDrop(
      phase: _phase,
      conductor: _conductor,
      supplyVoltage: _read(_volts) ?? 0,
      currentAmps: _read(_amps) ?? 0,
      lengthMetres: _read(_length) ?? 0,
      areaMm2: _read(_area) ?? 0,
    );
    setState(() {
      if (result == null) {
        _message = 'Please enter positive numbers in every field.';
        return;
      }
      final p = result.dropPercent;
      final note = p > 5
          ? 'This is high. Consider a larger cable.'
          : p > 3
              ? 'Many standards suggest staying under about 3 to 5 percent.'
              : 'This is within the range many standards suggest.';
      _message = 'Voltage drop: ${result.dropVolts.toStringAsFixed(2)} V '
          '(${p.toStringAsFixed(2)} %)\n'
          'Voltage at the load: ${result.loadVoltage.toStringAsFixed(1)} V\n\n'
          '$note\n\n'
          'Estimate at 20 C, ignoring cable reactance. Real cables run '
          'hotter, so the true drop is a little higher. Always check local '
          'electrical code.';
    });
  }

  Widget _field(TextEditingController c, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voltage Drop')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<Phase>(
            segments: const [
              ButtonSegment(value: Phase.single, label: Text('Single-phase')),
              ButtonSegment(value: Phase.three, label: Text('Three-phase')),
            ],
            selected: {_phase},
            onSelectionChanged: (s) => setState(() => _phase = s.first),
          ),
          const SizedBox(height: 12),
          SegmentedButton<Conductor>(
            segments: const [
              ButtonSegment(value: Conductor.copper, label: Text('Copper')),
              ButtonSegment(
                  value: Conductor.aluminium, label: Text('Aluminium')),
            ],
            selected: {_conductor},
            onSelectionChanged: (s) => setState(() => _conductor = s.first),
          ),
          const SizedBox(height: 16),
          _field(_volts, 'Supply voltage (V)'),
          _field(_amps, 'Current (A)'),
          _field(_length, 'Cable length, one way (m)'),
          _field(_area, 'Cable cross-section (mm²)'),
          FilledButton(onPressed: _calculate, child: const Text('Calculate')),
          const SizedBox(height: 16),
          Text(_message),
        ],
      ),
    );
  }
}
