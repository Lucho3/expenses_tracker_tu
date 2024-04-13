import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:expenses_tracker_tu/providers/wallets_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferMoney extends ConsumerStatefulWidget {
  TransferMoney({super.key});

  @override
  ConsumerState<TransferMoney> createState() {
    return _TransferMoneyState();
  }
}

class _TransferMoneyState extends ConsumerState<TransferMoney> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  late final walletsP;
  String q = "";

  @override
  void initState() {
    walletsP = ref.read(walletsProvider.notifier);
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
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

  bool evaluateInput(double? enteredAmount) {
    final isAmountInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty || isAmountInvalid) {
      dialogShower(AppLocalizations.of(context)!.alertTitle,
          AppLocalizations.of(context)!.alertContent);
      return false;
    }
    return true;
  }

  void _submitItemData() {
    final enteredAmount = double.tryParse(_amountController.text);
    if (evaluateInput(enteredAmount)) {
      walletsP.addItem(Wallet(
          title: _titleController.text,
          amount: enteredAmount!,
          isSelected: walletsP.items.isEmpty ? true : false));
      Navigator.pop(context);
    }
  }

  void _saveTransfer() {}

  List<Widget> widgetsPortrait() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              AppLocalizations.of(context)!.walletsDetails,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      Divider(
        color: Theme.of(context).colorScheme.onPrimaryContainer,

        thickness: 2,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: DropdownMenu(
          width: MediaQuery.of(context).size.width * 0.92,
          initialSelection: q,
          onSelected: (String? value) {
            setState(() {
              q = value!;
            });
          },
          dropdownMenuEntries:
              [q, "sad"].map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(
              value: value,
              label: value,
            );
          }).toList(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: DropdownMenu(
          width: MediaQuery.of(context).size.width * 0.92,
          initialSelection: q,
          onSelected: (String? value) {
            setState(() {
              q = value!;
            });
          },
          dropdownMenuEntries:
              [q, "sad"].map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(
              value: value,
              label: value,
            );
          }).toList(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 4.0, top: 4.0),
        child: TextField(
          maxLength: 50,
          controller: _titleController,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.walletName,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    )),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 8.0),
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
              child: Text(AppLocalizations.of(context)!.save,
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
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [...widgetsPortrait()],
            ),
          ),
        ),
      );
    });
  }
}
