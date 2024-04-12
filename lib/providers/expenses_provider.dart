import 'package:expenses_tracker_tu/models/expense.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:expenses_tracker_tu/providers/item_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesNotifier extends ItemNotifier<Expense> {
  @override
  List<Expense> build() {
    return [Expense(amount: 123, title: "ds",  category: CategoryExpense.food, date: DateTime.now(), wallet: Wallet(title: "123", amount: 12, isSelected: true)), Expense(amount: 123, title: "ds",  category: CategoryExpense.food, date: DateTime.now(), wallet: Wallet(title: "as", amount: 12, isSelected: true))];
  }

  @override
  List<Expense> get items {
     return state;
  }
  
  @override
  void addItem(Expense expense) {
    state = [...state, expense];
  }
  
  @override
  void deleteItem(Expense expense) {
    state = state.where((e) => e!= expense).toList();
  }
  
  @override
  void editItem(Expense item) {
    final index = state.indexOf(item);
    if (index != -1) {
      state = List.from(state)..[index] = item;
    }
  }
}

final expensesProvider =
    NotifierProvider<ExpensesNotifier, List<Expense>>(
        () => ExpensesNotifier());
