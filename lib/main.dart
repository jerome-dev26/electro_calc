import 'package:material_ui/material_ui.dart';
import 'screens/ohms_law_screen.dart';
import 'screens/voltage_drop_screen.dart';
import 'screens/three_phase_screen.dart';

void main() => runApp(const ElectroCalcApp());

class ElectroCalcApp extends StatelessWidget {
  const ElectroCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElectroCalc',
      theme: ThemeData(colorSchemeSeed: Colors.amber, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.amber,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class _CalcEntry {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget screen;
  const _CalcEntry(this.icon, this.title, this.subtitle, this.screen);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const entries = [
      _CalcEntry(Icons.bolt, "Ohm's Law & Power", 'Volts, amps, ohms, watts',
          OhmsLawScreen()),
      _CalcEntry(Icons.trending_down, 'Voltage Drop',
          'Single and three-phase cables', VoltageDropScreen()),
      _CalcEntry(Icons.electrical_services, 'Three-Phase Power',
          'kW, kVA, kVAr and amps', ThreePhaseScreen()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('ElectroCalc')),
      body: ListView(
        children: [
          for (final e in entries)
            ListTile(
              leading: Icon(e.icon),
              title: Text(e.title),
              subtitle: Text(e.subtitle),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => e.screen),
              ),
            ),
        ],
      ),
    );
  }
}
