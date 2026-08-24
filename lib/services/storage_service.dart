import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/training_session.dart';
import '../models/workout_config.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs => _prefs;

  // --- Sessions ---
  Future<void> saveSessions(List<TrainingSession> sessions) async {
    final List<String> sessionsJson = sessions.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs.setStringList(AppConstants.keySessions, sessionsJson);
  }

  List<TrainingSession> loadSessions() {
    final List<String>? sessionsJson = _prefs.getStringList(AppConstants.keySessions);
    if (sessionsJson == null) return [];
    return sessionsJson.map((s) => TrainingSession.fromJson(jsonDecode(s))).toList();
  }

  // --- Config ---
  Future<void> saveConfig(WorkoutConfig config) async {
    await _prefs.setString(AppConstants.keyConfig, jsonEncode(config.toJson()));
  }

  WorkoutConfig loadConfig() {
    final String? configJson = _prefs.getString(AppConstants.keyConfig);
    if (configJson == null) {
      print('[StorageService] loadConfig: no hay config guardada, usando defaultConfig');
      return WorkoutConfig.defaultConfig();
    }

    try {
      final decoded = jsonDecode(configJson);
      if (decoded is! Map<String, dynamic>) {
        print('[StorageService] loadConfig: JSON corrupto, usando defaultConfig');
        return WorkoutConfig.defaultConfig();
      }
      final config = WorkoutConfig.fromJson(decoded);
      print('[StorageService] loadConfig: cargado ${config.groups.length} grupos, '
          '${config.exerciseDb.length} rutinas en exerciseDb');
      return config;
    } catch (e) {
      print('[StorageService] loadConfig: error al parsear config: $e, usando defaultConfig');
      return WorkoutConfig.defaultConfig();
    }
  }

  // --- Backup & Export (Stubs for now) ---
  String exportToJson(List<TrainingSession> sessions, WorkoutConfig config) {
    return jsonEncode({
      'sessions': sessions.map((s) => s.toJson()).toList(),
      'config': config.toJson(),
    });
  }
}
