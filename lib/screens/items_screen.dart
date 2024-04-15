import 'package:expenses_tracker_tu/models/expense.dart';
import 'package:expenses_tracker_tu/models/item.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:expenses_tracker_tu/providers/expenses_provider.dart';
import 'package:expenses_tracker_tu/providers/incomes_provider.dart';
import 'package:expenses_tracker_tu/providers/item_provider.dart';
import 'package:expenses_tracker_tu/providers/settings_provider.dart';
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
  late final provider;

  String get titleOfScreen {
    if (widget.isExpense) {
      return AppLocalizations.of(context)!.drawerFirst;
    } else {
      return AppLocalizations.of(context)!.drawerSecond;
    }
  }

  @override
  void initState() {
    provider = (widget.isExpense ? expensesProvider : incomesProvider)
        as NotifierProvider<ItemNotifier<ItemModel>, List<ItemModel>>;
    super.initState();
  }

  void _removeItem(ItemModel item) {
    ref.read(provider.notifier).deleteItem(item);
    final walletsP = ref.read(walletsProvider.notifier);
    //TODO: async
    final selectedWallet =
        walletsP.items.value!.where((w) => w.isSelected == true).first;
    double moneyToManipulate;
    item is Expense
        ? moneyToManipulate = item.amount * -1
        : moneyToManipulate = item.amount;
    selectedWallet.amount -= moneyToManipulate;

    //TODO: this undo is problematic if we go to main screen anc click undo it doesnt work
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(AppLocalizations.of(context)!.elementDel),
        action: SnackBarAction(
            label: AppLocalizations.of(context)!.undo,
            onPressed: () {
              ref.read(provider.notifier).addItem(item);
              selectedWallet.amount += moneyToManipulate;
            }),
      ),
    );
    walletsP.editItem(selectedWallet);
  }

  @override
  Widget build(BuildContext context) {
    final itemsProvider = ref.watch(provider);
    ref.watch(settingsProvider);

    Widget mainContent = Center(
      child: Text(
        AppLocalizations.of(context)!.noElements,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );

    //TODO: check for current wallet
    if (itemsProvider.isNotEmpty) {
      mainContent = ItemList(
        onRemoveItem: _removeItem,
        provider: provider,
      );
    }

    return MainFrame(
      title: titleOfScreen,
      content: mainContent,
    );
  }
}
