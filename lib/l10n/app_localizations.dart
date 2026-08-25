import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @app_name.
  ///
  /// In es, this message translates to:
  /// **'RITMO'**
  String get app_name;

  /// No description provided for @today.
  ///
  /// In es, this message translates to:
  /// **'HOY'**
  String get today;

  /// No description provided for @history.
  ///
  /// In es, this message translates to:
  /// **'HISTORIAL'**
  String get history;

  /// No description provided for @progress.
  ///
  /// In es, this message translates to:
  /// **'PROGRESO'**
  String get progress;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'CONFIGURACIÓN'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'PERFIL'**
  String get profile;

  /// No description provided for @rest_between_sets.
  ///
  /// In es, this message translates to:
  /// **'DESCANSO ENTRE SERIES'**
  String get rest_between_sets;

  /// No description provided for @planner_mode.
  ///
  /// In es, this message translates to:
  /// **'MODO DE PLANIFICACIÓN'**
  String get planner_mode;

  /// No description provided for @cycle.
  ///
  /// In es, this message translates to:
  /// **'CICLO'**
  String get cycle;

  /// No description provided for @calendar.
  ///
  /// In es, this message translates to:
  /// **'CALENDARIO'**
  String get calendar;

  /// No description provided for @day_assignment.
  ///
  /// In es, this message translates to:
  /// **'ASIGNACIÓN POR DÍAS'**
  String get day_assignment;

  /// No description provided for @cycle_order.
  ///
  /// In es, this message translates to:
  /// **'ORDEN DEL CICLO'**
  String get cycle_order;

  /// No description provided for @add_group.
  ///
  /// In es, this message translates to:
  /// **'AÑADIR GRUPO'**
  String get add_group;

  /// No description provided for @restore_routine.
  ///
  /// In es, this message translates to:
  /// **'RESTAURAR RUTINA'**
  String get restore_routine;

  /// No description provided for @active_exercises.
  ///
  /// In es, this message translates to:
  /// **'EJERCICIOS ACTIVOS'**
  String get active_exercises;

  /// No description provided for @archived.
  ///
  /// In es, this message translates to:
  /// **'ARCHIVADOS'**
  String get archived;

  /// No description provided for @new_routine.
  ///
  /// In es, this message translates to:
  /// **'NUEVA RUTINA'**
  String get new_routine;

  /// No description provided for @add_exercise.
  ///
  /// In es, this message translates to:
  /// **'AÑADIR EJERCICIO'**
  String get add_exercise;

  /// No description provided for @finish_workout.
  ///
  /// In es, this message translates to:
  /// **'FINALIZAR'**
  String get finish_workout;

  /// No description provided for @training.
  ///
  /// In es, this message translates to:
  /// **'ENTRENANDO'**
  String get training;

  /// No description provided for @personal_record.
  ///
  /// In es, this message translates to:
  /// **'RÉCORD PERSONAL'**
  String get personal_record;

  /// No description provided for @last_time.
  ///
  /// In es, this message translates to:
  /// **'VEZ ANTERIOR'**
  String get last_time;

  /// No description provided for @weight.
  ///
  /// In es, this message translates to:
  /// **'PESO'**
  String get weight;

  /// No description provided for @reps.
  ///
  /// In es, this message translates to:
  /// **'REPS'**
  String get reps;

  /// No description provided for @save_set.
  ///
  /// In es, this message translates to:
  /// **'GUARDAR SERIE'**
  String get save_set;

  /// No description provided for @no_activity.
  ///
  /// In es, this message translates to:
  /// **'SIN ACTIVIDAD'**
  String get no_activity;

  /// No description provided for @onboarding_title.
  ///
  /// In es, this message translates to:
  /// **'RITMO'**
  String get onboarding_title;

  /// No description provided for @onboarding_subtitle.
  ///
  /// In es, this message translates to:
  /// **'Tu compañero definitivo de entrenamiento de alto rendimiento.'**
  String get onboarding_subtitle;

  /// No description provided for @get_started.
  ///
  /// In es, this message translates to:
  /// **'COMENZAR AHORA'**
  String get get_started;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'IDIOMA'**
  String get language;

  /// No description provided for @version.
  ///
  /// In es, this message translates to:
  /// **'Versión 3.0.0 Luxury'**
  String get version;

  /// No description provided for @delete_exercise.
  ///
  /// In es, this message translates to:
  /// **'ELIMINAR EJERCICIO'**
  String get delete_exercise;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'CANCELAR'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In es, this message translates to:
  /// **'CONFIRMAR'**
  String get confirm;

  /// No description provided for @exit_workout.
  ///
  /// In es, this message translates to:
  /// **'SALIR DEL ENTRENAMIENTO'**
  String get exit_workout;

  /// No description provided for @delete_history_item.
  ///
  /// In es, this message translates to:
  /// **'ELIMINAR DEL HISTORIAL'**
  String get delete_history_item;

  /// No description provided for @strength_progress.
  ///
  /// In es, this message translates to:
  /// **'PROGRESO DE FUERZA'**
  String get strength_progress;

  /// No description provided for @all_sets.
  ///
  /// In es, this message translates to:
  /// **'TODAS LAS SERIES'**
  String get all_sets;

  /// No description provided for @monday.
  ///
  /// In es, this message translates to:
  /// **'Lunes'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In es, this message translates to:
  /// **'Martes'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In es, this message translates to:
  /// **'Miércoles'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In es, this message translates to:
  /// **'Jueves'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In es, this message translates to:
  /// **'Viernes'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In es, this message translates to:
  /// **'Sábado'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In es, this message translates to:
  /// **'Domingo'**
  String get sunday;

  /// No description provided for @rest_day.
  ///
  /// In es, this message translates to:
  /// **'DESCANSO'**
  String get rest_day;

  /// No description provided for @routine_structure.
  ///
  /// In es, this message translates to:
  /// **'ESTRUCTURA DE RUTINA'**
  String get routine_structure;

  /// No description provided for @select_base.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una base. Tus pesos históricos se mantendrán.'**
  String get select_base;

  /// No description provided for @ppl.
  ///
  /// In es, this message translates to:
  /// **'PUSH PULL LEG'**
  String get ppl;

  /// No description provided for @full_body.
  ///
  /// In es, this message translates to:
  /// **'FULL BODY'**
  String get full_body;

  /// No description provided for @upper_lower.
  ///
  /// In es, this message translates to:
  /// **'UPPER LOWER'**
  String get upper_lower;

  /// No description provided for @arnold_split.
  ///
  /// In es, this message translates to:
  /// **'ARNOLD SPLIT'**
  String get arnold_split;

  /// No description provided for @my_mix.
  ///
  /// In es, this message translates to:
  /// **'MI MEZCLA (ARNOLD+PPL)'**
  String get my_mix;

  /// No description provided for @custom.
  ///
  /// In es, this message translates to:
  /// **'PERSONALIZADO'**
  String get custom;

  /// No description provided for @rest_time.
  ///
  /// In es, this message translates to:
  /// **'DESCANSO'**
  String get rest_time;

  /// No description provided for @time_up.
  ///
  /// In es, this message translates to:
  /// **'¡TIEMPO!'**
  String get time_up;

  /// No description provided for @repeat.
  ///
  /// In es, this message translates to:
  /// **'REPETIR'**
  String get repeat;

  /// No description provided for @stop.
  ///
  /// In es, this message translates to:
  /// **'DETENER'**
  String get stop;

  /// No description provided for @step_of.
  ///
  /// In es, this message translates to:
  /// **'Paso {current} de {total}'**
  String step_of(Object current, Object total);

  /// No description provided for @personal_goals.
  ///
  /// In es, this message translates to:
  /// **'METAS Y OBJETIVOS'**
  String get personal_goals;

  /// No description provided for @current_weight.
  ///
  /// In es, this message translates to:
  /// **'Peso Actual (kg)'**
  String get current_weight;

  /// No description provided for @target_weight.
  ///
  /// In es, this message translates to:
  /// **'Peso Objetivo (kg)'**
  String get target_weight;

  /// No description provided for @height_cm.
  ///
  /// In es, this message translates to:
  /// **'Altura (cm)'**
  String get height_cm;

  /// No description provided for @fitness_goal.
  ///
  /// In es, this message translates to:
  /// **'Objetivo de Entrenamiento'**
  String get fitness_goal;

  /// No description provided for @goal_muscle.
  ///
  /// In es, this message translates to:
  /// **'Ganar Músculo'**
  String get goal_muscle;

  /// No description provided for @goal_fat_loss.
  ///
  /// In es, this message translates to:
  /// **'Perder Grasa'**
  String get goal_fat_loss;

  /// No description provided for @goal_maintain.
  ///
  /// In es, this message translates to:
  /// **'Mantener Forma'**
  String get goal_maintain;

  /// No description provided for @goal_strength.
  ///
  /// In es, this message translates to:
  /// **'Fuerza Máxima'**
  String get goal_strength;

  /// No description provided for @weight_journal.
  ///
  /// In es, this message translates to:
  /// **'DIARIO DE PESO'**
  String get weight_journal;

  /// No description provided for @add_weight_entry.
  ///
  /// In es, this message translates to:
  /// **'Registrar Peso'**
  String get add_weight_entry;

  /// No description provided for @weight_progress_summary.
  ///
  /// In es, this message translates to:
  /// **'Te faltan {remaining}kg para tu objetivo ({percent}% completado)'**
  String weight_progress_summary(Object percent, Object remaining);

  /// No description provided for @goal_achieved.
  ///
  /// In es, this message translates to:
  /// **'¡Felicidades! Has alcanzado tu peso objetivo.'**
  String get goal_achieved;

  /// No description provided for @reminders.
  ///
  /// In es, this message translates to:
  /// **'RECORDATORIOS'**
  String get reminders;

  /// No description provided for @weigh_in_reminder.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio de pesaje'**
  String get weigh_in_reminder;

  /// No description provided for @weigh_in_reminder_desc.
  ///
  /// In es, this message translates to:
  /// **'Notificación semanal para registrar tu peso'**
  String get weigh_in_reminder_desc;

  /// No description provided for @interrupted_session_title.
  ///
  /// In es, this message translates to:
  /// **'ENTRENAMIENTO INTERRUMPIDO'**
  String get interrupted_session_title;

  /// No description provided for @interrupted_session_msg.
  ///
  /// In es, this message translates to:
  /// **'Tienes una sesión sin finalizar. ¿Deseas continuar o guardar lo avanzado?'**
  String get interrupted_session_msg;

  /// No description provided for @continue_workout.
  ///
  /// In es, this message translates to:
  /// **'CONTINUAR ENTRENAMIENTO'**
  String get continue_workout;

  /// No description provided for @finish_saved_workout.
  ///
  /// In es, this message translates to:
  /// **'FINALIZAR Y GUARDAR'**
  String get finish_saved_workout;

  /// No description provided for @edit_profile.
  ///
  /// In es, this message translates to:
  /// **'EDITAR PERFIL'**
  String get edit_profile;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
