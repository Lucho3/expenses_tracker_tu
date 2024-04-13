import 'package:expenses_tracker_tu/models/expense.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:expenses_tracker_tu/providers/item_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesNotifier extends ItemNotifier<Expense> {
  @override
  List<Expense> build() {
    return [];
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
    state = state.where((e) => e != expense).toList();
  }

  @override
  void editItem(Expense item) {
    final index = state.indexOf(item);
    if (index != -1) {
      state = List.from(state)..[index] = item;
    }
  }

  @override
  void removeAllItemsWithWallet(Wallet wallet) {
    state.removeWhere((item) => item.wallet == wallet);
    state = [...state];
  }
}

final expensesProvider =
    NotifierProvider<ExpensesNotifier, List<Expense>>(() => ExpensesNotifier());
