import 'package:floor/floor.dart';
import 'package:expenses_tracker_tu/models/expense.dart';

@dao
abstract class ExpenseDao {
  @Query('SELECT * FROM expenses')
  Future<List<Expense>> findAllExpenses();

  @Query('SELECT * FROM expenses WHERE id = :id')
  Future<Expense?> findExpenseById(int id);

  @Query('SELECT * FROM expenses WHERE walletId = :walletId')
  Future<List<Expense>> findExpensesByWalletId(int walletId);

  @insert
  Future<void> insertExpense(Expense expense);

  @update
  Future<void> updateExpense(Expense expense);

  @delete
  Future<void> deleteExpense(Expense expense);


  @Query('DELETE FROM expenses WHERE walletId = :walletId')
  Future<void> deleteExpensesByWalletId(int walletId);
}