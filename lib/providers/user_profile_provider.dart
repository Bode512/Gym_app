import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class UserProfileProvider extends ChangeNotifier {
  static const String _keyUserProfile = 'user_profile_data';
  
  UserProfile _profile = UserProfile.defaultProfile();
  bool _isLoading = true;

  UserProfile get profile => _profile;
  bool get isLoading => _isLoading;

  UserProfileProvider() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_keyUserProfile);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        _profile = UserProfile.fromJsonString(jsonStr);
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfile(UserProfile newProfile) async {
    _profile = newProfile;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserProfile, _profile.toJsonString());
    } catch (e) {
      debugPrint('Error saving user profile: $e');
    }
  }

  Future<void> updateAntropometrics({
    required double currentWeight,
    required double targetWeight,
    required double heightCm,
    required String fitnessGoal,
  }) async {
    final updatedHistory = List<WeightEntry>.from(_profile.weightHistory);
    // Añadir nueva entrada de peso si ha cambiado
    if (updatedHistory.isEmpty || updatedHistory.last.weight != currentWeight) {
      updatedHistory.add(WeightEntry(weight: currentWeight, date: DateTime.now()));
    }

    final newProfile = _profile.copyWith(
      currentWeight: currentWeight,
      targetWeight: targetWeight,
      heightCm: heightCm,
      fitnessGoal: fitnessGoal,
      weightHistory: updatedHistory,
    );

    await saveProfile(newProfile);
  }

  Future<void> addWeightEntry(double weight) async {
    final updatedHistory = List<WeightEntry>.from(_profile.weightHistory)
      ..add(WeightEntry(weight: weight, date: DateTime.now()));

    final newProfile = _profile.copyWith(
      currentWeight: weight,
      weightHistory: updatedHistory,
    );

    await saveProfile(newProfile);
  }

  Future<void> deleteWeightEntry(int index) async {
    if (index < 0 || index >= _profile.weightHistory.length) return;
    final updatedHistory = List<WeightEntry>.from(_profile.weightHistory)..removeAt(index);

    final newWeight = updatedHistory.isNotEmpty ? updatedHistory.last.weight : _profile.currentWeight;
    final newProfile = _profile.copyWith(
      currentWeight: newWeight,
      weightHistory: updatedHistory,
    );

    await saveProfile(newProfile);
  }
}
