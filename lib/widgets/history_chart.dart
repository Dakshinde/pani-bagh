import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoryChart extends StatelessWidget {
  final List<double> recentLevels;

  const HistoryChart({super.key, required this.recentLevels});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: recentLevels.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value);
              }).toList(),
              isCurved: true,
              color: Colors.blue.shade700,
              barWidth: 4,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                // FIXED: Changed withOpacity to withValues
                color: Colors.blue.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}