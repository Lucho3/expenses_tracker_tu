import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:expenses_tracker_tu/models/item.dart';
import 'package:expenses_tracker_tu/providers/expenses_provider.dart';
import 'package:expenses_tracker_tu/providers/incomes_provider.dart';
import 'package:expenses_tracker_tu/widgets/items/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemList extends ConsumerWidget {
  ItemList({super.key, required bool this.isExpense});
  late List<ItemModel> items;
  final bool isExpense;

  void _removeExpense(BuildContext context, ItemModel item) {
    final indexOfRemovedExpense = items.indexOf(item);
    //trqbva da maham ot notifier
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content:  Text(AppLocalizations.of(context)!.elementDel),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.undo,
          onPressed: () {
              //da advam v notifier
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    items = isExpense ? ref.read(expensesProvider.notifier).expenses :  ref.read(incomesProvider.notifier).incomes;
    return ListView.builder(
      // Item count sets the maximum number of return widgets
      itemCount: items.length,
      itemBuilder: (ctx, index) => Dismissible(
          background: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).colorScheme.error.withOpacity(0.65),
            ),
            margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          ),
          key: ValueKey(items[index]),
          //from provider
          onDismissed: (direction) => _removeExpense(context, items[index], items),
          child: Item(items[index])),
    );
  }
}
