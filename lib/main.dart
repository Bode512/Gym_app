import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

import 'core/theme/theme_manager.dart';
import 'core/services/pip_service.dart';
import 'providers/workout_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/user_profile_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_screen.dart';
import 'screens/pip_timer_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: const TrainerProApp(),
    ),
  );
}

class TrainerProApp extends StatefulWidget {
  const TrainerProApp({super.key});

  @override
  State<TrainerProApp> createState() => _TrainerProAppState();
}

class _TrainerProAppState extends State<TrainerProApp> {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Give providers time to finish loading their async data
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _isReady = true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeManager, SettingsProvider>(
      builder: (context, theme, settings, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: PipService().isPipModeNotifier,
          builder: (context, isPip, child) {
            final locale = Locale(settings.languageCode);

            if (!_isReady) {
              return MaterialApp(
                title: 'RITMO',
                debugShowCheckedModeBanner: false,
                theme: theme.themeData,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: const SplashScreen(),
              );
            }

            return MaterialApp(
              title: 'RITMO',
              debugShowCheckedModeBanner: false,
              theme: theme.themeData,
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
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
