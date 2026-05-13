import 'package:flutter/material.dart';
import 'package:aeroflow/core/outer_layer/data/models/grid_state.dart';
import 'package:aeroflow/core/outer_layer/data/models/turbine_model.dart';
import 'turbine_card.dart';

class TurbineGrid extends StatefulWidget {
  const TurbineGrid({super.key});

  @override
  State<TurbineGrid> createState() => _TurbineGridState();
}

class _TurbineGridState extends State<TurbineGrid> {
  // Mock local state for UI demonstration
  double _globalWindSpeed = 25.0;
  List<TurbineModel> _turbines = List.generate(6, (i) => TurbineModel(id: i));

  GridState get _currentState {
    double totalPower = 0;
    double totalHealth = 0;
    for (var t in _turbines) {
      totalPower += t.powerOutput;
      totalHealth += t.health;
    }
    return GridState(
      turbines: _turbines,
      totalMegawatts: totalPower,
      stability: (totalHealth / (_turbines.length * 100)) * 100,
      globalWindSpeed: _globalWindSpeed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _currentState;

    return Column(
      children: [
        _buildGlobalControls(state),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.turbines.length,
            itemBuilder: (context, index) {
              return TurbineCard(
                turbine: state.turbines[index],
                onBladeAngleChanged: (value) {
                  setState(() {
                    _turbines[index] = _turbines[index].copyWith(bladeAngle: value);
                  });
                },
                onToggleMaintenance: () {
                  setState(() {
                    _turbines[index] = _turbines[index].copyWith(
                      isManualShutdown: !_turbines[index].isManualShutdown,
                    );
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGlobalControls(GridState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.1),
        border: const Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatIndicator(
                label: 'TOTAL POWER',
                value: '${state.totalMegawatts.toStringAsFixed(1)} MW',
                icon: Icons.bolt,
                color: Colors.amber,
              ),
              _StatIndicator(
                label: 'GRID STABILITY',
                value: '${state.stability.toStringAsFixed(1)}%',
                icon: Icons.security,
                color: state.stability > 80 ? Colors.green : (state.stability > 50 ? Colors.orange : Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.air, color: Colors.blue),
              const SizedBox(width: 10),
              const Text('Global Wind Speed'),
              Expanded(
                child: Slider(
                  value: _globalWindSpeed,
                  min: 0,
                  max: 120,
                  divisions: 120,
                  label: '${_globalWindSpeed.round()} km/h',
                  onChanged: (value) {
                    setState(() {
                      _globalWindSpeed = value;
                    });
                  },
                ),
              ),
              Text(
                '${_globalWindSpeed.round()} km/h',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatIndicator extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatIndicator({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey, letterSpacing: 1.2),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
