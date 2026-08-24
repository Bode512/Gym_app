import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../providers/workout_provider.dart';
import '../providers/user_profile_provider.dart';
import '../core/theme/theme_manager.dart';
import '../core/theme/app_theme.dart';
import '../widgets/common/custom_button.dart';
import 'main_screen.dart';
import '../core/constants/exercise_database.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Controllers para el Paso 2 (Metas)
  final TextEditingController _weightController = TextEditingController(text: '75.0');
  final TextEditingController _targetWeightController = TextEditingController(text: '70.0');
  final TextEditingController _heightController = TextEditingController(text: '175');
  String _selectedGoal = 'muscle';

  @override
  void dispose() {
    _pageController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final workout = Provider.of<WorkoutProvider>(context);
    final profileProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Indicator bar header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      icon: const Icon(LucideIcons.arrow_left, color: AppColors.textPrimary),
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final isActive = index == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive ? theme.accentColor : AppColors.surfaceSoft,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),
                  Text(
                    '${_currentPage + 1}/3',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildLanguageStep(theme, settings),
                  _buildGoalsStep(theme, settings, profileProvider),
                  _buildRoutineStep(theme, settings, workout, profileProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Step 1: Idioma ---
  Widget _buildLanguageStep(ThemeManager theme, SettingsProvider settings) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.accentColor.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: theme.accentColor.withOpacity(0.3)),
            ),
            child: Icon(LucideIcons.globe, size: 56, color: theme.accentColor),
          ),
          const SizedBox(height: 28),
          Text(
            settings.translate('onboarding_title'),
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            settings.translate('onboarding_subtitle'),
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 36),
          _langBtn('Español', 'es', '🇪🇸', settings, theme),
          const SizedBox(height: 12),
          _langBtn('English', 'en', '🇺🇸', settings, theme),
          const SizedBox(height: 12),
          _langBtn('العربية', 'ar', '🇸🇦', settings, theme),
          const Spacer(),
          PrimaryButton(
            label: settings.translate('confirm').toUpperCase(),
            onPressed: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _langBtn(String label, String code, String flag, SettingsProvider settings, ThemeManager theme) {
    final isSelected = settings.languageCode == code;
    return GestureDetector(
      onTap: () {
        settings.setLanguage(code);
        theme.updateRTL(code);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? theme.accentColor.withOpacity(0.15) : theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.accentColor : AppColors.borderDark,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 14),
            Text(
              label,
              style: GoogleFonts.inter(
                color: isSelected ? theme.accentColor : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(LucideIcons.circle_check, size: 20, color: theme.accentColor),
          ],
        ),
      ),
    );
  }

  // --- Step 2: Metas Antropométricas ---
  Widget _buildGoalsStep(ThemeManager theme, SettingsProvider settings, UserProfileProvider profileProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.accentColor.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: theme.accentColor.withOpacity(0.3)),
              ),
              child: Icon(LucideIcons.target, size: 48, color: theme.accentColor),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              settings.translate('personal_goals'),
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Peso Actual y Objetivo
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: settings.translate('current_weight'),
                  controller: _weightController,
                  suffix: 'kg',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildInputField(
                  label: settings.translate('target_weight'),
                  controller: _targetWeightController,
                  suffix: 'kg',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Altura
          _buildInputField(
            label: settings.translate('height_cm'),
            controller: _heightController,
            suffix: 'cm',
          ),
          const SizedBox(height: 24),

          // Selección de Objetivo
          Text(
            settings.translate('fitness_goal').toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          _goalCard('muscle', settings.translate('goal_muscle'), LucideIcons.biceps_flexed, theme),
          const SizedBox(height: 8),
          _goalCard('fat_loss', settings.translate('goal_fat_loss'), LucideIcons.flame, theme),
          const SizedBox(height: 8),
          _goalCard('strength', settings.translate('goal_strength'), LucideIcons.trophy, theme),
          const SizedBox(height: 8),
          _goalCard('maintain', settings.translate('goal_maintain'), LucideIcons.activity, theme),

          const SizedBox(height: 28),
          PrimaryButton(
            label: settings.translate('confirm').toUpperCase(),
            onPressed: () {
              final w = double.tryParse(_weightController.text) ?? 75.0;
              final tw = double.tryParse(_targetWeightController.text) ?? 70.0;
              final h = double.tryParse(_heightController.text) ?? 175.0;

              profileProvider.updateAntropometrics(
                currentWeight: w,
                targetWeight: tw,
                heightCm: h,
                fitnessGoal: _selectedGoal,
              );

              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            suffixText: suffix,
            suffixStyle: GoogleFonts.inter(color: AppColors.textMuted),
          ),
        ),
      ],
    );
  }

  Widget _goalCard(String key, String title, IconData icon, ThemeManager theme) {
    final isSelected = _selectedGoal == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedGoal = key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? theme.accentColor.withOpacity(0.15) : theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? theme.accentColor : AppColors.borderDark,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? theme.accentColor : AppColors.textSecondary, size: 20),
            const SizedBox(width: 14),
            Text(
              title,
              style: GoogleFonts.inter(
                color: isSelected ? theme.accentColor : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(LucideIcons.check, color: theme.accentColor, size: 18),
          ],
        ),
      ),
    );
  }

  // --- Step 3: Estructura de Rutina Base ---
  Widget _buildRoutineStep(
      ThemeManager theme, SettingsProvider settings, WorkoutProvider workout, UserProfileProvider profileProvider) {
    final structures = ExerciseDatabase.routineStructures;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.accentColor.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: theme.accentColor.withOpacity(0.3)),
            ),
            child: Icon(LucideIcons.dumbbell, size: 48, color: theme.accentColor),
          ),
          const SizedBox(height: 20),
          Text(
            settings.translate('routine_structure'),
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            settings.translate('select_base'),
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),
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
                      final newGroups = List<String>.from(structures[key]!);
                      if (newGroups.isEmpty) {
                        newGroups.addAll(['PUSH (EMPUJE)', 'PULL (TIRÓN)', 'LEGS (PIERNA)']);
                      }

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
                            style: GoogleFonts.inter(
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
