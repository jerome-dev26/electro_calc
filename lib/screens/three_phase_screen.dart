import 'package:material_ui/material_ui.dart';
import '../logic/three_phase.dart';

enum _Mode { findPower, findAmps }

class ThreePhaseScreen extends StatefulWidget {
  const ThreePhaseScreen({super.key});

  @override
  State<ThreePhaseScreen> createState() => _ThreePhaseScreenState();
}

class _ThreePhaseScreenState extends State<ThreePhaseScreen> {
  final _volts = TextEditingController(text: '400');
  final _value = TextEditingController();
  final _pf = TextEditingController(text: '0.85');
  _Mode _mode = _Mode.findPower;
  String _message = 'Fill in all the fields, then tap Calculate.';

  double? _read(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.'));

  void _calculate() {
    final volts = _read(_volts) ?? 0;
    final value = _read(_value) ?? 0;
    final pf = _read(_pf) ?? 0;
    final result = _mode == _Mode.findPower
        ? fromAmps(volts: volts, amps: value, pf: pf)
        : fromKw(volts: volts, kw: value, pf: pf);
    setState(() {
      if (result == null) {
        _message = 'Please enter positive numbers. '
            'Power factor must be above 0 and at most 1.';
        return;
      }
      _message = 'Real power: ${result.kw.toStringAsFixed(2)} kW\n'
          'Apparent power: ${result.kva.toStringAsFixed(2)} kVA\n'
          'Reactive power: ${result.kvar.toStringAsFixed(2)} kVAr\n'
          'Line current: ${result.amps.toStringAsFixed(2)} A\n\n'
          'Assumes a balanced load and line-to-line voltage. '
          'Results are estimates; check against local code.';
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
    final findPower = _mode == _Mode.findPower;
    return Scaffold(
      appBar: AppBar(title: const Text('Three-Phase Power')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<_Mode>(
            segments: const [
              ButtonSegment(value: _Mode.findPower, label: Text('Amps to kW')),
              ButtonSegment(value: _Mode.findAmps, label: Text('kW to amps')),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() {
              _mode = s.first;
              _value.clear();
            }),
          ),
          const SizedBox(height: 16),
          _field(_volts, 'Line-to-line voltage (V)'),
          _field(_value, findPower ? 'Current (A)' : 'Real power (kW)'),
          _field(_pf, 'Power factor (0 to 1)'),
          FilledButton(onPressed: _calculate, child: const Text('Calculate')),
          const SizedBox(height: 16),
          Text(_message),
        ],
      ),
    );
  }
}
