import 'turbine_model.dart';

class GridState {
  final List<TurbineModel> turbines;
  final double totalMegawatts;
  final double stability;
  final double globalWindSpeed;

  const GridState({
    required this.turbines,
    required this.totalMegawatts,
    required this.stability,
    required this.globalWindSpeed,
  });

  factory GridState.initial() {
    return const GridState(
      turbines: [],
      totalMegawatts: 0,
      stability: 100,
      globalWindSpeed: 25.0,
    );
  }
}
