import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:off_vape/local_storage/user_settings.dart';

class SettingsState {
  final int dailyLimit;
  final String languageCode;

  const SettingsState({required this.dailyLimit, required this.languageCode});

  SettingsState copyWith({int? dailyLimit, String? languageCode}) {
    return SettingsState(
      dailyLimit: dailyLimit ?? this.dailyLimit,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    _loadSettings();
    return const SettingsState(dailyLimit: 30, languageCode: 'en');
  }

  Future<void> _loadSettings() async {
    final limit = await UserSettings.getDailyLimit();
    final lang = await UserSettings.getLanguage();
    state = SettingsState(dailyLimit: limit, languageCode: lang);
  }

  Future<void> updateLimit(int newLimit) async {
    await UserSettings.setDailyLimit(newLimit);
    state = state.copyWith(dailyLimit: newLimit);
  }

  Future<void> updateLanguage(String lang) async {
    await UserSettings.setLanguage(lang);
    state = state.copyWith(languageCode: lang);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
