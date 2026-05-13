// Logic for physics, stress, and 500ms Timer
import 'dart:async';
import 'dart:math' as math;
import 'package:aeroflow/core/outer_layer/data/models/turbine_model.dart';
import 'package:aeroflow/core/outer_layer/data/models/grid_state.dart';

class GridEngine {
  GridEngine();

  double _globalWindSpeed = 25.0;

  // The pipe that sends data to the UI
  final _controller = StreamController<GridState>.broadcast();
  Stream<GridState> get gridStream => _controller.stream;
  List<TurbineModel> _turbines = List.generate(6, (i) => TurbineModel(id: i));
  Timer? _timer;

  void start() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), _tick);
  }

  void _tick(Timer timer) {
    List<TurbineModel> updatedTurbines = [];
    double totalPower = 0;
    double totalHealth = 0;

    for (var t in _turbines) {
      // 1. Check if turbine is offline
      if (t.isManualShutdown || t.health <= 0) {
        updatedTurbines.add(
          t.copyWith(powerOutput: 0, health: t.health.clamp(0, 100)),
        );
        totalHealth += t.health.clamp(0, 100);
        continue;
      }

      // 2. Calculate Power Output
      // Power is a function of wind speed and how well the blades are "catching" it
      double rad = t.bladeAngle * (math.pi / 180);
      double efficiency = math.cos(rad);
      double power = (_globalWindSpeed * efficiency * 15).clamp(0, 1200);
      totalPower += power;

      // 3. Mechanical Stress Logic (The Twist)
      double healthDamage = 0;
      if (_globalWindSpeed > 80 && t.bladeAngle < 60) {
        // High wind + shallow blade angle = structural damage
        healthDamage = 2.0;
      } else if (t.health < 100) {
        // Slow recovery if conditions are safe
        healthDamage = -0.2;
      }

      double newHealth = (t.health - healthDamage).clamp(0, 100);
      totalHealth += newHealth;

      updatedTurbines.add(
        t.copyWith(
          windSpeed: _globalWindSpeed,
          powerOutput: power,
          health: newHealth,
        ),
      );
    }

    _turbines = updatedTurbines;

    // Stability calculation: simplified as average health of all turbines
    double stability = (totalHealth / (_turbines.length * 100)) * 100;

    _controller.add(
      GridState(
        turbines: _turbines,
        totalMegawatts: totalPower,
        stability: stability,
        globalWindSpeed: _globalWindSpeed,
      ),
    );
  }

  void setGlobalWind(double value) => _globalWindSpeed = value;

  void updateBladeAngle(int id, double angle) {
    _turbines[id] = _turbines[id].copyWith(bladeAngle: angle);
  }

  void toggleTurbine(int id) {
    _turbines[id] = _turbines[id].copyWith(
      isManualShutdown: !_turbines[id].isManualShutdown,
    );
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
