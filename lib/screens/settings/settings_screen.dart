import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';

import '../../models/workout_config.dart';
import '../../core/theme/theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/settings_provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/user_profile_provider.dart';
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
    final profileProvider = Provider.of<UserProfileProvider>(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          (l10n?.settings ?? 'AJUSTES').toUpperCase(),
          style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _sectionTitle(l10n?.language ?? 'IDIOMA'),
          const SizedBox(height: 12),
          Row(children: [
            _langBtn(context, 'ESPAÑOL', 'es', settings, theme),
            const SizedBox(width: 8),
            _langBtn(context, 'ENGLISH', 'en', settings, theme),
            const SizedBox(width: 8),
            _langBtn(context, 'العربية', 'ar', settings, theme),
          ]),
          const SizedBox(height: 28),

          _sectionTitle(l10n?.personal_goals ?? 'METAS Y ANTROPOMETRÍA'),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 12, bottom: 28),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${l10n?.target_weight ?? 'Peso Objetivo'}: ${profileProvider.profile.targetWeight} kg',
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(LucideIcons.pencil, size: 18, color: theme.accentColor),
                      onPressed: () => _showEditGoalsDialog(context, profileProvider, l10n),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${l10n?.height_cm ?? 'Altura'}: ${profileProvider.profile.heightCm.toInt()} cm',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${l10n?.fitness_goal ?? 'Meta'}: ${profileProvider.profile.fitnessGoal}',
                        style: GoogleFonts.inter(fontSize: 12, color: theme.accentColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          _sectionTitle(l10n?.rest_between_sets ?? 'DESCANSO ENTRE SERIES'),
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
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
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

          _sectionTitle(l10n?.planner_mode ?? 'MODO PLANIFICADOR'),
          const SizedBox(height: 12),
          Row(children: [
            _modeBtn(context, l10n?.cycle ?? 'CICLO', 'sequential', workout.config.plannerMode == 'sequential'),
            const SizedBox(width: 10),
            _modeBtn(context, l10n?.calendar ?? 'CALENDARIO', 'calendar', workout.config.plannerMode == 'calendar'),
          ]),
          const SizedBox(height: 28),

          if (workout.config.plannerMode == 'calendar') ...[
            _sectionTitle(l10n?.day_assignment ?? 'ASIGNACIÓN DE DÍAS'),
            const SizedBox(height: 12),
            ...workout.config.weeklyPlan.keys.map((day) => DaySelector(
              day: day,
              selectedGroup: workout.config.weeklyPlan[day]!,
            )),
          ] else ...[
            Row(
              children: [
                Expanded(child: _sectionTitle(l10n?.cycle_order ?? 'ORDEN DEL CICLO')),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  TextButton.icon(
                    onPressed: () => _showAddGroupDialog(context, workout, l10n),
                    icon: Icon(LucideIcons.plus, size: 14, color: theme.accentColor),
                    label: Text(l10n?.add_group ?? 'AÑADIR', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: theme.accentColor)),
                  ),
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: () => _showRestoreRoutineDialog(context, workout, l10n),
                    icon: Icon(LucideIcons.rotate_ccw, size: 14, color: theme.accentColor),
                    label: Text(l10n?.restore_routine ?? 'RESTAURAR', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: theme.accentColor)),
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
                onDelete: () => _showDeleteGroupDialog(context, workout, entry.key, entry.value, l10n),
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

  Widget _langBtn(BuildContext context, String label, String code, SettingsProvider settings, ThemeManager theme) {
    final isSelected = settings.languageCode == code;
    return Expanded(child: GestureDetector(
      onTap: () {
        settings.setLanguage(code);
        theme.updateRTL(code);
      },
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
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : AppColors.textMuted,
            ),
          ),
        ),
      ),
    ));
  }

  Widget _sectionTitle(String t) => Text(
    t.toUpperCase(),
    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 1.5),
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
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : AppColors.textMuted,
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

  void _showAddGroupDialog(BuildContext context, WorkoutProvider workout, AppLocalizations? l10n) {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (c) => AlertDialog(
      title: Text(l10n?.new_routine ?? 'NUEVA RUTINA'),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        style: GoogleFonts.inter(color: AppColors.textPrimary),
        decoration: const InputDecoration(hintText: 'Ej: BRAZO, PIERNA...'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n?.cancel ?? 'CANCELAR')),
        TextButton(onPressed: () {
          if (ctrl.text.isNotEmpty) {
            final newGroups = List<String>.from(workout.config.groups)..add(ctrl.text.toUpperCase());
            final newDb = Map<String, List<String>>.from(workout.config.exerciseDb)..[ctrl.text.toUpperCase()] = [];
            workout.updateConfig(workout.config.copyWith(groups: newGroups, exerciseDb: newDb));
          }
          Navigator.pop(c);
        }, child: Text(l10n?.confirm ?? 'GUARDAR')),
      ],
    ));
  }

  void _showDeleteGroupDialog(BuildContext context, WorkoutProvider workout, int index, String name, AppLocalizations? l10n) {
    showDialog(context: context, builder: (c) => AlertDialog(
      title: Text(l10n?.delete_exercise ?? 'ELIMINAR'),
      content: Text('${l10n?.confirm ?? '¿Confirmar?'} $name?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n?.cancel ?? 'CANCELAR')),
        TextButton(onPressed: () {
          final newGroups = List<String>.from(workout.config.groups)..removeAt(index);
          workout.updateConfig(workout.config.copyWith(groups: newGroups));
          Navigator.pop(c);
        }, child: Text(l10n?.confirm ?? 'CONFIRMAR', style: const TextStyle(color: AppColors.error))),
      ],
    ));
  }

  void _showRestoreRoutineDialog(BuildContext context, WorkoutProvider workout, AppLocalizations? l10n) {
    showDialog(context: context, builder: (c) {
      return AlertDialog(
        title: Text(l10n?.restore_routine ?? 'RESTAURAR RUTINA'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: ExerciseDatabase.routineStructures.keys.map((name) => ListTile(
              title: Text(name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
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
        actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n?.cancel ?? 'CANCELAR'))],
      );
    });
  }

  void _showEditGoalsDialog(BuildContext context, UserProfileProvider provider, AppLocalizations? l10n) {
    final twCtrl = TextEditingController(text: provider.profile.targetWeight.toString());
    final hCtrl = TextEditingController(text: provider.profile.heightCm.toString());
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n?.personal_goals ?? 'Editar Metas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: twCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n?.target_weight ?? 'Peso Objetivo (kg)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: hCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n?.height_cm ?? 'Altura (cm)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n?.cancel ?? 'CANCELAR')),
          ElevatedButton(
            onPressed: () {
              final tw = double.tryParse(twCtrl.text) ?? provider.profile.targetWeight;
              final h = double.tryParse(hCtrl.text) ?? provider.profile.heightCm;
              provider.updateAntropometrics(
                currentWeight: provider.profile.currentWeight,
                targetWeight: tw,
                heightCm: h,
                fitnessGoal: provider.profile.fitnessGoal,
              );
              Navigator.pop(c);
            },
            child: Text(l10n?.confirm ?? 'GUARDAR'),
          ),
        ],
      ),
    );
  }
}
