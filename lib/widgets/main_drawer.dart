import 'package:expenses_tracker_tu/screens/items_screen.dart';
import 'package:expenses_tracker_tu/screens/overview.dart';
import 'package:expenses_tracker_tu/widgets/main_frame.dart';
import 'package:expenses_tracker_tu/widgets/settings_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  void onOpenItem(BuildContext context, bool isExpense) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Items(isExpense: isExpense),
      ),
    );
  }

  void openMainScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainFrame(
              title: AppLocalizations.of(context)!.appTitle,
              content: const OverviewScreen(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.fastfood,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(
                  AppLocalizations.of(context)!.menu,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 28,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
              leading: Icon(
                Icons.home,
                size: 24,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: Text(
                AppLocalizations.of(context)!.drawerZero,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 20,
                    ),
              ),
              onTap: () {
                openMainScreen(context);
              }),
          ListTile(
              leading: Icon(
                Icons.money,
                size: 24,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: Text(
                AppLocalizations.of(context)!.drawerSecond,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 20,
                    ),
              ),
              onTap: () {
                onOpenItem(context, false);
              }),
          ListTile(
              leading: Icon(
                Icons.money_off,
                size: 24,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: Text(
                AppLocalizations.of(context)!.drawerFirst,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 20,
                    ),
              ),
              onTap: () {
                onOpenItem(context, true);
              }),
          const Spacer(),
          SettingsContainer()
        ],
      ),
    );
  }
}
