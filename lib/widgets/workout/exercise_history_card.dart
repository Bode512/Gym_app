import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../models/exercise_set.dart';

class ExerciseHistoryCard extends StatelessWidget {
  final String title;
  final ExerciseSet exerciseSet;
  final bool isPB;
  final VoidCallback? onCopy;

  const ExerciseHistoryCard({
    super.key,
    required this.title,
    required this.exerciseSet,
    required this.isPB,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPB ? AppColors.warning.withOpacity(0.3) : AppColors.borderDark,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isPB) ...[
                const Icon(LucideIcons.trophy, size: 14, color: AppColors.warning),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: isPB ? AppColors.warning : AppColors.textMuted,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onCopy != null)
                IconButton(
                  icon: const Icon(LucideIcons.copy, size: 14, color: AppColors.textSecondary),
                  onPressed: onCopy,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Copiar peso',
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "${exerciseSet.weight}kg x ${exerciseSet.reps.toInt()}",
            style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          if (exerciseSet.note.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                "Nota: ${exerciseSet.note}",
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
              ),
            ),
        ],
      ),
    );
  }
}
