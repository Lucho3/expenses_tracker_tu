import 'package:expenses_tracker_tu/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesNotifier extends StateNotifier<List<Expense>> {
  ExpensesNotifier() : super([]);
  
  List<Expense> get expenses {
     return state;
  }

  void addExpense(Expense expense) {
    state = [...state, expense];
  }
}

final expensesProvider =
    StateNotifierProvider<ExpensesNotifier, List<Expense>>(
        (ref) => ExpensesNotifier());
