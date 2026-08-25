// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_name => 'RITMO';

  @override
  String get today => 'HOY';

  @override
  String get history => 'HISTORIAL';

  @override
  String get progress => 'PROGRESO';

  @override
  String get settings => 'CONFIGURACIÓN';

  @override
  String get profile => 'PERFIL';

  @override
  String get rest_between_sets => 'DESCANSO ENTRE SERIES';

  @override
  String get planner_mode => 'MODO DE PLANIFICACIÓN';

  @override
  String get cycle => 'CICLO';

  @override
  String get calendar => 'CALENDARIO';

  @override
  String get day_assignment => 'ASIGNACIÓN POR DÍAS';

  @override
  String get cycle_order => 'ORDEN DEL CICLO';

  @override
  String get add_group => 'AÑADIR GRUPO';

  @override
  String get restore_routine => 'RESTAURAR RUTINA';

  @override
  String get active_exercises => 'EJERCICIOS ACTIVOS';

  @override
  String get archived => 'ARCHIVADOS';

  @override
  String get new_routine => 'NUEVA RUTINA';

  @override
  String get add_exercise => 'AÑADIR EJERCICIO';

  @override
  String get finish_workout => 'FINALIZAR';

  @override
  String get training => 'ENTRENANDO';

  @override
  String get personal_record => 'RÉCORD PERSONAL';

  @override
  String get last_time => 'VEZ ANTERIOR';

  @override
  String get weight => 'PESO';

  @override
  String get reps => 'REPS';

  @override
  String get save_set => 'GUARDAR SERIE';

  @override
  String get no_activity => 'SIN ACTIVIDAD';

  @override
  String get onboarding_title => 'RITMO';

  @override
  String get onboarding_subtitle =>
      'Tu compañero definitivo de entrenamiento de alto rendimiento.';

  @override
  String get get_started => 'COMENZAR AHORA';

  @override
  String get language => 'IDIOMA';

  @override
  String get version => 'Versión 3.0.0 Luxury';

  @override
  String get delete_exercise => 'ELIMINAR EJERCICIO';

  @override
  String get cancel => 'CANCELAR';

  @override
  String get confirm => 'CONFIRMAR';

  @override
  String get exit_workout => 'SALIR DEL ENTRENAMIENTO';

  @override
  String get delete_history_item => 'ELIMINAR DEL HISTORIAL';

  @override
  String get strength_progress => 'PROGRESO DE FUERZA';

  @override
  String get all_sets => 'TODAS LAS SERIES';

  @override
  String get monday => 'Lunes';

  @override
  String get tuesday => 'Martes';

  @override
  String get wednesday => 'Miércoles';

  @override
  String get thursday => 'Jueves';

  @override
  String get friday => 'Viernes';

  @override
  String get saturday => 'Sábado';

  @override
  String get sunday => 'Domingo';

  @override
  String get rest_day => 'DESCANSO';

  @override
  String get routine_structure => 'ESTRUCTURA DE RUTINA';

  @override
  String get select_base =>
      'Selecciona una base. Tus pesos históricos se mantendrán.';

  @override
  String get ppl => 'PUSH PULL LEG';

  @override
  String get full_body => 'FULL BODY';

  @override
  String get upper_lower => 'UPPER LOWER';

  @override
  String get arnold_split => 'ARNOLD SPLIT';

  @override
  String get my_mix => 'MI MEZCLA (ARNOLD+PPL)';

  @override
  String get custom => 'PERSONALIZADO';

  @override
  String get rest_time => 'DESCANSO';

  @override
  String get time_up => '¡TIEMPO!';

  @override
  String get repeat => 'REPETIR';

  @override
  String get stop => 'DETENER';

  @override
  String step_of(Object current, Object total) {
    return 'Paso $current de $total';
  }

  @override
  String get personal_goals => 'METAS Y OBJETIVOS';

  @override
  String get current_weight => 'Peso Actual (kg)';

  @override
  String get target_weight => 'Peso Objetivo (kg)';

  @override
  String get height_cm => 'Altura (cm)';

  @override
  String get fitness_goal => 'Objetivo de Entrenamiento';

  @override
  String get goal_muscle => 'Ganar Músculo';

  @override
  String get goal_fat_loss => 'Perder Grasa';

  @override
  String get goal_maintain => 'Mantener Forma';

  @override
  String get goal_strength => 'Fuerza Máxima';

  @override
  String get weight_journal => 'DIARIO DE PESO';

  @override
  String get add_weight_entry => 'Registrar Peso';

  @override
  String weight_progress_summary(Object percent, Object remaining) {
    return 'Te faltan ${remaining}kg para tu objetivo ($percent% completado)';
  }

  @override
  String get goal_achieved => '¡Felicidades! Has alcanzado tu peso objetivo.';

  @override
  String get reminders => 'RECORDATORIOS';

  @override
  String get weigh_in_reminder => 'Recordatorio de pesaje';

  @override
  String get weigh_in_reminder_desc =>
      'Notificación semanal para registrar tu peso';

  @override
  String get interrupted_session_title => 'ENTRENAMIENTO INTERRUMPIDO';

  @override
  String get interrupted_session_msg =>
      'Tienes una sesión sin finalizar. ¿Deseas continuar o guardar lo avanzado?';

  @override
  String get continue_workout => 'CONTINUAR ENTRENAMIENTO';

  @override
  String get finish_saved_workout => 'FINALIZAR Y GUARDAR';

  @override
  String get edit_profile => 'EDITAR PERFIL';
}
