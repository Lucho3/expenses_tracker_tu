import 'package:expenses_tracker_tu/models/expense.dart';
import 'package:expenses_tracker_tu/widgets/items/item.dart';
import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  //TODO with provider
  final void Function(Expense item) onRemoveExpense;
  final List<Expense> expenses;

  const ItemList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  @override
  Widget build(BuildContext context) {
    // We do not use Colum when list lenght is unkown.
    return ListView.builder(
      // Item count sets the maximum number of return widgets
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
          background: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).colorScheme.error.withOpacity(0.65),
            ),
            margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          ),
          key: ValueKey(expenses[index]),
          onDismissed: (direction) => onRemoveExpense(expenses[index]),
          child: Item(expenses[index])),
    );
  }
}
