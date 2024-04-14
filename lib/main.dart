import 'package:expenses_tracker_tu/l10n/l10n.dart';
import 'package:expenses_tracker_tu/providers/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:expenses_tracker_tu/screens/overview.dart';
import 'package:expenses_tracker_tu/widgets/main_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData createTheme(bool isDark) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: isDark ? Brightness.dark : Brightness.light,
      seedColor: Color.fromARGB(255, 117, 5, 173),
    ),
    cardTheme: const CardTheme().copyWith(
        margin: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 6,
    )),
    textTheme: GoogleFonts.latoTextTheme(),
    
  );
}

void main() {
  runApp(const ProviderScope(
    child: App(),
  ));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.all,
        locale: Locale(settings.isEnglish! ? 'en' : 'bg'),
        theme: createTheme(settings.isDarkMode!),
        home: Builder(
          builder: (context) {
            return MainFrame(
              title: AppLocalizations.of(context)!.appTitle,
              content: const OverviewScreen(),
            );
          },
        ));
  }
}
