import 'package:expenses_tracker_tu/database/expenses_database.dart';
import 'package:expenses_tracker_tu/models/expense.dart';
import 'package:expenses_tracker_tu/providers/item_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesNotifier extends ItemNotifier<Expense> {
  late AppDatabase database;

  @override
  Future<List<Expense>> build() async {
    database = await $FloorAppDatabase.databaseBuilder('expenses_database.db').build();
    List<Expense> expenses = await database.expenseDao.findAllExpenses();
    return expenses;
  }

  Future<void> loadExpenses() async {
    List<Expense> expenses = await database.expenseDao.findAllExpenses();
    state = AsyncValue.data(expenses);
  }

  @override
  AsyncValue<List<Expense>> get items {
    return state;
  }

  Future<void> addItem(Expense expense) async {
    await database.expenseDao.insertExpense(expense);
    await loadExpenses();
  }

  Future<void> deleteItem(Expense expense) async {
    await database.expenseDao.deleteExpense(expense);
    await loadExpenses();
  }

   Future<void> editItem(Expense expense) async {
    await database.expenseDao.updateExpense(expense);
    await loadExpenses();
  }

}

final expensesProvider = AsyncNotifierProvider<ExpensesNotifier, List<Expense>>(
    () => ExpensesNotifier());

