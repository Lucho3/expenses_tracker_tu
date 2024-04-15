import 'package:expenses_tracker_tu/models/expense.dart';
import 'package:expenses_tracker_tu/models/item.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:expenses_tracker_tu/providers/expenses_provider.dart';
import 'package:expenses_tracker_tu/providers/incomes_provider.dart';
import 'package:expenses_tracker_tu/providers/item_provider.dart';
import 'package:expenses_tracker_tu/providers/wallets_provider.dart';
import 'package:expenses_tracker_tu/widgets/items/items_list.dart';
import 'package:expenses_tracker_tu/widgets/main_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Items extends ConsumerStatefulWidget {
  const Items({super.key, required this.isExpense});

  final bool isExpense;

  @override
  ConsumerState<Items> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends ConsumerState<Items> {
  late final provider = (widget.isExpense ? expensesProvider : incomesProvider)
      as AsyncNotifierProvider<ItemNotifier<ItemModel>, List<ItemModel>>;

  String get titleOfScreen {
    if (widget.isExpense) {
      return AppLocalizations.of(context)!.drawerFirst;
    } else {
      return AppLocalizations.of(context)!.drawerSecond;
    }
  }

  void _removeItem(ItemModel item) async {
    await ref.read(provider.notifier).deleteItem(item);

    final walletsP = ref.read(walletsProvider.notifier);
    List<Wallet> wallets = await ref.read(walletsProvider.future);
    Wallet? selectedWallet = wallets.firstWhere((w) => w.isSelected);

    if (selectedWallet == null) {
      return;
    }

    double moneyToManipulate = item is Expense ? -item.amount : item.amount;
    selectedWallet.amount -= moneyToManipulate;

    await walletsP.editItem(selectedWallet);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(AppLocalizations.of(context)!.elementDel),
      action: SnackBarAction(
          label: AppLocalizations.of(context)!.undo,
          onPressed: () async {
            await ref.read(provider.notifier).addItem(item);
            selectedWallet.amount += moneyToManipulate;
            await walletsP.editItem(selectedWallet);
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final itemPr = ref.watch(provider);
    final walletPr = ref.read(walletsProvider);

    return walletPr.when(
      data: (selectedWallet) => MainFrame(
        title: titleOfScreen,
        content: itemPr.when(
          data: (items) => items.isNotEmpty && selectedWallet != null
              ? ItemList(
                  onRemoveItem: _removeItem,
                  items: items
                      .where((i) =>
                          i.walletId ==
                          selectedWallet
                              .where((w) => w.isSelected == true)
                              .first
                              .id)
                      .toList(),
                )
              : Center(
                  child: Text(
                    AppLocalizations.of(context)!.noElements,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Text('Error loading items: $error'),
        ),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text('Error loading wallet: $error'),
    );
  }
}
