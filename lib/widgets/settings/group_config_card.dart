import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../../models/workout_config.dart';
import '../../core/theme/theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/workout_provider.dart';

class GroupConfigCard extends StatelessWidget {
  final String groupName;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onAddExercise;

  const GroupConfigCard({
    super.key,
    required this.groupName,
    required this.index,
    required this.onDelete,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onAddExercise,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final workout = Provider.of<WorkoutProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final exercises = workout.config.exerciseDb[groupName] ?? [];
    final archived = workout.config.archivedExercises[groupName] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  groupName,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary, letterSpacing: 0.5),
                ),
              ),
              IconButton(icon: const Icon(LucideIcons.trash_2, size: 16, color: AppColors.error), onPressed: onDelete),
              IconButton(icon: const Icon(LucideIcons.arrow_up, size: 16, color: AppColors.textSecondary), onPressed: onMoveUp),
              IconButton(icon: const Icon(LucideIcons.arrow_down, size: 16, color: AppColors.textSecondary), onPressed: onMoveDown),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            settings.translate('active_exercises').toUpperCase(),
            style: GoogleFonts.plusJakartaSans(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...exercises.map((ex) => _ExerciseTag(
                    name: ex,
                    onArchive: () {
                      final newDb = Map<String, List<String>>.from(workout.config.exerciseDb);
                      final newArchived = Map<String, List<String>>.from(workout.config.archivedExercises);
                      newDb[groupName]!.remove(ex);
                      newArchived[groupName] ??= [];
                      newArchived[groupName]!.add(ex);
                      workout.updateConfig(workout.config.copyWith(
                        exerciseDb: newDb,
                        archivedExercises: newArchived,
                      ));
                    },
                    onDelete: () => workout.deleteExercise(groupName, ex),
                  )),
              IconButton(
                icon: const Icon(LucideIcons.plus, size: 22, color: AppColors.success),
                onPressed: onAddExercise,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          if (archived.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              settings.translate('archived').toUpperCase(),
              style: GoogleFonts.plusJakartaSans(fontSize: 9, color: AppColors.warning, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: archived.map((ex) => GestureDetector(
                onTap: () {
                  final newDb = Map<String, List<String>>.from(workout.config.exerciseDb);
                  final newArchived = Map<String, List<String>>.from(workout.config.archivedExercises);
                  newArchived[groupName]!.remove(ex);
                  newDb[groupName] ??= [];
                  newDb[groupName]!.add(ex);
                  workout.updateConfig(workout.config.copyWith(
                    exerciseDb: newDb,
                    archivedExercises: newArchived,
                  ));
                },
                child: Chip(
                  backgroundColor: AppColors.surfaceSoft,
                  label: Text(ex, style: GoogleFonts.plusJakartaSans(fontSize: 9, color: AppColors.textMuted)),
                  avatar: const Icon(LucideIcons.rotate_ccw, size: 12, color: AppColors.textMuted),
                ),
              )).toList(),
            ),
          ]
        ],
      ),
    );
  }
}

class _ExerciseTag extends StatelessWidget {
  final String name;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  const _ExerciseTag({required this.name, required this.onArchive, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(name, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textPrimary, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(LucideIcons.archive, size: 13, color: AppColors.warning),
            onPressed: onArchive,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            tooltip: 'Archivar',
          ),
          IconButton(
            icon: const Icon(LucideIcons.x, size: 13, color: AppColors.error),
            onPressed: onDelete,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            tooltip: 'Eliminar',
          ),
        ],
      ),
    );
  }
}
