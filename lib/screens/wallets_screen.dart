import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:expenses_tracker_tu/providers/wallets_provider.dart';
import 'package:expenses_tracker_tu/widgets/main_frame.dart';
import 'package:expenses_tracker_tu/widgets/wallets/wallets_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Wallets extends ConsumerStatefulWidget {
  const Wallets({super.key});

  @override
  ConsumerState<Wallets> createState() {
    return _WalletsState();
  }
}

class _WalletsState extends ConsumerState<Wallets> {
  Widget generateMainContent(Widget mainContent) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextButton(
                onPressed: () {
                },
                child: Text(AppLocalizations.of(context)!.add),
              ),
            ),
        ],
      ),
      Divider(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        indent: MediaQuery.of(context).size.width * 0.05,
        endIndent: MediaQuery.of(context).size.width * 0.05,
        thickness: 2,
      ),
      mainContent,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(walletsProvider);

    Widget mainContent = Expanded(
      child: 
        Center(
          child: Text(
            AppLocalizations.of(context)!.noElements,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
    );

    if (wallets.isNotEmpty) {
      mainContent = WalletsList(items: wallets);
    }

    return MainFrame(
      title: AppLocalizations.of(context)!.allWallets,
      content: generateMainContent(mainContent),
    );
  }
}
