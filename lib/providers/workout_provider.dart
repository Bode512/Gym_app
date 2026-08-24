import 'dart:async';
import 'package:flutter/material.dart';
import '../models/exercise_set.dart';
import '../models/training_session.dart';
import '../models/workout_config.dart';
import '../services/storage_service.dart';
import '../services/workout_service.dart';
import '../core/utils/haptic_utils.dart';
import '../core/constants/exercise_database.dart';

class WorkoutProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  List<TrainingSession> _sessions = [];
  WorkoutConfig _config = WorkoutConfig.defaultConfig();
  
  // -- Active Session State --
  bool _isSessionActive = false;
  bool _isPaused = false;
  String _activeWorkoutType = '';
  List<ExerciseSet> _currentSessionExercises = [];
  String _selectedExercise = '';
  // Lista de ejercicios activos — se carga al iniciar sesión para evitar
  // problemas de lookup por claves con formato diferente en el mapa.
  List<String> _activeExercises = [];
  
  // -- Timer State --
  Timer? _restTimer;
  int _secondsLeft = 0;
  bool _showTimer = false;
  DateTime? _timerEndTime;

  // -- Getters --
  List<TrainingSession> get sessions => _sessions;
  WorkoutConfig get config => _config;
  bool get isSessionActive => _isSessionActive;
  bool get isPaused => _isPaused;
  String get activeWorkoutType => _activeWorkoutType;
  /// Ejercicios de la sesión activa (ya resueltos al iniciarla).
  List<String> get activeExercises => _activeExercises;
  List<ExerciseSet> get currentSessionExercises => _currentSessionExercises;
  String get selectedExercise => _selectedExercise;
  int get secondsLeft => _secondsLeft;
  bool get showTimer => _showTimer;

  WorkoutProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    await _storage.init();
    _sessions = _storage.loadSessions();
    _config = _storage.loadConfig();

    print('[WorkoutProvider] _loadData: ${_sessions.length} sesiones, '
        '${_config.groups.length} grupos: ${_config.groups}');

    // Validación de integridad post-carga
    if (_config.groups.isEmpty) {
      print('[WorkoutProvider] _loadData: WARNING - groups vacío, forzando defaultConfig');
      _config = WorkoutConfig.defaultConfig();
      await _storage.saveConfig(_config);
    }

    _checkRunningTimer();
    notifyListeners();
  }

  void _checkRunningTimer() {
    final prefs = _storage.prefs; // Acceder a SharedPreferences via StorageService
    final endTimeStr = prefs.getString('timer_end_time');
    if (endTimeStr != null) {
      final endTime = DateTime.parse(endTimeStr);
      final diff = endTime.difference(DateTime.now()).inSeconds;
      if (diff > 0) {
        _timerEndTime = endTime;
        _secondsLeft = diff;
        _showTimer = true;
        _startTimerLoop();
      } else {
        prefs.remove('timer_end_time');
      }
    }
  }

  // --- Session Management ---
  /// Start workout for the given group type. If the group has no exercises
  /// in exerciseDb, it will attempt to populate them from ExerciseDatabase defaults.
  void startWorkout(String type) {
    print('[WorkoutProvider] startWorkout: "$type" — exerciseDb keys: ${_config.exerciseDb.keys.toList()}');

    // Buscar la clave real en exerciseDb (tolerante a diferencias de formato)
    String resolvedKey = type;
    if (!_config.exerciseDb.containsKey(type)) {
      final normalized = type.trim().toUpperCase();
      resolvedKey = _config.exerciseDb.keys.firstWhere(
        (k) => k.trim().toUpperCase() == normalized,
        orElse: () => type,
      );
      print('[WorkoutProvider] startWorkout: clave "$type" resuelta a "$resolvedKey"');
    }

    // Si el grupo no tiene ejercicios, intentar poblar desde defaults
    if (!_config.exerciseDb.containsKey(resolvedKey) || _config.exerciseDb[resolvedKey]!.isEmpty) {
      print('[WorkoutProvider] startWorkout: "$resolvedKey" sin ejercicios, buscando defaults');
      // Buscar defaults también tolerante a formato
      final normalizedKey = resolvedKey.trim().toUpperCase();
      final defaultEntry = ExerciseDatabase.defaultExerciseDb.entries.firstWhere(
        (e) => e.key.trim().toUpperCase() == normalizedKey,
        orElse: () => const MapEntry('', <String>[]),
      );
      final defaults = defaultEntry.value;
      if (defaults.isNotEmpty) {
        final newDb = Map<String, List<String>>.from(_config.exerciseDb);
        newDb[resolvedKey] = List<String>.from(defaults);
        _config = _config.copyWith(exerciseDb: newDb);
        _storage.saveConfig(_config);
        print('[WorkoutProvider] startWorkout: poblado con ${defaults.length} ejercicios defaults');
      } else {
        print('[WorkoutProvider] startWorkout: no hay defaults para "$resolvedKey", iniciando vacío');
      }
    }

    // Resolver la lista final de ejercicios y guardarla en estado
    final exercises = _config.exerciseDb[resolvedKey] ?? [];
    print('[WorkoutProvider] startWorkout: "$resolvedKey" tiene ${exercises.length} ejercicios: $exercises');

    _activeWorkoutType = resolvedKey;
    _activeExercises = List<String>.from(exercises);
    _currentSessionExercises = [];
    _isSessionActive = true;

    _selectedExercise = exercises.isNotEmpty ? exercises[0] : '';

    notifyListeners();
  }

  void finishWorkout() {
    _restTimer?.cancel();
    if (_currentSessionExercises.isNotEmpty) {
      final session = TrainingSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _activeWorkoutType,
        exercises: List.from(_currentSessionExercises),
        date: _currentSessionExercises.last.date,
        endDate: DateTime.now(),
      );
      _sessions.insert(0, session);
      _storage.saveSessions(_sessions);
    }
    _isSessionActive = false;
    _isPaused = false;
    _activeWorkoutType = '';
    _activeExercises = [];
    _currentSessionExercises = [];
    _showTimer = false;
    notifyListeners();
  }

  void cancelWorkout() {
    _restTimer?.cancel();
    _isSessionActive = false;
    _isPaused = false;
    _activeWorkoutType = '';
    _activeExercises = [];
    _currentSessionExercises = [];
    _showTimer = false;
    notifyListeners();
  }

  void pauseWorkout() {
    if (!_isSessionActive) return;
    _isPaused = true;
    notifyListeners();
  }

  void resumeWorkout() {
    if (!_isSessionActive) return;
    _isPaused = false;
    notifyListeners();
  }

  /// Continue the current active session using a different group without
  /// clearing the current session exercises. Useful when the previous group's
  /// exercises were removed and the user wants to continue.
  void continueWithGroup(String group) {
    _activeWorkoutType = group;
    final exercises = _config.exerciseDb[group] ?? [];
    _activeExercises = List<String>.from(exercises);
    _selectedExercise = exercises.isNotEmpty ? exercises[0] : '';
    _isPaused = false;
    notifyListeners();
  }

  void deleteSession(String sessionId) {
    _sessions.removeWhere((s) => s.id == sessionId);
    _storage.saveSessions(_sessions);
    notifyListeners();
  }

  void addSet(String name, double weight, double reps, String note) {
    final now = DateTime.now();
    final newSet = ExerciseSet(
      name: name.toUpperCase(),
      weight: weight,
      reps: reps,
      note: note,
      time: "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
      date: now,
    );

    _currentSessionExercises.insert(0, newSet);
    
    // Check if it's a new PB
    final pb = WorkoutService.getPB(_sessions, name);
    if (pb == null || newSet.calculateScore() > pb.calculateScore()) {
      HapticUtils.recordCelebration();
    } else {
      HapticUtils.light();
    }

    startRestTimer();
    notifyListeners();
  }

  void setSelectedExercise(String ex) {
    _selectedExercise = ex;
    notifyListeners();
  }

  // --- Timer logic ---
  void startRestTimer({int? customSeconds}) {
    _restTimer?.cancel();
    final duration = customSeconds ?? _config.defaultRestSeconds;
    _secondsLeft = duration;
    _showTimer = true;
    _timerEndTime = DateTime.now().add(Duration(seconds: duration));
    _storage.prefs.setString('timer_end_time', _timerEndTime!.toIso8601String());
    
    _startTimerLoop();
    notifyListeners();
  }

  void _startTimerLoop() {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        _secondsLeft--;
        notifyListeners();
      } else {
        _restTimer?.cancel();
        _showTimer = false;
        _storage.prefs.remove('timer_end_time');
        HapticUtils.timerFinish();
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    _restTimer?.cancel();
    _showTimer = false;
    _storage.prefs.remove('timer_end_time');
    notifyListeners();
  }

  // --- Config Updates ---
  void updateConfig(WorkoutConfig newConfig) {
    _config = newConfig;
    _storage.saveConfig(_config);
    notifyListeners();
  }

  void deleteExercise(String group, String exercise) {
    final newDb = Map<String, List<String>>.from(_config.exerciseDb);
    final newArchived = Map<String, List<String>>.from(_config.archivedExercises);
    
    newDb[group]?.remove(exercise);
    newArchived[group]?.remove(exercise);
    
    updateConfig(_config.copyWith(exerciseDb: newDb, archivedExercises: newArchived));
  }

  // --- Helpers ---
  ExerciseSet? getPB(String exerciseName) => WorkoutService.getPB(_sessions, exerciseName);
  ExerciseSet? getLastTime(String exerciseName) => WorkoutService.getLastTime(_sessions, exerciseName);
  Map<String, String> getSuggestion() => WorkoutService.getSuggestion(_sessions, _config);
}
