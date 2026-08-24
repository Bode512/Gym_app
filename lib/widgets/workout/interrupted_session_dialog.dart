import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_manager.dart';
import '../../providers/workout_provider.dart';

class InterruptedSessionDialog extends StatelessWidget {
  const InterruptedSessionDialog({super.key});

  static Future<void> showIfNeeded(BuildContext context) async {
    final workout = Provider.of<WorkoutProvider>(context, listen: false);
    if (workout.hasInterruptedSession) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const InterruptedSessionDialog(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final workout = Provider.of<WorkoutProvider>(context);
    final l10n = AppLocalizations.of(context);

    final titleText = l10n?.interrupted_session_title ?? 'ENTRENAMIENTO INTERRUMPIDO';
    final msgText = l10n?.interrupted_session_msg ??
        'Tienes una sesión sin finalizar. ¿Deseas continuar o guardar lo avanzado?';
    final continueText = l10n?.continue_workout ?? 'CONTINUAR ENTRENAMIENTO';
    final finishText = l10n?.finish_saved_workout ?? 'FINALIZAR Y GUARDAR';

    return WillPopScope(
      onWillPop: () async => false, // Prevent dismissing by back button
      child: Dialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: theme.accentColor.withOpacity(0.5), width: 1.5),
        ),
        elevation: 20,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: theme.accentColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.accentColor.withOpacity(0.3)),
                ),
                child: Icon(
                  LucideIcons.history,
                  color: theme.accentColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                titleText,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                msgText,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              // Botón Continuar (Dorado)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    workout.restoreInterruptedSession();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(LucideIcons.play, size: 18),
                  label: Text(continueText),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.accentColor,
                    foregroundColor: const Color(0xFF0D0D0D),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Botón Finalizar y Guardar (Outlined)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    workout.discardInterruptedSession(finishAndSave: true);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(LucideIcons.check_circle, size: 18),
                  label: Text(finishText),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.accentColor,
                    side: BorderSide(color: theme.accentColor.withOpacity(0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
