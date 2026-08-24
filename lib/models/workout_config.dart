import '../core/constants/exercise_database.dart';
import '../core/constants/app_constants.dart';

class WorkoutConfig {
  final List<String> groups;
  final Map<String, List<String>> exerciseDb;
  final Map<String, List<String>> archivedExercises;
  final String plannerMode;
  final Map<String, String> weeklyPlan;
  final int defaultRestSeconds;

  WorkoutConfig({
    required this.groups,
    required this.exerciseDb,
    required this.archivedExercises,
    this.plannerMode = 'sequential',
    required this.weeklyPlan,
    this.defaultRestSeconds = AppConstants.defaultRestSeconds,
  });

  factory WorkoutConfig.defaultConfig() {
    return WorkoutConfig(
      groups: List.from(ExerciseDatabase.defaultGroups),
      exerciseDb: Map.from(ExerciseDatabase.defaultExerciseDb),
      archivedExercises: {},
      weeklyPlan: {
        'Lunes': 'DESCANSO',
        'Martes': 'DESCANSO',
        'Miércoles': 'DESCANSO',
        'Jueves': 'DESCANSO',
        'Viernes': 'DESCANSO',
        'Sábado': 'DESCANSO',
        'Domingo': 'DESCANSO'
      },
    );
  }

  Map<String, dynamic> toJson() => {
    'groups': groups,
    'exercises': exerciseDb,
    'archivedExercises': archivedExercises,
    'plannerMode': plannerMode,
    'weeklyPlan': weeklyPlan,
    'defaultRestSeconds': defaultRestSeconds,
  };

  factory WorkoutConfig.fromJson(Map<String, dynamic> json) {
    final groups = List<String>.from(json['groups'] ?? []);

    // Si groups está vacío, usar defaultConfig como fallback
    if (groups.isEmpty) {
      print('[WorkoutConfig] fromJson: groups está vacío, usando defaultConfig');
      return WorkoutConfig.defaultConfig();
    }

    final exerciseDb = (json['exercises'] as Map? ?? {}).map(
      (k, v) => MapEntry(k.toString(), List<String>.from(v)),
    );

    // Si exerciseDb está vacío pero groups tiene datos, poblar con ejercicios por defecto
    if (exerciseDb.isEmpty) {
      print('[WorkoutConfig] fromJson: exerciseDb está vacío, poblándolo desde ExerciseDatabase');
      final defaultDb = Map<String, List<String>>.from(
        ExerciseDatabase.defaultExerciseDb.map((k, v) => MapEntry(k, List<String>.from(v))),
      );
      return WorkoutConfig(
        groups: groups,
        exerciseDb: defaultDb,
        archivedExercises: {},
        plannerMode: json['plannerMode'] ?? 'sequential',
        weeklyPlan: Map<String, String>.from(json['weeklyPlan'] ?? {}),
        defaultRestSeconds: json['defaultRestSeconds'] ?? AppConstants.defaultRestSeconds,
      );
    }

    // Verificar que cada grupo tenga ejercicios; si un grupo no tiene, asignar los defaults
    final resolvedDb = Map<String, List<String>>.from(exerciseDb);
    for (final group in groups) {
      if (!resolvedDb.containsKey(group) || resolvedDb[group]!.isEmpty) {
        final defaults = ExerciseDatabase.defaultExerciseDb[group];
        if (defaults != null) {
          print('[WorkoutConfig] fromJson: grupo "$group" sin ejercicios, usando defaults');
          resolvedDb[group] = List<String>.from(defaults);
        }
      }
    }

    return WorkoutConfig(
      groups: groups,
      exerciseDb: resolvedDb,
      archivedExercises: (json['archivedExercises'] as Map? ?? {}).map(
        (k, v) => MapEntry(k.toString(), List<String>.from(v)),
      ),
      plannerMode: json['plannerMode'] ?? 'sequential',
      weeklyPlan: Map<String, String>.from(json['weeklyPlan'] ?? {}),
      defaultRestSeconds: json['defaultRestSeconds'] ?? AppConstants.defaultRestSeconds,
    );
  }

  WorkoutConfig copyWith({
    List<String>? groups,
    Map<String, List<String>>? exerciseDb,
    Map<String, List<String>>? archivedExercises,
    String? plannerMode,
    Map<String, String>? weeklyPlan,
    int? defaultRestSeconds,
  }) {
    return WorkoutConfig(
      groups: groups ?? this.groups,
      exerciseDb: exerciseDb ?? this.exerciseDb,
      archivedExercises: archivedExercises ?? this.archivedExercises,
      plannerMode: plannerMode ?? this.plannerMode,
      weeklyPlan: weeklyPlan ?? this.weeklyPlan,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
    );
  }
}
