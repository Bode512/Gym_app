import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/workout_provider.dart';

class QuickTimerButtons extends StatelessWidget {
  const QuickTimerButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final workout = Provider.of<WorkoutProvider>(context);

    final presets = [60, 90, 120, 180, 300];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: presets.map((seconds) {
        final bool isDefault = seconds == workout.config.defaultRestSeconds;
        return GestureDetector(
          onTap: () => workout.startRestTimer(customSeconds: seconds),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDefault ? theme.accentColor.withOpacity(0.15) : theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDefault ? theme.accentColor : AppColors.borderDark,
                width: isDefault ? 1.5 : 1.0,
              ),
            ),
            child: Text(
              "${seconds}s",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: isDefault ? theme.accentColor : AppColors.textSecondary,
                fontWeight: isDefault ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
