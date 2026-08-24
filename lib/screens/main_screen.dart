import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

import '../providers/settings_provider.dart';
import '../core/theme/theme_manager.dart';
import '../core/theme/app_theme.dart';
import '../providers/workout_provider.dart';
import '../widgets/common/timer_widget.dart';
import '../widgets/workout/interrupted_session_dialog.dart';
import 'tabs/workout_tab.dart';
import 'tabs/history_tab.dart';
import 'tabs/stats_tab.dart';
import 'settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _activeTab = 0;

  final List<Widget> _tabs = [
    const WorkoutTab(),
    const HistoryTab(),
    const StatsTab(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      InterruptedSessionDialog.showIfNeeded(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final workout = Provider.of<WorkoutProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final l10n = AppLocalizations.of(context);

    // Determinar icono del tema para el header
    IconData themeIcon;
    switch (theme.currentTheme) {
      case AppTheme.cyberNeon: themeIcon = LucideIcons.zap; break;
      case AppTheme.crimsonBlood: themeIcon = LucideIcons.flame; break;
      case AppTheme.goldRush: themeIcon = LucideIcons.award; break;
      default: themeIcon = LucideIcons.moon;
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Header dinámico
              _buildHeader(theme, workout, themeIcon, settings, l10n),
              // Cuerpo de la pestaña activa
              Expanded(
                child: IndexedStack(
                  index: _activeTab,
                  children: _tabs,
                ),
              ),
              // Bottom Navigation
              if (!workout.isSessionActive) _buildBottomNav(theme, settings, l10n),
            ],
          ),
          const TimerWidget(),
        ],
      ),
    );
  }

  Widget _buildHeader(
      ThemeManager theme, WorkoutProvider workout, IconData themeIcon, SettingsProvider settings, AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: const Border(bottom: BorderSide(color: AppColors.borderDark)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(themeIcon, color: theme.accentColor, size: 22),
            onPressed: () => theme.cycleTheme(),
            tooltip: 'Cambiar Tema',
          ),
          Builder(builder: (context) {
            final title = l10n?.app_name ?? 'TRAINER PRO';
            final parts = title.split(' ');
            final firstPart = parts.isNotEmpty ? parts[0] : title;
            final restPart = parts.length > 1 ? parts.sublist(1).join(' ') : '';
            return RichText(
              text: TextSpan(
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                children: [
                  TextSpan(text: firstPart, style: const TextStyle(color: AppColors.textPrimary)),
                  if (restPart.isNotEmpty)
                    TextSpan(text: ' $restPart', style: TextStyle(color: theme.accentColor)),
                ],
              ),
            );
          }),
          if (_activeTab == 0 && !workout.isSessionActive)
            IconButton(
              icon: const Icon(LucideIcons.settings, size: 20, color: AppColors.textSecondary),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ),
              tooltip: l10n?.settings ?? 'Ajustes',
            )
          else if (workout.isSessionActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.accentColor.withOpacity(0.3)),
              ),
              child: Text(
                workout.activeWorkoutType,
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: theme.accentColor),
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBottomNav(ThemeManager theme, SettingsProvider settings, AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24, top: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: const Border(top: BorderSide(color: AppColors.borderDark)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(0, LucideIcons.dumbbell, l10n?.today ?? 'HOY', theme),
          _navItem(1, LucideIcons.calendar, l10n?.history ?? 'HISTORIAL', theme),
          _navItem(2, LucideIcons.trending_up, l10n?.progress ?? 'PROGRESO', theme),
        ],
      ),
    );
  }

  Widget _navItem(int i, IconData ic, String l, ThemeManager theme) => GestureDetector(
    onTap: () => setState(() => _activeTab = i),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(ic, color: _activeTab == i ? theme.accentColor : AppColors.textMuted, size: 20),
        const SizedBox(height: 4),
        Text(
          l,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: _activeTab == i ? theme.accentColor : AppColors.textMuted,
            fontWeight: _activeTab == i ? FontWeight.bold : FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ),
  );
}
