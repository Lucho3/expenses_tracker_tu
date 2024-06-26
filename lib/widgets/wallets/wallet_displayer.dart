import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:expenses_tracker_tu/screens/wallets_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expenses_tracker_tu/providers/wallets_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WalletsDisplayer extends ConsumerStatefulWidget {
  const WalletsDisplayer({super.key});

  @override
  _WalletsDisplayerState createState() {
    return _WalletsDisplayerState();
  }
}

class _WalletsDisplayerState extends ConsumerState<WalletsDisplayer> {
  void _openWalletsScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Wallets(),
      ),
    );
  }

  Widget buildAccountRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(width: 8.0),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: 16,
                  ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> rowBuilder(List<Wallet> walletList) {
    if (walletList.isNotEmpty) {
      return [
        buildAccountRow('${AppLocalizations.of(context)!.walletName}:',
            walletList.where((w) => w.isSelected == true).first.title),
        buildAccountRow('${AppLocalizations.of(context)!.amount}:',
            '\$${walletList.where((w) => w.isSelected == true).first.amount.toStringAsFixed(2)}')
      ];
    }
    return [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.noWallets,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(walletsProvider);
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 2.0,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                    flex: 8,
                    child: Text(
                      AppLocalizations.of(context)!.sWallet,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                        iconSize: 20,
                        icon: const Icon(Icons.more_vert),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          _openWalletsScreen(context);
                        },
                      )),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              indent: MediaQuery.of(context).size.width * 0.05,
              endIndent: MediaQuery.of(context).size.width * 0.05,
              thickness: 2,
            ),
            provider.when(
              data: (wallets) => Column(children: rowBuilder(wallets)),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
      ),
    );
  }
}
