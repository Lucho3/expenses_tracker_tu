import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:expenses_tracker_tu/providers/expenses_provider.dart';
import 'package:expenses_tracker_tu/providers/incomes_provider.dart';
import 'package:expenses_tracker_tu/providers/wallets_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//TODO use the provider here to toggle different states and so on
class WalletItem extends ConsumerWidget {
  const WalletItem(this.item, {super.key});

  final Wallet item;

  void changeSelectedWallet(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(AppLocalizations.of(context)!.walletChanged),
      ),
    );
    ref.read(walletsProvider.notifier).changeSelected(item);
  }

  void deleteWallet(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.deleteTitle,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 20),
            textAlign: TextAlign.center,
          ),
          content: Text(
            AppLocalizations.of(context)!.deleteText,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog and delete the wallet
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    ).then((confirmed) {
      // If the user confirmed deletion, proceed
      if (confirmed != null && confirmed) {
        // Show a snack bar
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(AppLocalizations.of(context)!.walletDeleted),
          ),
        );
        // Delete the wallet
        ref.read(walletsProvider.notifier).deleteItem(item);
        ref.read(expensesProvider.notifier).removeAllItemsWithWallet(item);
        ref.read(incomesProvider.notifier).removeAllItemsWithWallet(item);
        if (item.isSelected) {
          //This if is important to be here if we move it upwards an error is expected
          if (ref.read(walletsProvider.notifier).items.isNotEmpty) {
            ref
                .read(walletsProvider.notifier)
                .changeSelected(ref.read(walletsProvider.notifier).items[0]);
          }
        }
      }
    });
  }

  Widget buildAccountRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
        SizedBox(width: 8.0),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontSize: 14,
              ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        changeSelectedWallet(context, ref);
      },
      child: Card(
        color: item.isSelected
            ? Theme.of(context).colorScheme.tertiaryContainer
            : Theme.of(context).colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 14,
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAccountRow(
                      context,
                      AppLocalizations.of(context)!.walletName + ':',
                      item.title),
                  buildAccountRow(
                      context,
                      AppLocalizations.of(context)!.amount + ':',
                      '\$${item.amount.toStringAsFixed(2)}'),
                  TextButton(
                    onPressed: () {},
                    child: Text(AppLocalizations.of(context)!.edit),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft,
                      splashFactory: NoSplash.splashFactory,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteWallet(context, ref);
                        },
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
