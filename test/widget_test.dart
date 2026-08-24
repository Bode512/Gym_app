import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:trainerpro/main.dart';
import 'package:trainerpro/core/theme/theme_manager.dart';
import 'package:trainerpro/providers/workout_provider.dart';
import 'package:trainerpro/providers/settings_provider.dart';
import 'package:trainerpro/screens/main_screen.dart';
import 'package:trainerpro/screens/tabs/workout_tab.dart';
import 'package:trainerpro/screens/tabs/history_tab.dart';
import 'package:trainerpro/screens/tabs/stats_tab.dart';

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

    // Start workout
    workout.startWorkout('PUSH (EMPUJE)');
    await tester.pumpAndSettle();

    expect(workout.isSessionActive, isTrue);
    expect(find.text('ENTRENANDO'), findsOneWidget);
  });

  testWidgets('3. HistoryTab and StatsTab render without errors', (WidgetTester tester) async {
    final workout = WorkoutProvider();
    final settings = SettingsProvider();

    await tester.pumpWidget(buildTestApp(workout, settings));
    await tester.pumpAndSettle();

    // Switch to HistoryTab
    await tester.tap(find.byIcon(LucideIcons.calendar).first);
    await tester.pumpAndSettle();

    // Switch to StatsTab
    await tester.tap(find.byIcon(LucideIcons.trending_up).first);
    await tester.pumpAndSettle();
  });
}
