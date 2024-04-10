import 'package:expenses_tracker_tu/models/expense.dart';
import 'package:expenses_tracker_tu/providers/settings_provider.dart';
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
  //This list shall accept both expesnes and incomes for now is like that
  final List<Expense> _expenses = [
    Expense(
      title: 'Flutter Cource',
      amount: 19.90,
      date: DateTime.now(),
      category: CategoryExpense.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.90,
      date: DateTime.now(),
      category: CategoryExpense.leisure,
    ),
  ];

//TODO: Shall be refactored
  void _removeExpense(Expense expense) {
    final indexOfRemovedExpense = _expenses.indexOf(expense);
    setState(() {
      _expenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        content: const Text("Expense deleted!"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _expenses.insert(indexOfRemovedExpense, expense);
            });
          },
        ),
      ),
    );
  }

  String get titleOfScreen {
    if(widget.isExpense){
      return AppLocalizations.of(context)!.drawerFirst;
    }else{
      return AppLocalizations.of(context)!.drawerSecond;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text("No expenses found!"),
    );

    if (_expenses.isNotEmpty) {
      mainContent = ItemList(
        onRemoveExpense: _removeExpense,
        expenses: _expenses,
      );
    }

    return MainFrame(
      title: titleOfScreen,
      content: mainContent,
    );
  }
}
