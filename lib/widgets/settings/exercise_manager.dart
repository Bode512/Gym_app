import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/theme_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/exercise_database.dart';

class ExerciseSearchDialog extends StatefulWidget {
  final Function(String) onSelected;

  const ExerciseSearchDialog({super.key, required this.onSelected});

  @override
  State<ExerciseSearchDialog> createState() => _ExerciseSearchDialogState();
}

class _ExerciseSearchDialogState extends State<ExerciseSearchDialog> {
  String selectedFromSearch = "";

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);

    return AlertDialog(
      title: Text(
        'AÑADIR EJERCICIO',
        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue value) {
              if (value.text == '') return const Iterable<String>.empty();
              return ExerciseDatabase.globalExerciseList.where((String option) {
                return option.contains(value.text.toUpperCase());
              });
            },
            onSelected: (String selection) => setState(() => selectedFromSearch = selection),
            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Escribe ej: "PRESS DE BANCA"',
                  hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.textMuted),
                ),
                onChanged: (v) => setState(() => selectedFromSearch = v.toUpperCase()),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('CANCELAR', style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted)),
        ),
        TextButton(
          onPressed: () {
            if (selectedFromSearch.isNotEmpty) {
              widget.onSelected(selectedFromSearch);
            }
            Navigator.pop(context);
          },
          child: Text('AÑADIR', style: GoogleFonts.plusJakartaSans(color: theme.accentColor, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
