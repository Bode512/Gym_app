import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../core/theme/theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/pip_service.dart';
import '../../providers/workout_provider.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final workout = Provider.of<WorkoutProvider>(context);

    if (!workout.showTimer) {
      if (_isExpanded) WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _isExpanded = false));
      return const SizedBox.shrink();
    }

    if (_isExpanded) {
      return Positioned.fill(child: _buildExpandedTimer(theme, workout));
    }

    return Positioned(
      bottom: workout.isSessionActive ? 30 : 100,
      right: 20,
      child: GestureDetector(
        onTap: () => setState(() => _isExpanded = true),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.accentColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: theme.accentColor.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.timer, color: theme.accentColor, size: 18),
              const SizedBox(width: 8),
              Text(
                "${(workout.secondsLeft ~/ 60)}:${(workout.secondsLeft % 60).toString().padLeft(2, '0')}",
                style: GoogleFonts.outfit(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => PipService().enterPip(),
                child: const Icon(LucideIcons.minimize_2, color: AppColors.textSecondary, size: 16),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => workout.stopTimer(),
                child: const Icon(LucideIcons.x, color: AppColors.textMuted, size: 16),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedTimer(ThemeManager theme, WorkoutProvider workout) {
    return Container(
      color: Colors.black.withOpacity(0.95),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.timer, color: workout.secondsLeft == 0 ? AppColors.error : theme.accentColor, size: 80),
                const SizedBox(height: 20),
                Text(
                  "${(workout.secondsLeft ~/ 60)}:${(workout.secondsLeft % 60).toString().padLeft(2, '0')}",
                  style: GoogleFonts.outfit(
                    color: workout.secondsLeft == 0 ? AppColors.error : Colors.white,
                    fontSize: 110,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    letterSpacing: -4,
                    shadows: [
                      Shadow(color: (workout.secondsLeft == 0 ? AppColors.error : theme.accentColor).withOpacity(0.5), blurRadius: 30)
                    ]
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (workout.secondsLeft > 0) ...[
                      _extraBtn("+30s", () => workout.startRestTimer(customSeconds: workout.secondsLeft + 30)),
                      const SizedBox(width: 16),
                      _extraBtn("PiP", () => PipService().enterPip(), color: theme.accentColor),
                      const SizedBox(width: 16),
                      _extraBtn("PARAR", () => workout.stopTimer(), color: AppColors.error),
                    ] else ...[
                      _extraBtn("REPETIR", () => workout.startRestTimer(), color: theme.accentColor),
                      const SizedBox(width: 16),
                      _extraBtn("CERRAR", () => workout.stopTimer(), color: AppColors.surfaceSoft),
                    ],
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: const Icon(LucideIcons.x, color: Colors.white, size: 28),
              onPressed: () => setState(() => _isExpanded = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _extraBtn(String label, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: color ?? AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }
}
