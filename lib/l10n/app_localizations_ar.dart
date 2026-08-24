// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get app_name => 'ترينر برو';

  @override
  String get today => 'اليوم';

  @override
  String get history => 'السجل';

  @override
  String get progress => 'التقدم';

  @override
  String get settings => 'الإعدادات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get rest_between_sets => 'الراحة بين الجولات';

  @override
  String get planner_mode => 'وضع التخطيط';

  @override
  String get cycle => 'الدورة';

  @override
  String get calendar => 'التقويم';

  @override
  String get day_assignment => 'تعيين الأيام';

  @override
  String get cycle_order => 'ترتيب الدورة';

  @override
  String get add_group => 'إضافة مجموعة';

  @override
  String get restore_routine => 'استعادة الروتين';

  @override
  String get active_exercises => 'التمارين النشطة';

  @override
  String get archived => 'المؤرشفة';

  @override
  String get new_routine => 'روتين جديد';

  @override
  String get add_exercise => 'إضافة تمرين';

  @override
  String get finish_workout => 'إنهاء';

  @override
  String get training => 'يتمرن الآن';

  @override
  String get personal_record => 'الرقم القياسي الشخصي';

  @override
  String get last_time => 'المرة السابقة';

  @override
  String get weight => 'الوزن';

  @override
  String get reps => 'التكرارات';

  @override
  String get save_set => 'حفظ الجولة';

  @override
  String get no_activity => 'لا يوجد نشاط';

  @override
  String get onboarding_title => 'ترينر برو';

  @override
  String get onboarding_subtitle => 'رفيقك النهائي للتدريب عالي الأداء.';

  @override
  String get get_started => 'ابدأ الآن';

  @override
  String get language => 'اللغة';

  @override
  String get version => 'الإصدار 3.0.0 الفاخر';

  @override
  String get delete_exercise => 'حذف التمرين';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get exit_workout => 'الخروج من التمرين';

  @override
  String get delete_history_item => 'حذف من السجل';

  @override
  String get strength_progress => 'تقدم القوة';

  @override
  String get all_sets => 'جميع الجولات';

  @override
  String get monday => 'الإثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';

  @override
  String get sunday => 'الأحد';

  @override
  String get rest_day => 'راحة';

  @override
  String get routine_structure => 'هيكل الروتين';

  @override
  String get select_base =>
      'اختر قاعدة الروتين. سيتم الاحتفاظ بأوزانك التاريخية.';

  @override
  String get ppl => 'دفع سحب أرجل (PPL)';

  @override
  String get full_body => 'كامل الجسم';

  @override
  String get upper_lower => 'علوي سفلي';

  @override
  String get arnold_split => 'تقسيم أرنولد';

  @override
  String get my_mix => 'مزيجي (أرنولد + PPL)';

  @override
  String get custom => 'مخصص';

  @override
  String get rest_time => 'الراحة';

  @override
  String get time_up => 'انتهى الوقت!';

  @override
  String get repeat => 'تكرار';

  @override
  String get stop => 'إيقاف';

  @override
  String step_of(Object current, Object total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get personal_goals => 'الأهداف والغايات';

  @override
  String get current_weight => 'الوزن الحالي (كجم)';

  @override
  String get target_weight => 'الوزن المستهدف (كجم)';

  @override
  String get height_cm => 'الطول (سم)';

  @override
  String get fitness_goal => 'هدف التدريب';

  @override
  String get goal_muscle => 'بناء العضلات';

  @override
  String get goal_fat_loss => 'خسارة الدهون';

  @override
  String get goal_maintain => 'الحفاظ على اللياقة';

  @override
  String get goal_strength => 'أقصى قوة';

  @override
  String get weight_journal => 'سجل الوزن';

  @override
  String get add_weight_entry => 'تسجيل الوزن';

  @override
  String weight_progress_summary(Object percent, Object remaining) {
    return 'متبقي $remaining كجم للوصول لهدفك (تم إنجاز $percent%)';
  }

  @override
  String get goal_achieved => 'تهانينا! تم تحقيق الوزن المستهدف.';

  @override
  String get reminders => 'التذكيرات';

  @override
  String get weigh_in_reminder => 'تذكير قياس الوزن';

  @override
  String get weigh_in_reminder_desc => 'إشعار أسبوعي لتسجيل وزنك';

  @override
  String get interrupted_session_title => 'تمرين غير مكتمل';

  @override
  String get interrupted_session_msg =>
      'لديك جلسة تمرين لم تنته بعد. هل تريد المتابعة أم الإنهاء والحفظ؟';

  @override
  String get continue_workout => 'متابعة التمرين';

  @override
  String get finish_saved_workout => 'إنهاء وحفظ';

  @override
  String get edit_profile => 'تعديل الملف الشخصي';
}
