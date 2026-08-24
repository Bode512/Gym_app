import '../models/exercise_set.dart';
import '../models/training_session.dart';
import '../models/workout_config.dart';

class ProgressionSuggestion {
  final String exerciseName;
  final double previousWeight;
  final double previousReps;
  final double suggestedWeight;
  final double suggestedReps;
  final double weightDelta;
  final String reason;
  final String title;
  final bool isFirstTime;

  ProgressionSuggestion({
    required this.exerciseName,
    required this.previousWeight,
    required this.previousReps,
    required this.suggestedWeight,
    required this.suggestedReps,
    required this.weightDelta,
    required this.reason,
    required this.title,
    this.isFirstTime = false,
  });
}

class WorkoutService {
  // Calcular récord personal (PR/PB) para un ejercicio
  static ExerciseSet? getPB(List<TrainingSession> sessions, String exerciseName) {
    final String searchName = exerciseName.toUpperCase();
    final allSets = sessions
        .expand((s) => s.exercises)
        .where((e) => e.name == searchName)
        .toList();

    if (allSets.isEmpty) return null;

    return allSets.reduce((a, b) => a.calculateScore() > b.calculateScore() ? a : b);
  }

  // Obtener la última vez que se realizó un ejercicio
  static ExerciseSet? getLastTime(List<TrainingSession> sessions, String exerciseName) {
    final String searchName = exerciseName.toUpperCase();
    for (var session in sessions) {
      for (var exercise in session.exercises) {
        if (exercise.name == searchName) return exercise;
      }
    }
    return null;
  }

  // Algoritmo de Sobrecarga Progresiva Adaptativa
  static ProgressionSuggestion suggestNextProgression(List<TrainingSession> sessions, String exerciseName) {
    final lastSet = getLastTime(sessions, exerciseName);

    if (lastSet == null) {
      return ProgressionSuggestion(
        exerciseName: exerciseName,
        previousWeight: 0,
        previousReps: 0,
        suggestedWeight: 20.0,
        suggestedReps: 10.0,
        weightDelta: 0,
        reason: '¡Primer registro para este ejercicio! Selecciona tu peso inicial de referencia.',
        title: 'NUEVO EJERCICIO 🎯',
        isFirstTime: true,
      );
    }

    final double lastWeight = lastSet.weight;
    final double lastReps = lastSet.reps;

    if (lastReps >= 10) {
      final double nextWeight = lastWeight + 2.5;
      return ProgressionSuggestion(
        exerciseName: exerciseName,
        previousWeight: lastWeight,
        previousReps: lastReps,
        suggestedWeight: nextWeight,
        suggestedReps: 8.0,
        weightDelta: 2.5,
        title: '¡SUBIMOS DE CARGA! 🚀',
        reason: 'La última vez completaste ${lastWeight}kg x ${lastReps.toInt()} reps. Te sugerimos subir +2.5kg hoy (8 reps de objetivo).',
      );
    } else if (lastReps >= 6) {
      final double targetReps = (lastReps + 2).clamp(6.0, 12.0);
      return ProgressionSuggestion(
        exerciseName: exerciseName,
        previousWeight: lastWeight,
        previousReps: lastReps,
        suggestedWeight: lastWeight,
        suggestedReps: targetReps,
        weightDelta: 0.0,
        title: 'CONSOLIDA VOLUMEN 📈',
        reason: 'La última vez hiciste ${lastWeight}kg x ${lastReps.toInt()} reps. Hoy mantén los ${lastWeight}kg pero apunta a ${targetReps.toInt()} reps.',
      );
    } else {
      final double deloadWeight = (lastWeight - 2.5).clamp(0.0, double.infinity);
      return ProgressionSuggestion(
        exerciseName: exerciseName,
        previousWeight: lastWeight,
        previousReps: lastReps,
        suggestedWeight: deloadWeight > 0 ? deloadWeight : lastWeight,
        suggestedReps: 8.0,
        weightDelta: deloadWeight > 0 ? -2.5 : 0.0,
        title: 'AJUSTE DE TÉCNICA 🛡️',
        reason: 'La última vez hiciste ${lastWeight}kg x ${lastReps.toInt()} reps. Ajustamos ligeramente el peso para asegurar técnica limpia.',
      );
    }
  }

  // Obtener sugerencia de rutina según el modo de planificación
  static Map<String, String> getSuggestion(List<TrainingSession> sessions, WorkoutConfig config) {
    if (config.plannerMode == 'calendar') {
      final days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
      final dayName = days[DateTime.now().weekday - 1];
      final task = config.weeklyPlan[dayName] ?? 'DESCANSO';
      return {'type': task, 'reason': 'Hoy es $dayName'};
    } else {
      if (sessions.isEmpty || config.groups.isEmpty) {
        return {
          'type': config.groups.isNotEmpty ? config.groups[0] : 'CREA UNA RUTINA',
          'reason': 'Comienza hoy'
        };
      }
      final lastType = sessions[0].type;
      final lastIdx = config.groups.indexOf(lastType);
      if (lastIdx == -1) return {'type': config.groups[0], 'reason': 'Nueva rutina'};
      final nextIdx = (lastIdx + 1) % config.groups.length;
      return {'type': config.groups[nextIdx], 'reason': 'Siguiente en el ciclo'};
    }
  }

  // Calcular volumen semanal total
  static double calculateWeeklyVolume(List<TrainingSession> sessions) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return sessions
        .where((s) => s.date.isAfter(startOfWeek))
        .fold(0, (sum, s) => sum + s.calculateTotalVolume());
  }
}
