import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../providers/workout_provider.dart';
import '../../core/theme/theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../models/exercise_set.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final workout = Provider.of<WorkoutProvider>(context);

    if (workout.config.groups.isEmpty) {
      return Center(
        child: Text(
          'No hay rutinas para mostrar estadísticas',
          style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted, fontSize: 13),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: workout.config.groups.map((group) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: ExpansionTile(
          iconColor: theme.accentColor,
          collapsedIconColor: AppColors.textMuted,
          title: Text(
            group,
            style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          children: (workout.config.exerciseDb[group] ?? []).map((ex) {
            final pb = workout.getPB(ex);
            final history = workout.sessions
                .expand((s) => s.exercises)
                .where((e) => e.name == ex.toUpperCase())
                .toList();
            return _StatDetail(exercise: ex, pb: pb, history: history);
          }).toList(),
        ),
      )).toList(),
    );
  }
}

class _StatDetail extends StatelessWidget {
  final String exercise;
  final ExerciseSet? pb;
  final List<ExerciseSet> history;

  const _StatDetail({required this.exercise, this.pb, required this.history});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);

    final spotsStrength = history.reversed.toList().asMap().entries.map((e) {
      double score = e.value.calculateScore();
      return FlSpot(e.key.toDouble(), score);
    }).toList();

    return ExpansionTile(
      title: Text(exercise, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pb != null) const Icon(LucideIcons.trophy, size: 14, color: AppColors.warning),
          const SizedBox(width: 4),
          Text(
            pb != null ? "${pb!.weight}kg" : "-",
            style: GoogleFonts.plusJakartaSans(color: theme.accentColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
      children: [
        if (history.isNotEmpty) ...[
          Container(
            height: 140,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: LineChart(LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spotsStrength,
                  isCurved: true,
                  color: theme.accentColor,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true, 
                    gradient: LinearGradient(
                      colors: [theme.accentColor.withOpacity(0.3), theme.accentColor.withOpacity(0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    )
                  ),
                ),
              ]
            )),
          ),
          ...history.take(5).map((e) => ListTile(
            dense: true,
            title: Text("${e.weight}kg x ${e.reps.toInt()}", style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            subtitle: Text("${e.date.day}/${e.date.month}/${e.date.year}", style: GoogleFonts.plusJakartaSans(fontSize: 9, color: AppColors.textMuted)),
          )).toList(),
        ]
      ],
    );
  }
}
