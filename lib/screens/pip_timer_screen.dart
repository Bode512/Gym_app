import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../core/theme/theme_manager.dart';
import '../core/theme/app_theme.dart';
import '../providers/workout_provider.dart';

class PipTimerScreen extends StatelessWidget {
  const PipTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final workout = Provider.of<WorkoutProvider>(context);

    final bool isDone = workout.secondsLeft <= 0;
    final String minutes = (workout.secondsLeft ~/ 60).toString();
    final String seconds = (workout.secondsLeft % 60).toString().padLeft(2, '0');
    final Color accentColor = isDone ? AppColors.error : theme.accentColor;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.timer,
                    size: 16,
                    color: accentColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isDone ? '¡TIEMPO!' : 'DESCANSO',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: isDone ? AppColors.error : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "$minutes:$seconds",
                  style: GoogleFonts.outfit(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    color: isDone ? AppColors.error : AppColors.textPrimary,
                    shadows: [
                      Shadow(
                        color: accentColor.withOpacity(0.5),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isDone) ...[
                    _buildMiniButton(
                      label: "+30s",
                      onTap: () => workout.startRestTimer(customSeconds: workout.secondsLeft + 30),
                      color: AppColors.surfaceSoft,
                      textColor: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 8),
                    _buildMiniButton(
                      label: "STOP",
                      onTap: () => workout.stopTimer(),
                      color: AppColors.error.withOpacity(0.2),
                      textColor: AppColors.error,
                    ),
                  ] else ...[
                    _buildMiniButton(
                      label: "REPETIR",
                      onTap: () => workout.startRestTimer(),
                      color: theme.accentColor,
                      textColor: Colors.white,
                    ),
                  ],
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniButton({
    required String label,
    required VoidCallback onTap,
    required Color color,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
