import 'package:expenses_tracker_tu/models/wallet.dart';
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
                        onPressed: () {},
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
