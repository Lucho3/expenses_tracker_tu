import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:expenses_tracker_tu/providers/wallets_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferMoney extends ConsumerStatefulWidget {
  const TransferMoney({super.key});

  @override
  ConsumerState<TransferMoney> createState() {
    return _TransferMoneyState();
  }
}

class _TransferMoneyState extends ConsumerState<TransferMoney> {
  final _amountController = TextEditingController();
  late Wallet? selectedWalletOne;
  late Wallet? selectedWalletTwo;

  @override
  void initState() {
    selectedWalletOne = null;
    selectedWalletTwo = null;
    super.initState();
  }

  void dialogShower(String l1, String l2) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(l1,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      )),
              content: Text(
                l2,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  DropdownMenu createCustomMenu(
      String label, bool isValueOne, List<Wallet> walletsList) {
    List<Wallet> customWalletList = walletsList
        .where((w) => ![selectedWalletOne, selectedWalletTwo].contains(w))
        .toList();
    List<DropdownMenuEntry<Wallet?>> entries =
        customWalletList.map<DropdownMenuEntry<Wallet?>>((Wallet w) {
      return DropdownMenuEntry(
        value: w,
        label: w.title,
        labelWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              w.title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Divider(color: Theme.of(context).colorScheme.onPrimaryContainer),
          ],
        ),
      );
    }).toList();

    if (customWalletList.isEmpty) {
      entries.add(
        DropdownMenuEntry(
          value: null,
          label: AppLocalizations.of(context)!.noMoreWallets,
          labelWidget: Text(
            AppLocalizations.of(context)!.noMoreWallets,
            style: TextStyle(
              color: Theme.of(context).disabledColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          enabled: false, // Disable the entry
        ),
      );
    }

    return DropdownMenu(
        label: Text(label,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.primary, fontSize: 16)),
        textStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: Theme.of(context).colorScheme.primary, fontSize: 16),
        menuStyle: MenuStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(
              Theme.of(context).colorScheme.primaryContainer),
        ),
        width: MediaQuery.of(context).size.width * 0.92,
        onSelected: (value) {
          setState(() {
            isValueOne
                ? selectedWalletOne = value!
                : selectedWalletTwo = value!;
          });
        },
        dropdownMenuEntries: entries);
  }

  void _saveTransfer() async {
    final enteredAmount = double.tryParse(_amountController.text);
    if (enteredAmount == null || enteredAmount <= 0) {
      dialogShower(AppLocalizations.of(context)!.alertTitle,
          AppLocalizations.of(context)!.alertContent);
      return;
    }

    if (selectedWalletOne!.amount < enteredAmount) {
      dialogShower(AppLocalizations.of(context)!.notEnoughMoneyTitle,
          AppLocalizations.of(context)!.notEnoughMoneyToTransfer);
      return;
    }
    
    selectedWalletOne!.amount -=enteredAmount;
    selectedWalletTwo!.amount +=enteredAmount;
    await ref.read(walletsProvider.notifier).editItem(selectedWalletOne!);
    await ref.read(walletsProvider.notifier).editItem(selectedWalletTwo!);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(AppLocalizations.of(context)!.transactionCompleted),
      ),
    );

    Navigator.pop(context);
  }

  List<Widget> widgetsPortrait(List<Wallet> wallets) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              AppLocalizations.of(context)!.moneyTransfer,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Divider(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          thickness: 2,
        ),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: createCustomMenu(
              AppLocalizations.of(context)!.chooseWalletOne, true, wallets)),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: createCustomMenu(
              AppLocalizations.of(context)!.chooseWalletTwo, false, wallets)),
      Padding(
        padding: const EdgeInsets.only(bottom: 4.0, top: 4.0),
        child: TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.amount,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    )),
            prefixText: '\$ ',
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      Padding(
          padding: const EdgeInsets.only(bottom: 4.0, top: 4.0),
          child: Text(AppLocalizations.of(context)!.transferInstructions,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ))),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      )),
            ),
            ElevatedButton(
              onPressed: _saveTransfer,
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer),
              child: Text(AppLocalizations.of(context)!.transfer,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      )),
            ),
          ],
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final walletsAsyncValue =
        ref.watch(walletsProvider); // Watching the walletsProvider

    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                walletsAsyncValue.when(
                  data: (wallets) => Column(children: [
                    ...widgetsPortrait(wallets)
                  ]), // Pass wallets to the function
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, stack) => Text('Error: $e'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
