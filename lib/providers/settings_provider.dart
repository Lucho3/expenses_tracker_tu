import 'package:expenses_tracker_tu/models/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends Notifier<Settings> {
  @override
  Settings build() {
    return Settings(isEnglish: true, isDarkMode: true);
  }
  
  void setSetting(String setting, bool newState) {
  if (setting == 'isEnglish') {
    state = Settings(
      isEnglish: newState,
      isDarkMode: state.isDarkMode,
    );
  } else if (setting == 'isDarkMode') {
    state = Settings(
      isEnglish: state.isEnglish,
      isDarkMode: newState,
    );
  }
}
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, Settings>(
        () => SettingsNotifier());