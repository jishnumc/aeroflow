import 'package:flutter/material.dart';
import 'package:aeroflow/core/outer_layer/data/models/turbine_model.dart';

class TurbineCard extends StatelessWidget {
  final TurbineModel turbine;
  final ValueChanged<double>? onBladeAngleChanged;
  final VoidCallback? onToggleMaintenance;

  const TurbineCard({
    super.key,
    required this.turbine,
    this.onBladeAngleChanged,
    this.onToggleMaintenance,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(turbine.status);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Turbine ${turbine.id + 1}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusBadge(status: turbine.status, color: statusColor),
              ],
            ),
            const SizedBox(height: 8),
            _StatRow(label: 'Power', value: '${turbine.powerOutput.toStringAsFixed(1)} MW'),
            const SizedBox(height: 4),
            const Text('Health', style: TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 2),
            LinearProgressIndicator(
              value: turbine.health / 100,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 4,
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            const Text('Blade Angle', style: TextStyle(fontSize: 11, color: Colors.grey)),
            SizedBox(
              height: 32,
              child: Slider(
                value: turbine.bladeAngle,
                min: 0,
                max: 90,
                divisions: 90,
                label: '${turbine.bladeAngle.round()}°',
                onChanged: onBladeAngleChanged,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Maintenance',
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 32,
                  child: Switch(
                    value: turbine.isManualShutdown,
                    onChanged: (value) => onToggleMaintenance?.call(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TurbineStatus status) {
    switch (status) {
      case TurbineStatus.optimal:
        return Colors.green;
      case TurbineStatus.warning:
        return Colors.orange;
      case TurbineStatus.critical:
        return Colors.red;
      case TurbineStatus.offline:
        return Colors.grey;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final TurbineStatus status;
  final Color color;

  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }
}
