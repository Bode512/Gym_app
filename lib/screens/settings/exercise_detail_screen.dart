import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/theme/theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/workout_provider.dart';
import '../../models/exercise_set.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final String exerciseName;

  const ExerciseDetailScreen({super.key, required this.exerciseName});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final workout = Provider.of<WorkoutProvider>(context);

    final history = workout.sessions
        .expand((s) => s.exercises)
        .where((e) => e.name == exerciseName.toUpperCase())
        .toList();

    final pb = workout.getPB(exerciseName);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          exerciseName.toUpperCase(),
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (pb != null) _buildPBSection(theme, pb),
          const SizedBox(height: 28),
          _sectionTitle('PROGRESO HISTÓRICO'),
          const SizedBox(height: 14),
          if (history.isNotEmpty) _buildChart(theme, history),
          const SizedBox(height: 28),
          _sectionTitle('TODAS LAS SERIES'),
          const SizedBox(height: 14),
          ...history.map((e) => _buildHistoryItem(theme, e)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(
    t,
    style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 1.5),
  );

  Widget _buildPBSection(ThemeManager theme, ExerciseSet pb) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.trophy, size: 16, color: AppColors.warning),
              const SizedBox(width: 8),
              Text(
                'RÉCORD PERSONAL',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.warning, letterSpacing: 1),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "${pb.weight}kg x ${pb.reps.toInt()}",
            style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            "Conseguido el ${pb.date.day}/${pb.date.month}/${pb.date.year}",
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(ThemeManager theme, List<ExerciseSet> history) {
    final spots = history.reversed.toList().asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.calculateScore());
    }).toList();

    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: LineChart(LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: theme.accentColor,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [theme.accentColor.withOpacity(0.3), theme.accentColor.withOpacity(0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget _buildHistoryItem(ThemeManager theme, ExerciseSet set) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${set.weight}kg x ${set.reps.toInt()}",
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
              ),
              Text(
                "${set.date.day}/${set.date.month}/${set.date.year}",
                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.textMuted),
              ),
            ],
          ),
          if (set.note.isNotEmpty)
            const Icon(LucideIcons.message_square, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
