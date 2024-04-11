import 'package:expenses_tracker_tu/models/expense.dart';
import 'package:expenses_tracker_tu/models/income.dart';
import 'package:expenses_tracker_tu/models/item.dart';
import 'package:expenses_tracker_tu/screens/new_item.dart';
import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  final ItemModel item;

  const Item(this.item, {super.key});

  void _openAddItemOverlay(BuildContext context) {
    showModalBottomSheet(
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewItem(
        isExpense: item is Expense ? true : false,
        item: item,
      ),
    );
  }

  Widget determineTypeOfItem(BuildContext context) {
    if (item is Expense) {
      return Icon(
        categoryIcon[(item as Expense).category],
        color: Theme.of(context).colorScheme.primary,
      );
    } else {
      return Icon(
        typeIcon[(item as Income).type],
        color: Theme.of(context).colorScheme.primary,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: () {
      _openAddItemOverlay(context);
    },
    child: Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    )),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('\$${item.amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                const Spacer(),
                Row(children: [
                  determineTypeOfItem(context),
                  const SizedBox(width: 8),
                  Text(item.formattedDate,
                      style:
                          Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              )),
                ])
              ],
            )
          ],
        ),
      ),
    ),
  );
  }
}
