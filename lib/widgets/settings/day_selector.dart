import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/settings_provider.dart';
import '../../providers/workout_provider.dart';

class DaySelector extends StatelessWidget {
  final String day;
  final String selectedGroup;

  const DaySelector({super.key, required this.day, required this.selectedGroup});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final workout = Provider.of<WorkoutProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final groups = [settings.translate('rest_day'), ...workout.config.groups];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              day,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
          ),
          DropdownButton<String>(
            value: selectedGroup,
            underline: const SizedBox(),
            dropdownColor: theme.cardColor,
            borderRadius: BorderRadius.circular(14),
            items: groups.map((g) => DropdownMenuItem(
              value: g,
              child: Text(
                g,
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: theme.accentColor, fontWeight: FontWeight.bold),
              ),
            )).toList(),
            onChanged: (v) {
              if (v != null) {
                final newPlan = Map<String, String>.from(workout.config.weeklyPlan);
                newPlan[day] = v;
                workout.updateConfig(workout.config.copyWith(weeklyPlan: newPlan));
              }
            },
          )
        ],
      ),
    );
  }
}
