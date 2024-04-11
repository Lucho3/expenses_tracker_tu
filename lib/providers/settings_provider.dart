import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() {
    return {
          'isEnglish': true,
          'isDarkMode': true,
        };
  }
  
  void setSetting(String setting, bool newState) {
    state = {
      ...state,
      setting: newState,
    };
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, Map<String, bool>>(
        () => SettingsNotifier());