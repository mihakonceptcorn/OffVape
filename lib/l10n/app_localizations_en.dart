// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get userMaxNum => 'Maximum vape breaks per day:';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get clearAll => 'Clear all data';

  @override
  String get changeMaxBreaks => 'Change MaxBreaks';

  @override
  String get homeVapeBreaks => 'VapeBreaks of';

  @override
  String get homeMinAgo => 'min ago';

  @override
  String get homeSToday => 'Substitutes today';

  @override
  String get homeStBtn => 'Statistics';

  @override
  String get homeAddBtn => 'Vape Break';

  @override
  String get homeQuickBtn => 'Quick exercise instead of vaping';

  @override
  String get homeStatsTitle => 'Statistics for the past 7 days';
}
