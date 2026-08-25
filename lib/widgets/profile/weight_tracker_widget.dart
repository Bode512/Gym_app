import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_manager.dart';
import '../../providers/user_profile_provider.dart';
import '../../models/user_profile.dart';

class WeightTrackerWidget extends StatelessWidget {
  const WeightTrackerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final profileProvider = Provider.of<UserProfileProvider>(context);
    final l10n = AppLocalizations.of(context);
    final profile = profileProvider.profile;

    final history = profile.weightHistory;
    final current = profile.currentWeight;
    final target = profile.targetWeight;

    // Calcular progreso
    final startWeight = profile.startDate.isBefore(history.first.date)
        ? history.first.weight
        : profile.currentWeight;
    final totalDiff = (target - startWeight).abs();
    final currentDiff = (current - startWeight).abs();
    final remaining = (target - current).abs();
    
    double progressPercent = 0.0;
    if (totalDiff > 0) {
      progressPercent = (currentDiff / totalDiff).clamp(0.0, 1.0);
    } else if (current == target) {
      progressPercent = 1.0;
    }

    final isGoalAchieved = remaining < 0.1 || (startWeight > target && current <= target) || (startWeight < target && current >= target);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tarjeta resumen de meta
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.scale, color: theme.accentColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        l10n?.weight_journal ?? 'DIARIO DE PESO',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(LucideIcons.circle_plus, color: theme.accentColor, size: 22),
                    onPressed: () => _showAddWeightDialog(context, profileProvider, l10n),
                    tooltip: l10n?.add_weight_entry ?? 'Registrar Peso',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _weightStat(l10n?.current_weight ?? 'Actual', '${current.toStringAsFixed(1)} kg', theme.accentColor)),
                  const SizedBox(width: 8),
                  Expanded(child: _weightStat(l10n?.target_weight ?? 'Objetivo', '${target.toStringAsFixed(1)} kg', AppColors.textPrimary)),
                  const SizedBox(width: 8),
                  Expanded(child: _weightStat(
                    l10n?.fitness_goal ?? 'Meta',
                    _getGoalLabel(profile.fitnessGoal, l10n),
                    AppColors.textSecondary,
                  )),
                ],
              ),
              const SizedBox(height: 16),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progressPercent,
                  minHeight: 8,
                  backgroundColor: AppColors.surfaceSoft,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.accentColor),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isGoalAchieved
                    ? (l10n?.goal_achieved ?? '¡Felicidades! Has alcanzado tu peso objetivo.')
                    : (l10n?.weight_progress_summary(remaining.toStringAsFixed(1), (progressPercent * 100).toInt().toString()) ??
                        'Te faltan ${remaining.toStringAsFixed(1)} kg para tu objetivo'),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isGoalAchieved ? AppColors.success : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Gráfico fl_chart si hay historial
        if (history.isNotEmpty)
          Container(
            height: 240,
            padding: const EdgeInsets.fromLTRB(8, 20, 16, 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 8),
                  child: Text(
                    (l10n?.weight_journal ?? 'PROGRESO DE PESO').toUpperCase(),
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 1.2),
                  ),
                ),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      minY: (history.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 2).clamp(0, double.infinity),
                      maxY: history.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 2,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => const FlLine(
                          color: AppColors.borderSubtle,
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: history.length > 7 ? (history.length / 5).ceilToDouble() : 1,
                            getTitlesWidget: (val, meta) {
                              final index = val.toInt();
                              if (index >= 0 && index < history.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    DateFormat('d/M').format(history[index].date),
                                    style: GoogleFonts.inter(fontSize: 9, color: AppColors.textMuted),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (val, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  '${val.toStringAsFixed(0)}kg',
                                  style: GoogleFonts.inter(fontSize: 9, color: AppColors.textMuted),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final idx = spot.x.toInt();
                              final dateStr = idx >= 0 && idx < history.length
                                  ? DateFormat('d MMM yyyy', 'es').format(history[idx].date)
                                  : '';
                              return LineTooltipItem(
                                '${spot.y.toStringAsFixed(1)} kg\n$dateStr',
                                GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              );
                            }).toList();
                          },
                        ),
                        handleBuiltInTouches: true,
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: history.asMap().entries.map((e) {
                            return FlSpot(e.key.toDouble(), e.value.weight);
                          }).toList(),
                          isCurved: true,
                          color: theme.accentColor,
                          barWidth: 2.5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: theme.accentColor,
                                strokeWidth: 2,
                                strokeColor: theme.cardColor,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: theme.accentColor.withOpacity(0.08),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _weightStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted, letterSpacing: 0.8),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: color),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _getGoalLabel(String key, AppLocalizations? l10n) {
    switch (key) {
      case 'fat_loss': return l10n?.goal_fat_loss ?? 'Perder Grasa';
      case 'maintain': return l10n?.goal_maintain ?? 'Mantener';
      case 'strength': return l10n?.goal_strength ?? 'Fuerza';
      case 'muscle':
      default: return l10n?.goal_muscle ?? 'Ganar Músculo';
    }
  }

  void _showAddWeightDialog(BuildContext context, UserProfileProvider provider, AppLocalizations? l10n) {
    final controller = TextEditingController(text: provider.profile.currentWeight.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.add_weight_entry ?? 'Registrar Peso'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n?.current_weight ?? 'Peso (kg)',
            suffixText: 'kg',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.cancel ?? 'CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null && val > 0) {
                provider.addWeightEntry(val);
                Navigator.pop(context);
              }
            },
            child: Text(l10n?.confirm ?? 'GUARDAR'),
          ),
        ],
      ),
    );
  }
}
