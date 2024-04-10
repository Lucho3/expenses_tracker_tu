import 'package:expenses_tracker_tu/screens/new_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({super.key});

  void _openAddItemOverlay(BuildContext context, String type) {
    showModalBottomSheet(
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewItem(itemType: type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onBackground,
      overlayColor: Theme.of(context).colorScheme.secondaryContainer,
      overlayOpacity: 0.2,
      spacing: 16,
      spaceBetweenChildren: 4,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(
            Icons.remove,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          label: AppLocalizations.of(context)!.expense,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          shape: const CircleBorder(),
          backgroundColor: const Color.fromARGB(255, 253, 73, 46),
          onTap: () { 
            _openAddItemOverlay(context, "Expense");
          },
        ),
        SpeedDialChild(
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          label: AppLocalizations.of(context)!.income,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          backgroundColor: const Color.fromARGB(255, 30, 151, 8),
          shape: const CircleBorder(),
          onTap: () {
            _openAddItemOverlay(context, "Income");
          },
        ),
        SpeedDialChild(
          child: Icon(
            Icons.sync_alt,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          label: AppLocalizations.of(context)!.trMoney,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          shape: const CircleBorder(),
          onTap: () {

          },
        )
      ],
    );
  }
}
