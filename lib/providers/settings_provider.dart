import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends StateNotifier<Map<String, bool>> {
  SettingsNotifier()
      : super({
          'isEnglish': true,
          'isDarkMode': true,
        });
  
  void setSetting(String setting, bool newState) {
    state = {
      ...state,
      setting: newState,
    };
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, Map<String, bool>>(
        (ref) => SettingsNotifier());