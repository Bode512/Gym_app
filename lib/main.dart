import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_manager.dart';
import 'core/services/pip_service.dart';
import 'providers/workout_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_screen.dart';
import 'screens/pip_timer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const TrainerProApp(),
    ),
  );
}

class TrainerProApp extends StatelessWidget {
  const TrainerProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeManager, SettingsProvider>(
      builder: (context, theme, settings, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: PipService().isPipModeNotifier,
          builder: (context, isPip, child) {
            return MaterialApp(
              title: 'TrainerPRO',
              debugShowCheckedModeBanner: false,
              theme: theme.themeData,
              home: isPip
                  ? const PipTimerScreen()
                  : (settings.hasCompletedOnboarding 
                      ? const MainScreen() 
                      : const OnboardingScreen()),
            );
          },
        );
      },
    );
  }
}