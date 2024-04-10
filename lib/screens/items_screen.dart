
import 'package:expenses_tracker_tu/models/income.dart';
import 'package:expenses_tracker_tu/models/item.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:expenses_tracker_tu/providers/expenses_provider.dart';
import 'package:expenses_tracker_tu/providers/incomes_provider.dart';
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
  final List<ItemModel> _expenses = [
    Income(
      title: 'Flutter Course',
      amount: 19.90,
      date: DateTime.now(),
      type: TypeIncome.salary,
      wallet: Wallet(amount: 12333, title: "Salaries")
    ),
    Income(
      title: 'Cinema',
      amount: 15.90,
      date: DateTime.now(),
      type: TypeIncome.other,
      wallet: Wallet(amount: 12333, title: "Salaries")
    ),
  ];

  String get titleOfScreen {
    if (widget.isExpense) {
      return AppLocalizations.of(context)!.drawerFirst;
    } else {
      return AppLocalizations.of(context)!.drawerSecond;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsProvider;
    if (widget.isExpense) {
      itemsProvider = ref.watch(expensesProvider);
    }
    else{
      itemsProvider = ref.watch(incomesProvider);
    }

    final settings = ref.watch(settingsProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    Widget mainContent = Center(
      child: Text(
        AppLocalizations.of(context)!.noElements,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );

    if (_expenses.isNotEmpty) {
      mainContent = ItemList(
        isExpense: widget.isExpense, 
      );
    }

    return MainFrame(
      title: titleOfScreen,
      content: mainContent,
    );
  }
}
