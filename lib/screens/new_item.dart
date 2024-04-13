import 'package:expenses_tracker_tu/models/income.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:expenses_tracker_tu/providers/expenses_provider.dart';
import 'package:expenses_tracker_tu/providers/incomes_provider.dart';
import 'package:expenses_tracker_tu/providers/item_provider.dart';
import 'package:expenses_tracker_tu/providers/wallets_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:expenses_tracker_tu/models/expense.dart';
import 'package:expenses_tracker_tu/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewItem extends ConsumerStatefulWidget {
  NewItem({super.key, required this.isExpense, this.item});

  final bool isExpense;
  ItemModel? item;

  @override
  ConsumerState<NewItem> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends ConsumerState<NewItem> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  late NotifierProvider<ItemNotifier<ItemModel>, List<ItemModel>> provider;
  DateTime? _selectedDate;

  late Enum _selectedItem = widget.isExpense
      ? _selectedItem = CategoryExpense.leisure
      : _selectedItem = TypeIncome.salary;
  late Map<Enum, String> selectorList = widget.isExpense
      ? {
          CategoryExpense.food: AppLocalizations.of(context)!.food,
          CategoryExpense.leisure: AppLocalizations.of(context)!.leisure,
          CategoryExpense.travel: AppLocalizations.of(context)!.travel,
          CategoryExpense.work: AppLocalizations.of(context)!.work,
        }
      : {
          TypeIncome.salary: AppLocalizations.of(context)!.salary,
          TypeIncome.other: AppLocalizations.of(context)!.other,
          TypeIncome.side: AppLocalizations.of(context)!.side,
        };

  @override
  void initState() {
    provider = (widget.isExpense ? expensesProvider : incomesProvider)
        as NotifierProvider<ItemNotifier<ItemModel>, List<ItemModel>>;
    if (widget.item != null) {
      displayDataForEdit();
    }
    super.initState();
  }

  void _presentDatePicker() async {
    var now = DateTime.now();
    var firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    //possible bug null date
    setState(() {
      pickedDate != null ? _selectedDate = pickedDate : null;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void displayDataForEdit() {
    _titleController.text = widget.item!.title;
    _amountController.text = widget.item!.amount.toString();
    _selectedDate = widget.item!.date;

    _selectedItem = widget.isExpense
        ? (widget.item as Expense).category
        : (widget.item as Income).type;
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
    if (_titleController.text.trim().isEmpty ||
        isAmountInvalid ||
        _selectedDate == null) {
      dialogShower(AppLocalizations.of(context)!.alertTitle,
          AppLocalizations.of(context)!.alertContent);
      return false;
    }
    return true;
  }

  bool addItem(WalletsNotifier walletsP) {
    final enteredAmount = double.tryParse(_amountController.text);
    Wallet selectedWallet =
        walletsP.items.where((w) => w.isSelected == true).first;

    if (evaluateInput(enteredAmount)) {
      final ItemModel newItem;
      if (widget.isExpense) {
        if (selectedWallet.amount >= enteredAmount!) {
          newItem = Expense(
              title: _titleController.text,
              amount: enteredAmount!,
              date: _selectedDate!,
              category: _selectedItem as CategoryExpense,
              wallet: selectedWallet);
          selectedWallet.amount -= enteredAmount;
        } else {
          dialogShower(AppLocalizations.of(context)!.notEnoughMoneyTitle,
              AppLocalizations.of(context)!.notEnoughMoney);
          return false;
        }
      } else {
        newItem = Income(
            title: _titleController.text,
            amount: enteredAmount!,
            date: _selectedDate!,
            type: _selectedItem as TypeIncome,
            wallet: selectedWallet);
        selectedWallet.amount += enteredAmount;
      }
      walletsP.editItem(selectedWallet);
      ref.read(provider.notifier).addItem(newItem);
      return true;
    }
    return false;
  }

  void _submitItemData() {
    final walletsP = ref.watch(walletsProvider.notifier);
    if (walletsP.items.isNotEmpty) {
      if (addItem(walletsP)) {
        Navigator.pop(context);
      }
    } else {
      dialogShower(AppLocalizations.of(context)!.noWallets,
          AppLocalizations.of(context)!.noWalletsContent);
    }
  }

  void _saveEditedItem() {
    final enteredAmount = double.tryParse(_amountController.text);
    if (evaluateInput(enteredAmount)) {
      widget.item!.amount = enteredAmount!;
      widget.item!.date = _selectedDate!;
      widget.item!.title = _titleController.text;
      widget.isExpense
          ? (widget.item as Expense).category = _selectedItem as CategoryExpense
          : (widget.item as Income).type = _selectedItem as TypeIncome;

      ref.read(provider.notifier).editItem(widget.item!);
      Navigator.pop(context);
    }
  }

  List<Widget> widgetsPortrait() {
    return [
      TextField(
        maxLength: 50,
        controller: _titleController,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
        decoration: InputDecoration(
          label: Text(
              widget.isExpense
                  ? AppLocalizations.of(context)!.expenseNote
                  : AppLocalizations.of(context)!.incomeNote,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  )),
          border: const OutlineInputBorder(),
        ),
      ),
      Row(
        children: [
          Expanded(
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
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Wrap(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    _selectedDate == null
                        ? AppLocalizations.of(context)!.noDate
                        : formatter.format(_selectedDate!),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                IconButton(
                  onPressed: _presentDatePicker,
                  icon: Icon(
                    Icons.calendar_month,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ])
        ],
      ),
      const SizedBox(
        height: 16,
      ),
      Row(
        children: [
          DropdownButton(
              value: _selectedItem,
              items: selectorList.keys
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(selectorList[item]!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _selectedItem = value;
                });
              }),
          const Spacer(),
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
            onPressed: widget.item == null ? _submitItemData : _saveEditedItem,
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer),
            child: Text(AppLocalizations.of(context)!.save,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    )),
          ),
        ],
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
