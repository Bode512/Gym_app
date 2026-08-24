import 'dart:async';
import 'package:flutter/material.dart';
import '../models/exercise_set.dart';
import '../models/training_session.dart';
import '../models/workout_config.dart';
import '../services/storage_service.dart';
import '../services/workout_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/pip_service.dart';
import '../core/utils/haptic_utils.dart';
import '../core/constants/exercise_database.dart';

class WorkoutProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final NotificationService _notificationService = NotificationService();
  final PipService _pipService = PipService();

  List<TrainingSession> _sessions = [];
  WorkoutConfig _config = WorkoutConfig.defaultConfig();
  
  // -- Active Session State --
  bool _isSessionActive = false;
  bool _isPaused = false;
  String _activeWorkoutType = '';
  List<ExerciseSet> _currentSessionExercises = [];
  String _selectedExercise = '';
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
    await _notificationService.init();
    await _notificationService.requestPermissions();

    _sessions = _storage.loadSessions();
    _config = _storage.loadConfig();

    print('[WorkoutProvider] _loadData: ${_sessions.length} sesiones, '
        '${_config.groups.length} grupos: ${_config.groups}');

    if (_config.groups.isEmpty) {
      print('[WorkoutProvider] _loadData: WARNING - groups vacío, forzando defaultConfig');
      _config = WorkoutConfig.defaultConfig();
      await _storage.saveConfig(_config);
    }

    _checkRunningTimer();
    notifyListeners();
  }

  void _checkRunningTimer() {
    final prefs = _storage.prefs;
    final endTimeStr = prefs.getString('timer_end_time');
    if (endTimeStr != null) {
      final endTime = DateTime.parse(endTimeStr);
      final diff = endTime.difference(DateTime.now()).inSeconds;
      if (diff > 0) {
        _timerEndTime = endTime;
        _secondsLeft = diff;
        _showTimer = true;
        _pipService.setTimerActive(true);
        _startTimerLoop();
      } else {
        prefs.remove('timer_end_time');
      }
    }
  }

  // --- Session Management ---
  void startWorkout(String type) {
    String resolvedKey = type;
    if (!_config.exerciseDb.containsKey(type)) {
      final normalized = type.trim().toUpperCase();
      resolvedKey = _config.exerciseDb.keys.firstWhere(
        (k) => k.trim().toUpperCase() == normalized,
        orElse: () => type,
      );
    }

    if (!_config.exerciseDb.containsKey(resolvedKey) || _config.exerciseDb[resolvedKey]!.isEmpty) {
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
      }
    }

    final exercises = _config.exerciseDb[resolvedKey] ?? [];

    _activeWorkoutType = resolvedKey;
    _activeExercises = List<String>.from(exercises);
    _currentSessionExercises = [];
    _isSessionActive = true;
    _selectedExercise = exercises.isNotEmpty ? exercises[0] : '';

    notifyListeners();
  }

  void finishWorkout() {
    stopTimer();
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
    stopTimer();
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
    
    _pipService.setTimerActive(true);
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
        _storage.prefs.remove('timer_end_time');
        _pipService.setTimerActive(false);
        HapticUtils.timerFinish();
        _notificationService.showRestTimerCompleteNotification(
          title: '¡Tiempo de Descanso Finalizado! 💪',
          body: 'Has completado el tiempo de recuperación. ¡A por la siguiente serie!',
        );
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    _restTimer?.cancel();
    _showTimer = false;
    _pipService.setTimerActive(false);
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
