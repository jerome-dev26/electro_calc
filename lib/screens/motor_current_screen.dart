import 'package:material_ui/material_ui.dart';
import '../logic/motor_current.dart';

class MotorCurrentScreen extends StatefulWidget {
  const MotorCurrentScreen({super.key});

  @override
  State<MotorCurrentScreen> createState() => _MotorCurrentScreenState();
}

class _MotorCurrentScreenState extends State<MotorCurrentScreen> {
  final _power = TextEditingController();
  final _volts = TextEditingController(text: '400');
  final _eff = TextEditingController(text: '0.90');
  final _pf = TextEditingController(text: '0.85');
  bool _threePhase = true;
  bool _inHp = false;
  String _message = 'Fill in all the fields, then tap Calculate.';

  double? _read(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.'));

  void _calculate() {
    final p = _read(_power) ?? 0;
    final result = motorCurrent(
      threePhase: _threePhase,
      ratedKw: _inHp ? hpToKw(p) : p,
      volts: _read(_volts) ?? 0,
      efficiency: _read(_eff) ?? 0,
      pf: _read(_pf) ?? 0,
    );
    setState(() {
      if (result == null) {
        _message = 'Please enter positive numbers. Efficiency and power '
            'factor must be above 0 and at most 1.';
        return;
      }
      _message = 'Estimated full-load current: '
          '${result.amps.toStringAsFixed(2)} A\n'
          'Shaft power: ${result.outputKw.toStringAsFixed(2)} kW\n'
          'Electrical input power: ${result.inputKw.toStringAsFixed(2)} kW\n\n'
          'This is an estimate from the values you entered. For sizing '
          'cables and protection, use the motor nameplate current and '
          'check local electrical code.';
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
      appBar: AppBar(title: const Text('Motor Current')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Three-phase')),
              ButtonSegment(value: false, label: Text('Single-phase')),
            ],
            selected: {_threePhase},
            onSelectionChanged: (s) => setState(() {
              _threePhase = s.first;
              _volts.text = _threePhase ? '400' : '230';
            }),
          ),
          const SizedBox(height: 12),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('kW')),
              ButtonSegment(value: true, label: Text('HP')),
            ],
            selected: {_inHp},
            onSelectionChanged: (s) => setState(() => _inHp = s.first),
          ),
          const SizedBox(height: 16),
          _field(_power, _inHp ? 'Motor rating (HP)' : 'Motor rating (kW)'),
          _field(_volts, 'Voltage (V)'),
          _field(_eff, 'Efficiency (0 to 1)'),
          _field(_pf, 'Power factor (0 to 1)'),
          FilledButton(onPressed: _calculate, child: const Text('Calculate')),
          const SizedBox(height: 16),
          Text(_message),
        ],
      ),
    );
  }
}
