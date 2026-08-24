import 'dart:convert';

class WeightEntry {
  final double weight;
  final DateTime date;

  WeightEntry({
    required this.weight,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'weight': weight,
        'date': date.toIso8601String(),
      };

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
        weight: (json['weight'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
      );
}

class UserProfile {
  final double currentWeight;
  final double targetWeight;
  final double heightCm;
  final String fitnessGoal; // 'muscle', 'fat_loss', 'maintain', 'strength'
  final DateTime startDate;
  final List<WeightEntry> weightHistory;

  UserProfile({
    required this.currentWeight,
    required this.targetWeight,
    required this.heightCm,
    required this.fitnessGoal,
    required this.startDate,
    required this.weightHistory,
  });

  factory UserProfile.defaultProfile() {
    return UserProfile(
      currentWeight: 75.0,
      targetWeight: 70.0,
      heightCm: 175.0,
      fitnessGoal: 'muscle',
      startDate: DateTime.now(),
      weightHistory: [
        WeightEntry(weight: 75.0, date: DateTime.now()),
      ],
    );
  }

  UserProfile copyWith({
    double? currentWeight,
    double? targetWeight,
    double? heightCm,
    String? fitnessGoal,
    DateTime? startDate,
    List<WeightEntry>? weightHistory,
  }) {
    return UserProfile(
      currentWeight: currentWeight ?? this.currentWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      heightCm: heightCm ?? this.heightCm,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      startDate: startDate ?? this.startDate,
      weightHistory: weightHistory ?? this.weightHistory,
    );
  }

  Map<String, dynamic> toJson() => {
        'currentWeight': currentWeight,
        'targetWeight': targetWeight,
        'heightCm': heightCm,
        'fitnessGoal': fitnessGoal,
        'startDate': startDate.toIso8601String(),
        'weightHistory': weightHistory.map((e) => e.toJson()).toList(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        currentWeight: (json['currentWeight'] as num?)?.toDouble() ?? 75.0,
        targetWeight: (json['targetWeight'] as num?)?.toDouble() ?? 70.0,
        heightCm: (json['heightCm'] as num?)?.toDouble() ?? 175.0,
        fitnessGoal: json['fitnessGoal'] as String? ?? 'muscle',
        startDate: json['startDate'] != null
            ? DateTime.parse(json['startDate'] as String)
            : DateTime.now(),
        weightHistory: (json['weightHistory'] as List<dynamic>?)
                ?.map((e) => WeightEntry.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [WeightEntry(weight: 75.0, date: DateTime.now())],
      );

  String toJsonString() => jsonEncode(toJson());
  factory UserProfile.fromJsonString(String source) =>
      UserProfile.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
