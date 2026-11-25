import 'package:material_ui/material_ui.dart';
import '../logic/ohms_law.dart';

class OhmsLawScreen extends StatefulWidget {
  const OhmsLawScreen({super.key});

  @override
  State<OhmsLawScreen> createState() => _OhmsLawScreenState();
}

class _OhmsLawScreenState extends State<OhmsLawScreen> {
  final _v = TextEditingController();
  final _i = TextEditingController();
  final _r = TextEditingController();
  final _p = TextEditingController();
  String _message = 'Enter any two values, then tap Calculate.';

  double? _read(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.'));

  String _fmt(double x) => x.toStringAsFixed(3);

  void _calculate() {
    final result = solveOhms(
      v: _read(_v),
      i: _read(_i),
      r: _read(_r),
      p: _read(_p),
    );
    setState(() {
      if (result == null) {
        _message = 'Please enter exactly two positive numbers.';
        return;
      }
      _v.text = _fmt(result.voltage);
      _i.text = _fmt(result.current);
      _r.text = _fmt(result.resistance);
      _p.text = _fmt(result.power);
      _message = 'Done. Results are estimates; check against local code.';
    });
  }

  void _clear() {
    setState(() {
      _v.clear();
      _i.clear();
      _r.clear();
      _p.clear();
      _message = 'Enter any two values, then tap Calculate.';
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
      appBar: AppBar(title: const Text("Ohm's Law & Power")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field(_v, 'Voltage (V)'),
          _field(_i, 'Current (A)'),
          _field(_r, 'Resistance (Ω)'),
          _field(_p, 'Power (W)'),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _calculate,
                  child: const Text('Calculate'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(onPressed: _clear, child: const Text('Clear')),
            ],
          ),
          const SizedBox(height: 16),
          Text(_message),
        ],
      ),
    );
  }
}
