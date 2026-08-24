// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'TRAINER PRO';

  @override
  String get today => 'TODAY';

  @override
  String get history => 'HISTORY';

  @override
  String get progress => 'PROGRESS';

  @override
  String get settings => 'SETTINGS';

  @override
  String get profile => 'PROFILE';

  @override
  String get rest_between_sets => 'REST BETWEEN SETS';

  @override
  String get planner_mode => 'PLANNER MODE';

  @override
  String get cycle => 'CYCLE';

  @override
  String get calendar => 'CALENDAR';

  @override
  String get day_assignment => 'DAY ASSIGNMENT';

  @override
  String get cycle_order => 'CYCLE ORDER';

  @override
  String get add_group => 'ADD GROUP';

  @override
  String get restore_routine => 'RESTORE ROUTINE';

  @override
  String get active_exercises => 'ACTIVE EXERCISES';

  @override
  String get archived => 'ARCHIVED';

  @override
  String get new_routine => 'NEW ROUTINE';

  @override
  String get add_exercise => 'ADD EXERCISE';

  @override
  String get finish_workout => 'FINISH';

  @override
  String get training => 'TRAINING';

  @override
  String get personal_record => 'PERSONAL RECORD';

  @override
  String get last_time => 'PREVIOUS TIME';

  @override
  String get weight => 'WEIGHT';

  @override
  String get reps => 'REPS';

  @override
  String get save_set => 'SAVE SET';

  @override
  String get no_activity => 'NO ACTIVITY';

  @override
  String get onboarding_title => 'TRAINER PRO';

  @override
  String get onboarding_subtitle =>
      'Your ultimate high-performance training companion.';

  @override
  String get get_started => 'GET STARTED NOW';

  @override
  String get language => 'LANGUAGE';

  @override
  String get version => 'Version 3.0.0 Luxury';

  @override
  String get delete_exercise => 'DELETE EXERCISE';

  @override
  String get cancel => 'CANCEL';

  @override
  String get confirm => 'CONFIRM';

  @override
  String get exit_workout => 'EXIT WORKOUT';

  @override
  String get delete_history_item => 'DELETE FROM HISTORY';

  @override
  String get strength_progress => 'STRENGTH PROGRESS';

  @override
  String get all_sets => 'ALL SETS';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get rest_day => 'REST';

  @override
  String get routine_structure => 'ROUTINE STRUCTURE';

  @override
  String get select_base =>
      'Select a base routine. Historical weights will be kept.';

  @override
  String get ppl => 'PUSH PULL LEG';

  @override
  String get full_body => 'FULL BODY';

  @override
  String get upper_lower => 'UPPER LOWER';

  @override
  String get arnold_split => 'ARNOLD SPLIT';

  @override
  String get my_mix => 'MY MIX (ARNOLD+PPL)';

  @override
  String get custom => 'CUSTOM';

  @override
  String get rest_time => 'REST';

  @override
  String get time_up => 'TIME\'S UP!';

  @override
  String get repeat => 'REPEAT';

  @override
  String get stop => 'STOP';

  @override
  String step_of(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get personal_goals => 'GOALS & OBJECTIVES';

  @override
  String get current_weight => 'Current Weight (kg)';

  @override
  String get target_weight => 'Target Weight (kg)';

  @override
  String get height_cm => 'Height (cm)';

  @override
  String get fitness_goal => 'Fitness Goal';

  @override
  String get goal_muscle => 'Build Muscle';

  @override
  String get goal_fat_loss => 'Fat Loss';

  @override
  String get goal_maintain => 'Maintain';

  @override
  String get goal_strength => 'Max Strength';

  @override
  String get weight_journal => 'WEIGHT LOG';

  @override
  String get add_weight_entry => 'Log Weight';

  @override
  String weight_progress_summary(Object percent, Object remaining) {
    return '${remaining}kg to reach your goal ($percent% completed)';
  }

  @override
  String get goal_achieved => 'Congratulations! Target weight achieved.';

  @override
  String get reminders => 'REMINDERS';

  @override
  String get weigh_in_reminder => 'Weigh-in reminder';

  @override
  String get weigh_in_reminder_desc =>
      'Weekly notification to record your body weight';

  @override
  String get interrupted_session_title => 'INTERRUPTED SESSION';

  @override
  String get interrupted_session_msg =>
      'You have an unfinished workout session. Would you like to continue or finish?';

  @override
  String get continue_workout => 'CONTINUE WORKOUT';

  @override
  String get finish_saved_workout => 'FINISH & SAVE';

  @override
  String get edit_profile => 'EDIT PROFILE';
}
