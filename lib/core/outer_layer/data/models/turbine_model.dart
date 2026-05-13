enum TurbineStatus { optimal, warning, critical, offline }

class TurbineModel {
  final int id;
  final double windSpeed;
  final double bladeAngle;
  final double health;
  final double powerOutput;
  final bool isManualShutdown;

  const TurbineModel({
    required this.id,
    this.windSpeed = 20.0,
    this.bladeAngle = 30.0,
    this.health = 100.0,
    this.powerOutput = 0.0,
    this.isManualShutdown = false,
  });

  TurbineStatus get status {
    if (isManualShutdown || health <= 0) return TurbineStatus.offline;
    if (health < 30) return TurbineStatus.critical;
    if (health < 70) return TurbineStatus.warning;
    return TurbineStatus.optimal;
  }

  TurbineModel copyWith({
    double? windSpeed,
    double? bladeAngle,
    double? health,
    double? powerOutput,
    bool? isManualShutdown,
  }) {
    return TurbineModel(
      id: id,
      windSpeed: windSpeed ?? this.windSpeed,
      bladeAngle: bladeAngle ?? this.bladeAngle,
      health: health ?? this.health,
      powerOutput: powerOutput ?? this.powerOutput,
      isManualShutdown: isManualShutdown ?? this.isManualShutdown,
    );
  }
}
