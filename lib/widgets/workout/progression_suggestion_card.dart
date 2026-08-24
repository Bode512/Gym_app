import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../core/theme/app_theme.dart';
import '../../services/workout_service.dart';

class ProgressionSuggestionCard extends StatelessWidget {
  final ProgressionSuggestion suggestion;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final bool isAccepted;

  const ProgressionSuggestionCard({
    super.key,
    required this.suggestion,
    required this.onAccept,
    required this.onReject,
    this.isAccepted = false,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestion.isFirstTime) return const SizedBox.shrink();

    const Color accentColor = AppColors.info;

    if (isAccepted) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.success.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(LucideIcons.circle_check, color: AppColors.success, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SUGERENCIA ACEPTADA',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Objetivo: ${suggestion.suggestedWeight}kg x ${suggestion.suggestedReps.toInt()} reps',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onReject,
              child: Text(
                'CAMBIAR',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surfaceDark,
            AppColors.surfaceSoft,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.zap, size: 18, color: accentColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.title,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Sugerencia inteligente de sobrecarga',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'ANTERIOR',
                  value: '${suggestion.previousWeight}kg x ${suggestion.previousReps.toInt()}',
                  textColor: AppColors.textSecondary,
                  accentColor: accentColor,
                ),
              ),
              const Icon(LucideIcons.arrow_right, size: 16, color: AppColors.textMuted),
              Expanded(
                child: _buildMetricTile(
                  label: 'SUGERIDO HOY',
                  value: '${suggestion.suggestedWeight}kg x ${suggestion.suggestedReps.toInt()}',
                  textColor: AppColors.textPrimary,
                  highlight: true,
                  accentColor: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            suggestion.reason,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onReject,
                  icon: const Icon(LucideIcons.x, size: 16, color: AppColors.textMuted),
                  label: Text(
                    'RECHAZAR',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.borderDark),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAccept,
                  icon: const Icon(LucideIcons.check, size: 16, color: Colors.white),
                  label: Text(
                    'ACEPTAR',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required Color textColor,
    required Color accentColor,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: highlight ? accentColor.withOpacity(0.1) : AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? accentColor.withOpacity(0.3) : AppColors.borderDark,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: highlight ? accentColor : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
