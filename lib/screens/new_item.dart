import 'package:expenses_tracker_tu/models/income.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:expenses_tracker_tu/models/expense.dart';
import 'package:expenses_tracker_tu/models/item.dart';
import 'package:flutter/material.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key, required this.itemType});

  final String itemType;

  @override
  State<NewItem> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewItem> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  late Enum _selectedItem = widget.itemType == "Expense" ? _selectedItem = CategoryExpense.leisure: _selectedItem = TypeIncome.salary;
  late Map<Enum, String> selectorList = widget.itemType == "Expense"
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

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final isAmountInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        isAmountInvalid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.alertTitle,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                content: Text(
                  AppLocalizations.of(context)!.alertContent,
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
      return;
    }

    //provder for list
    Navigator.pop(context);
  }

  List<Widget> widgetsPortrait() {
    return [
      TextField(
        maxLength: 50,
        controller: _titleController,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.expenseNote,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  )),
          border: OutlineInputBorder(),
        ),
      ),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
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
            onPressed: _submitExpenseData,
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
