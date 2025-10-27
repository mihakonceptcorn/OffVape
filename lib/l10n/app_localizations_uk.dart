// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get language => 'Мова';

  @override
  String get userMaxNum => 'Максимум перекурів на день:';

  @override
  String get changeLanguage => 'Змінити мову';

  @override
  String get clearAll => 'Очистити дані';

  @override
  String get changeMaxBreaks => 'Змінити кількість перекурів';

  @override
  String get homeVapeBreaks => 'ВейпоПарок з';

  @override
  String get homeMinAgo => 'хвилин тому';

  @override
  String get homeSToday => 'замін сьогодні';

  @override
  String get homeStBtn => 'Статистика';

  @override
  String get homeAddBtn => 'Вейпінг';

  @override
  String get homeQuickBtn => 'Швидка вправа замість вейпінгу';

  @override
  String get homeStatsTitle => 'Статистика за минулі 7 днів';
}
