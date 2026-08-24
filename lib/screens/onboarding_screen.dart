import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../providers/workout_provider.dart';
import '../../core/theme/theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/custom_button.dart';
import 'main_screen.dart';
import '../../core/constants/exercise_database.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final workout = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildLanguageStep(theme, settings),
            _buildRoutineStep(theme, settings, workout),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageStep(ThemeManager theme, SettingsProvider settings) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: theme.accentColor.withOpacity(0.2)),
            ),
            child: Icon(LucideIcons.globe, size: 56, color: theme.accentColor),
          ),
          const SizedBox(height: 32),
          Text(
            settings.translate('language').toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona tu idioma preferido',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 36),
          _langBtn('ESPAÑOL', 'es', settings),
          const SizedBox(height: 12),
          _langBtn('ENGLISH', 'en', settings),
          const SizedBox(height: 12),
          _langBtn('العربية', 'ar', settings),
          const Spacer(),
          PrimaryButton(
            label: settings.translate('confirm').toUpperCase(),
            onPressed: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _langBtn(String label, String code, SettingsProvider settings) {
    final isSelected = settings.languageCode == code;
    final theme = Provider.of<ThemeManager>(context);
    return GestureDetector(
      onTap: () => settings.setLanguage(code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? theme.accentColor.withOpacity(0.12) : AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.accentColor : AppColors.borderDark,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: isSelected ? theme.accentColor : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoutineStep(ThemeManager theme, SettingsProvider settings, WorkoutProvider workout) {
    final structures = ExerciseDatabase.routineStructures;

    return Container(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: theme.accentColor.withOpacity(0.2)),
            ),
            child: Icon(LucideIcons.dumbbell, size: 48, color: theme.accentColor),
          ),
          const SizedBox(height: 20),
          Text(
            settings.translate('routine_structure'),
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            settings.translate('select_base'),
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 28),
          Expanded(
            child: ListView(
              children: structures.keys.map((key) {
                String labelKey;
                switch (key) {
                  case 'PUSH PULL LEG': labelKey = 'ppl'; break;
                  case 'FULL BODY': labelKey = 'full_body'; break;
                  case 'UPPER LOWER': labelKey = 'upper_lower'; break;
                  case 'ARNOLD SPLIT': labelKey = 'arnold_split'; break;
                  case 'MI MEZCLA (ARNOLD+PPL)': labelKey = 'my_mix'; break;
                  case 'PERSONALIZADO': labelKey = 'custom'; break;
                  default: labelKey = 'custom';
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () async {
                      // Actualizar grupos según la estructura
                      final newGroups = List<String>.from(structures[key]!);
                      if (newGroups.isEmpty) {
                        // Personalizado por defecto
                        newGroups.addAll(['PUSH (EMPUJE)', 'PULL (TIRÓN)', 'LEGS (PIERNA)']);
                      }

                      // Poblar exerciseDb con ejercicios por defecto para cada grupo
                      final newDb = Map<String, List<String>>.from(workout.config.exerciseDb);
                      for (final group in newGroups) {
                        if (!newDb.containsKey(group) || newDb[group]!.isEmpty) {
                          final defaults = ExerciseDatabase.defaultExerciseDb[group];
                          newDb[group] = defaults != null ? List<String>.from(defaults) : [];
                        }
                      }

                      workout.updateConfig(workout.config.copyWith(groups: newGroups, exerciseDb: newDb));
                      await settings.completeOnboarding();

                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            settings.translate(labelKey).toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Icon(LucideIcons.chevron_right, size: 18, color: theme.accentColor),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
