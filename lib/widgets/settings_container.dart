import 'package:expenses_tracker_tu/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsContainer extends ConsumerStatefulWidget {
  const SettingsContainer({super.key});

  @override
  ConsumerState<SettingsContainer> createState() {
    return _SettingsContainerState();
  }
}

class _SettingsContainerState extends ConsumerState<SettingsContainer> {
  Widget determineIconSettings(bool isExpanded) {
    return isExpanded
        ? const Icon(Icons.keyboard_arrow_up)
        : const Icon(Icons.settings);
  }

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return ExpansionTile(
      title: Text(
        AppLocalizations.of(context)!.settings,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 20,
            ),
      ),
      trailing: AnimatedRotation(
          turns: _isExpanded ? .5 : 0,
          duration: const Duration(milliseconds: 500),
          child: determineIconSettings(_isExpanded)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.darkMode,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                    ),
              ),
              const Spacer(),
              const Icon(Icons.light_mode),
              const SizedBox(width: 8),
              Switch(
                value: settings['isDarkMode']!,
                onChanged: (bool value) {
                  ref
                      .read(settingsProvider.notifier)
                      .updateSetting('isDarkMode', value);
                },
              ),
              const SizedBox(width: 8),
              const Icon(Icons.dark_mode)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.language,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                    ),
              ),
              const Spacer(),
              Text('BG',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 16,
                      )),
              const SizedBox(width: 8),
              Switch(
                value: settings['isEnglish']!,
                onChanged: (bool value) {
                  ref
                      .read(settingsProvider.notifier)
                      .updateSetting('isEnglish', value);
                },
              ),
              const SizedBox(width: 8),
              Text(
                'EN',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
      onExpansionChanged: (bool expanded) {
        setState(() => _isExpanded = expanded);
      },
    );
  }
}
