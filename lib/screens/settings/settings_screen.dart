import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../models/workout_config.dart';
import '../../core/theme/theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/settings_provider.dart';
import '../../providers/workout_provider.dart';
import '../../widgets/settings/group_config_card.dart';
import '../../widgets/settings/day_selector.dart';
import '../../widgets/settings/exercise_manager.dart';
import '../../core/constants/exercise_database.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final workout = Provider.of<WorkoutProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          settings.translate('settings').toUpperCase(),
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _sectionTitle(settings.translate('language')),
          const SizedBox(height: 12),
          Row(children: [
            _langBtn(context, 'ESPAÑOL', 'es', settings),
            const SizedBox(width: 8),
            _langBtn(context, 'ENGLISH', 'en', settings),
            const SizedBox(width: 8),
            _langBtn(context, 'العربية', 'ar', settings),
          ]),
          const SizedBox(height: 28),

          _sectionTitle(settings.translate('rest_between_sets')),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            margin: const EdgeInsets.only(top: 12, bottom: 28),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Row(children: [
              Text(
                '${workout.config.defaultRestSeconds}s',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(LucideIcons.minus, color: AppColors.textSecondary, size: 20), 
                onPressed: () => workout.updateConfig(workout.config.copyWith(
                  defaultRestSeconds: (workout.config.defaultRestSeconds - 10).clamp(30, 600),
                )),
              ),
              IconButton(
                icon: const Icon(LucideIcons.plus, color: AppColors.textSecondary, size: 20), 
                onPressed: () => workout.updateConfig(workout.config.copyWith(
                  defaultRestSeconds: (workout.config.defaultRestSeconds + 10).clamp(30, 600),
                )),
              ),
            ]),
          ),

          _sectionTitle(settings.translate('planner_mode')),
          const SizedBox(height: 12),
          Row(children: [
            _modeBtn(context, settings.translate('cycle'), 'sequential', workout.config.plannerMode == 'sequential'),
            const SizedBox(width: 10),
            _modeBtn(context, settings.translate('calendar'), 'calendar', workout.config.plannerMode == 'calendar'),
          ]),
          const SizedBox(height: 28),

          if (workout.config.plannerMode == 'calendar') ...[
            _sectionTitle(settings.translate('day_assignment')),
            const SizedBox(height: 12),
            ...workout.config.weeklyPlan.keys.map((day) => DaySelector(
              day: day,
              selectedGroup: workout.config.weeklyPlan[day]!,
            )),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionTitle(settings.translate('cycle_order')),
                Row(children: [
                  TextButton.icon(
                    onPressed: () => _showAddGroupDialog(context, workout, settings),
                    icon: Icon(LucideIcons.plus, size: 14, color: theme.accentColor),
                    label: Text(settings.translate('add_group'), style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: theme.accentColor)),
                  ),
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: () => _showRestoreRoutineDialog(context, workout, settings),
                    icon: Icon(LucideIcons.rotate_ccw, size: 14, color: theme.accentColor),
                    label: Text(settings.translate('restore_routine'), style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: theme.accentColor)),
                  ),
                ]),
              ],
            ),
            const SizedBox(height: 12),
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex -= 1;
                final newGroups = List<String>.from(workout.config.groups);
                final item = newGroups.removeAt(oldIndex);
                newGroups.insert(newIndex, item);
                workout.updateConfig(workout.config.copyWith(groups: newGroups));
              },
              children: workout.config.groups.asMap().entries.map((entry) => GroupConfigCard(
                key: ValueKey(entry.value),
                groupName: entry.value,
                index: entry.key,
                onDelete: () => _showDeleteGroupDialog(context, workout, entry.key, entry.value, settings),
                onMoveUp: () => _moveGroup(workout, entry.key, -1),
                onMoveDown: () => _moveGroup(workout, entry.key, 1),
                onAddExercise: () => showDialog(
                  context: context, 
                  builder: (c) => ExerciseSearchDialog(onSelected: (ex) {
                    final newDb = Map<String, List<String>>.from(workout.config.exerciseDb);
                    newDb[entry.value] ??= [];
                    if (!newDb[entry.value]!.contains(ex)) {
                      newDb[entry.value]!.add(ex);
                      workout.updateConfig(workout.config.copyWith(exerciseDb: newDb));
                    }
                  }),
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _langBtn(BuildContext context, String label, String code, SettingsProvider settings) {
    final isSelected = settings.languageCode == code;
    final theme = Provider.of<ThemeManager>(context);
    return Expanded(child: GestureDetector(
      onTap: () => settings.setLanguage(code),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.accentColor : theme.cardColor, 
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? theme.accentColor : AppColors.borderDark),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.textMuted,
            ),
          ),
        ),
      ),
    ));
  }

  Widget _sectionTitle(String t) => Text(
    t.toUpperCase(),
    style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 1.5),
  );

  Widget _modeBtn(BuildContext context, String l, String m, bool isSelected) {
    final theme = Provider.of<ThemeManager>(context);
    final workout = Provider.of<WorkoutProvider>(context);
    return Expanded(child: GestureDetector(
      onTap: () => workout.updateConfig(workout.config.copyWith(plannerMode: m)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? theme.accentColor : theme.cardColor, 
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? theme.accentColor : AppColors.borderDark),
        ),
        child: Center(
          child: Text(
            l.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.textMuted,
            ),
          ),
        ),
      ),
    ));
  }

  void _moveGroup(WorkoutProvider workout, int index, int delta) {
    if (index + delta < 0 || index + delta >= workout.config.groups.length) return;
    final newGroups = List<String>.from(workout.config.groups);
    final item = newGroups.removeAt(index);
    newGroups.insert(index + delta, item);
    workout.updateConfig(workout.config.copyWith(groups: newGroups));
  }

  void _showAddGroupDialog(BuildContext context, WorkoutProvider workout, SettingsProvider settings) {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (c) => AlertDialog(
      title: Text(settings.translate('new_routine')),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary),
        decoration: const InputDecoration(hintText: 'Ej: BRAZO, PIERNA...'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text(settings.translate('cancel'))),
        TextButton(onPressed: () {
          if (ctrl.text.isNotEmpty) {
            final newGroups = List<String>.from(workout.config.groups)..add(ctrl.text.toUpperCase());
            final newDb = Map<String, List<String>>.from(workout.config.exerciseDb)..[ctrl.text.toUpperCase()] = [];
            workout.updateConfig(workout.config.copyWith(groups: newGroups, exerciseDb: newDb));
          }
          Navigator.pop(c);
        }, child: Text(settings.translate('confirm'))),
      ],
    ));
  }

  void _showDeleteGroupDialog(BuildContext context, WorkoutProvider workout, int index, String name, SettingsProvider settings) {
    showDialog(context: context, builder: (c) => AlertDialog(
      title: Text(settings.translate('delete_exercise')),
      content: Text('${settings.translate('confirm')} $name?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text(settings.translate('cancel'))),
        TextButton(onPressed: () {
          final newGroups = List<String>.from(workout.config.groups)..removeAt(index);
          workout.updateConfig(workout.config.copyWith(groups: newGroups));
          Navigator.pop(c);
        }, child: Text(settings.translate('confirm'), style: const TextStyle(color: AppColors.error))),
      ],
    ));
  }

  void _showRestoreRoutineDialog(BuildContext context, WorkoutProvider workout, SettingsProvider settings) {
    showDialog(context: context, builder: (c) {
      return AlertDialog(
        title: Text(settings.translate('restore_routine')),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: ExerciseDatabase.routineStructures.keys.map((name) => ListTile(
              title: Text(name, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600)),
              trailing: const Icon(LucideIcons.chevron_right, size: 16),
              onTap: () {
                final prevConfig = workout.config;
                final chosen = ExerciseDatabase.routineStructures[name] ?? [];
                final newGroups = List<String>.from(chosen);
                final newDb = Map<String, List<String>>.from(workout.config.exerciseDb);
                for (final g in chosen) {
                  if (!newDb.containsKey(g)) {
                    newDb[g] = ExerciseDatabase.defaultExerciseDb[g] != null
                        ? List<String>.from(ExerciseDatabase.defaultExerciseDb[g]!)
                        : [];
                  }
                }

                final defaultCfg = WorkoutConfig.defaultConfig();
                final merged = defaultCfg.copyWith(
                  groups: newGroups,
                  exerciseDb: newDb,
                  archivedExercises: workout.config.archivedExercises,
                );
                workout.updateConfig(merged);
                Navigator.pop(c);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Rutina aplicada: $name'),
                  action: SnackBarAction(label: 'Deshacer', onPressed: () {
                    workout.updateConfig(prevConfig);
                  }),
                  duration: const Duration(seconds: 6),
                ));
              },
            )).toList(),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text(settings.translate('cancel')))],
      );
    });
  }
}
