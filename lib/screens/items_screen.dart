import 'package:expenses_tracker_tu/models/item.dart';
import 'package:expenses_tracker_tu/providers/expenses_provider.dart';
import 'package:expenses_tracker_tu/providers/incomes_provider.dart';
import 'package:expenses_tracker_tu/providers/item_provider.dart';
import 'package:expenses_tracker_tu/providers/settings_provider.dart';
import 'package:expenses_tracker_tu/widgets/items/items_list.dart';
import 'package:expenses_tracker_tu/widgets/main_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:riverpod/src/notifier.dart';

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
    provider = (widget.isExpense ? expensesProvider : incomesProvider) as NotifierProvider<ItemNotifier<ItemModel>, List<ItemModel>>;
    super.initState();
  }

  void _removeExpense(ItemModel item) {
    ref.read(provider.notifier).deleteItem(item);
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(AppLocalizations.of(context)!.elementDel),
        action: SnackBarAction(
            label: AppLocalizations.of(context)!.undo,
            onPressed: () {
              ref.read(provider.notifier).addItem(item);
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemsProvider = ref.watch(provider);
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

    //TODO: check for current wallet
    if (itemsProvider.isNotEmpty) {
      mainContent = ItemList(
        onRemoveItem: _removeExpense,
        provider: provider,
      );
    }

    return MainFrame(
      title: titleOfScreen,
      content: mainContent,
    );
  }
}
