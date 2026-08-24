import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../../core/constants/exercise_database.dart';
import '../../models/workout_config.dart';
import '../../providers/workout_provider.dart';
import '../../core/theme/theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/workout/exercise_chip.dart';
import '../../widgets/workout/set_card.dart';
import '../../widgets/workout/exercise_history_card.dart';
import '../../widgets/workout/quick_timer_buttons.dart';
import '../../widgets/common/custom_input.dart';
import '../../widgets/common/custom_button.dart';

class WorkoutTab extends StatefulWidget {
  const WorkoutTab({super.key});

  @override
  State<WorkoutTab> createState() => _WorkoutTabState();
}

class _WorkoutTabState extends State<WorkoutTab> {
  final TextEditingController _weightCtrl = TextEditingController();
  final TextEditingController _repsCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _weightCtrl.dispose();
    _repsCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workout = Provider.of<WorkoutProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    if (workout.isSessionActive) {
      return _buildActiveWorkout(workout, settings);
    }

    return _buildInactiveWorkout(workout, settings);
  }

  Widget _buildInactiveWorkout(WorkoutProvider workout, SettingsProvider settings) {
    final theme = Provider.of<ThemeManager>(context);
    final suggestion = workout.getSuggestion();

    // Estado vacío: no hay grupos configurados
    if (workout.config.groups.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.dumbbell, size: 64, color: AppColors.textMuted),
              const SizedBox(height: 20),
              Text(
                'No hay rutinas configuradas',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Parece que tu configuración está vacía. Restaura los ejercicios por defecto para comenzar.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  final defaults = WorkoutConfig.defaultConfig();
                  workout.updateConfig(defaults);
                },
                icon: const Icon(LucideIcons.rotate_ccw, size: 18),
                label: const Text('Restaurar ejercicios por defecto'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        GestureDetector(
          onTap: () => suggestion['type'] == 'DESCANSO' ? null : _attemptStartWorkout(context, workout, settings, suggestion['type']!),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: suggestion['type'] == 'DESCANSO' 
                  ? const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF0B0E14)]) 
                  : LinearGradient(colors: [theme.accentColor.withOpacity(0.9), theme.accentColor]),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: theme.accentColor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                settings.translate('onboarding_title').toUpperCase(),
                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white70, letterSpacing: 1.5),
              ),
              const SizedBox(height: 4),
              Text(
                suggestion['type']!,
                style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(LucideIcons.sparkles, size: 14, color: Colors.white70),
                  const SizedBox(width: 6),
                  Text(
                    suggestion['reason']!,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white90, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ]),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          settings.translate('active_exercises').toUpperCase(),
          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 1.5),
        ),
        const SizedBox(height: 14),
        ...workout.config.groups.map((group) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: theme.cardColor, 
            borderRadius: BorderRadius.circular(20), 
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              title: Text(
                group,
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
              ),
              trailing: Icon(LucideIcons.chevron_right, size: 18, color: theme.accentColor),
              onTap: () => _attemptStartWorkout(context, workout, settings, group),
            ),
          ),
        )).toList(),
      ],
    );
  }

  void _attemptStartWorkout(BuildContext context, WorkoutProvider workout, SettingsProvider settings, String group) {
    final exercises = workout.config.exerciseDb[group] ?? [];
    if (exercises.isNotEmpty) {
      workout.startWorkout(group);
      return;
    }

    showDialog(context: context, builder: (c) => AlertDialog(
      title: Text('Iniciar $group'),
      content: const Text('Esta rutina no tiene ejercicios. ¿Qué quieres hacer?'),
      actions: [
        TextButton(onPressed: () {
          final defaults = ExerciseDatabase.defaultExerciseDb[group];
          if (defaults != null) {
            final newDb = Map<String, List<String>>.from(workout.config.exerciseDb);
            newDb[group] = List<String>.from(defaults);
            workout.updateConfig(workout.config.copyWith(exerciseDb: newDb));
            workout.startWorkout(group);
          } else {
            workout.startWorkout(group);
          }
          Navigator.pop(c);
        }, child: const Text('Usar ejercicios por defecto')),
        TextButton(onPressed: () {
          workout.startWorkout(group);
          Navigator.pop(c);
        }, child: const Text('Empezar vacío')),
        TextButton(onPressed: () => Navigator.pop(c), child: const Text('Volver')),
      ],
    ));
  }

  Widget _buildActiveWorkout(WorkoutProvider workout, SettingsProvider settings) {
    final theme = Provider.of<ThemeManager>(context);
    final pb = workout.getPB(workout.selectedExercise);
    final last = workout.getLastTime(workout.selectedExercise);

    return SizedBox.expand(child: Column(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: const Border(bottom: BorderSide(color: AppColors.borderDark)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => _showCancelDialog(context, workout, settings),
                  icon: const Icon(LucideIcons.x, color: AppColors.textSecondary, size: 18),
                  label: Text(settings.translate('back') ?? 'Volver', style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary)),
                ),
                Text(
                  settings.translate('training').toUpperCase(),
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: 1),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: workout.isPaused ? settings.translate('resume') : settings.translate('pause'),
                    onPressed: () => workout.isPaused ? workout.resumeWorkout() : workout.pauseWorkout(),
                    color: workout.isPaused ? AppColors.success : AppColors.warning,
                    icon: workout.isPaused ? LucideIcons.play : LucideIcons.pause,
                    fullWidth: false,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PrimaryButton(
                    label: settings.translate('finish_workout'),
                    onPressed: () => workout.finishWorkout(),
                    color: AppColors.error,
                    icon: LucideIcons.check,
                    fullWidth: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Builder(builder: (_) {
              final exercises = workout.activeExercises;
              if (exercises.isEmpty) {
                return Column(children: [
                  const SizedBox(height: 20),
                  Text('No hay ejercicios para esta rutina.', style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted)),
                  const SizedBox(height: 16),
                  Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: [
                    ElevatedButton(
                      onPressed: () => _showContinueDialog(context, workout, settings),
                      child: Text(settings.translate('continue_training') ?? 'Continuar entrenamiento'),
                    ),
                    ElevatedButton(
                      onPressed: () => workout.cancelWorkout(),
                      child: Text(settings.translate('back_home') ?? 'Volver a inicio'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                      onPressed: () => workout.finishWorkout(),
                      child: Text(settings.translate('finish_workout') ?? 'Finalizar entrenamiento'),
                    ),
                  ]),
                ]);
              }
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: exercises.map((ex) => ExerciseChip(
                  label: ex,
                  isSelected: workout.selectedExercise == ex,
                  onTap: () => workout.setSelectedExercise(ex),
                )).toList(),
              );
            }),
            const SizedBox(height: 24),
            if (pb != null) ExerciseHistoryCard(title: "RÉCORD PERSONAL", exerciseSet: pb, isPB: true, onCopy: () => _weightCtrl.text = pb.weight.toString()),
            if (last != null && pb?.id != last.id) ...[
              const SizedBox(height: 10),
              ExerciseHistoryCard(title: "ÚLTIMA VEZ", exerciseSet: last, isPB: false, onCopy: () => _weightCtrl.text = last.weight.toString()),
            ],
            const SizedBox(height: 24),
            Row(children: [
              NumberInput(controller: _weightCtrl, label: 'PESO (KG)'),
              const SizedBox(width: 12),
              NumberInput(controller: _repsCtrl, label: 'REPS'),
            ]),
            const SizedBox(height: 12),
            CustomInput(controller: _noteCtrl, label: 'NOTA DE LA SERIE', hint: '¿Cómo te has sentido?'),
            const SizedBox(height: 14),
            const QuickTimerButtons(),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'GUARDAR SERIE',
              icon: LucideIcons.plus_circle,
              onPressed: () {
                if (_weightCtrl.text.isNotEmpty && _repsCtrl.text.isNotEmpty) {
                  workout.addSet(
                    workout.selectedExercise,
                    double.parse(_weightCtrl.text.replaceAll(',', '.')),
                    double.parse(_repsCtrl.text.replaceAll(',', '.')),
                    _noteCtrl.text,
                  );
                  _weightCtrl.clear();
                  _repsCtrl.clear();
                  _noteCtrl.clear();
                }
              },
            ),
            const SizedBox(height: 24),
            ...workout.currentSessionExercises.map((s) => SetCard(exerciseSet: s)).toList(),
          ],
        ),
      ),
    ]));
  }

  void _showCancelDialog(BuildContext context, WorkoutProvider workout, SettingsProvider settings) {
    showDialog(context: context, builder: (c) => AlertDialog(
      title: Text(settings.translate('exit_workout')),
      content: const Text('¿Seguro que quieres salir? Se perderá el progreso de esta sesión.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text(settings.translate('cancel'))),
        TextButton(onPressed: () {
          workout.cancelWorkout();
          Navigator.pop(c);
        }, child: Text(settings.translate('confirm'), style: const TextStyle(color: AppColors.error))),
      ],
    ));
  }

  void _showContinueDialog(BuildContext context, WorkoutProvider workout, SettingsProvider settings) {
    showDialog(context: context, builder: (c) {
      return AlertDialog(
        title: const Text('Continuar entrenamiento'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: workout.config.groups.map((g) => ListTile(
              title: Text(g),
              onTap: () {
                workout.continueWithGroup(g);
                Navigator.pop(c);
              },
            )).toList(),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text(settings.translate('cancel')))],
      );
    });
  }
}
