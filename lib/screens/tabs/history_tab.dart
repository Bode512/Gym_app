import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../../providers/workout_provider.dart';
import '../../core/theme/theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/workout/set_card.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final workout = Provider.of<WorkoutProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    if (workout.sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.history, size: 56, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              settings.translate('no_activity').toUpperCase(),
              style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 6),
            Text(
              'Completa tu primer entrenamiento para guardarlo aquí.',
              style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: workout.sessions.length,
      itemBuilder: (c, i) {
        final session = workout.sessions[i];
        return Dismissible(
          key: Key(session.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(16)),
            child: const Icon(LucideIcons.trash_2, color: Colors.white, size: 20),
          ),
          onDismissed: (_) => workout.deleteSession(session.id),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: ExpansionTile(
              iconColor: theme.accentColor,
              collapsedIconColor: AppColors.textMuted,
              title: Text(
                session.type,
                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              subtitle: Text(
                "${session.date.day}/${session.date.month}/${session.date.year} • ${session.exercises.length} ${settings.translate('all_sets').toLowerCase()}",
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textSecondary),
              ),
              children: session.exercises.map((s) => SetCard(exerciseSet: s)).toList(),
            ),
          ),
        );
      },
    );
  }
}
