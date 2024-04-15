import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final settingsProvider = StateNotifierProvider<SettingsController, Map<String, bool>>((ref) {
  return SettingsController();
});

class SettingsController extends StateNotifier<Map<String, bool>> {
  SettingsController() : super({}) {
    ensureFileExists().then((_) => _loadSettings());
  }

Future<void> _loadSettings() async {
  final file = await _localFile;
  if (await file.exists()) {
    final contents = await file.readAsString();
    Map<String, dynamic> jsonData = json.decode(contents);
    Map<String, bool> settingsMap = {};

    // Convert and validate jsonData to ensure all values are bool
    jsonData.forEach((key, value) {
      if (value is bool) {
        settingsMap[key] = value;
      } else {
        // Optionally handle incorrect types, e.g., log an error or assign a default value
        // Assuming default values here for non-bool types
        settingsMap[key] = false;  // Or true, depending on your default logic
      }
    });

    state = settingsMap;
  } else {
    state = {
      'isEnglish': true,  // Default value for 'isEnglish'
      'isDarkMode': true, // Default value for 'isDarkMode'
    };
  }
}

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/settings.json');
  }

  Future<void> updateSetting(String key, bool value) async {
    state = {
      ...state,
      key: value,
    };
    await _saveSettings();
  }

  Future<void> _saveSettings() async {
    final file = await _localFile;
    await file.writeAsString(json.encode(state));
  }

  Future<void> ensureFileExists() async {
    final file = await _localFile;
    if (!await file.exists()) {
        await file.create();
        await file.writeAsString(json.encode({
          'isEnglish': true,
          'isDarkMode': true,
        })); 
    }
}
}