import 'package:floor/floor.dart';

@Entity(tableName: 'settings')
class Settings {
   @PrimaryKey(autoGenerate: true)
  int? id;
  bool isEnglish;
  bool isDarkMode;

  Settings({
    required this.isEnglish,
    required this.isDarkMode,
  });
}