import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../models/exercise_set.dart';
import '../../core/theme/app_theme.dart';

class SetCard extends StatelessWidget {
  final ExerciseSet exerciseSet;
  final VoidCallback? onDelete;

  const SetCard({super.key, required this.exerciseSet, this.onDelete});

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "${exerciseSet.name}: ${exerciseSet.weight}kg x ${exerciseSet.reps.toInt()}",
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
              Text(
                exerciseSet.time,
                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.textMuted),
              )
            ],
          ),
          if (exerciseSet.note.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                exerciseSet.note,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
              ),
            ),
        ],
      ),
    );

    if (onDelete == null) return content;

    return Dismissible(
      key: Key(exerciseSet.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete!(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.error.withOpacity(0.3)),
        ),
        child: const Icon(LucideIcons.trash_2, color: AppColors.error, size: 18),
      ),
      child: content,
    );
  }
}
