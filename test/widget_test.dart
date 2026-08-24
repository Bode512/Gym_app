import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:trainerpro/main.dart';
import 'package:trainerpro/core/theme/theme_manager.dart';
import 'package:trainerpro/providers/workout_provider.dart';
import 'package:trainerpro/providers/settings_provider.dart';
import 'package:trainerpro/providers/user_profile_provider.dart';
import 'package:trainerpro/services/workout_service.dart';
import 'package:trainerpro/screens/main_screen.dart';
import 'package:trainerpro/screens/tabs/workout_tab.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'has_completed_onboarding': true,
    });
  });

  Widget buildTestApp(WorkoutProvider workoutProvider, SettingsProvider settingsProvider) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider.value(value: workoutProvider),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: const TrainerProApp(),
    );
  }

  testWidgets('1. Render MainScreen when onboarding is complete', (WidgetTester tester) async {
    final workout = WorkoutProvider();
    final settings = SettingsProvider();

    await tester.pumpWidget(buildTestApp(workout, settings));
    await tester.pumpAndSettle();

    expect(find.byType(MainScreen), findsOneWidget);
    expect(find.byType(WorkoutTab), findsOneWidget);
  });

  testWidgets('2. Start active workout session and render UI without overflow', (WidgetTester tester) async {
    final workout = WorkoutProvider();
    final settings = SettingsProvider();

    await tester.pumpWidget(buildTestApp(workout, settings));
    await tester.pumpAndSettle();

    workout.startWorkout('PUSH (EMPUJE)');
    await tester.pumpAndSettle();

    expect(workout.isSessionActive, isTrue);
  });

  testWidgets('3. Test Weight Progression Algorithm & Suggestion Card Flow', (WidgetTester tester) async {
    final workout = WorkoutProvider();
    final settings = SettingsProvider();

    await tester.pumpWidget(buildTestApp(workout, settings));
    await tester.pumpAndSettle();

    // 1. Start workout & add set of 80kg x 10 reps
    workout.startWorkout('PUSH (EMPUJE)');
    await tester.pumpAndSettle();

    const String exercise = 'PRESS BANCA PLANO';
    workout.setSelectedExercise(exercise);
    workout.addSet(exercise, 80.0, 10.0, 'Excelente sesión');
    workout.finishWorkout();
    await tester.pumpAndSettle();

    // 2. Start a new workout session with the same exercise
    workout.startWorkout('PUSH (EMPUJE)');
    workout.setSelectedExercise(exercise);
    await tester.pumpAndSettle();

    // 3. Test Progression Algorithm calculation
    final suggestion = WorkoutService.suggestNextProgression(workout.sessions, exercise);
    expect(suggestion.previousWeight, 80.0);
    expect(suggestion.previousReps, 10.0);
    expect(suggestion.suggestedWeight, 82.5);
    expect(suggestion.suggestedReps, 8.0);
    expect(suggestion.weightDelta, 2.5);
  });
}
