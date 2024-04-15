import 'package:floor/floor.dart';
import 'package:expenses_tracker_tu/models/income.dart';

@dao
abstract class IncomeDao {
  @Query('SELECT * FROM incomes')
  Future<List<Income>> getAllIncomes();

  @Query('SELECT * FROM incomes WHERE id = :id')
  Future<Income?> findIncomeById(int id);

  @Query('SELECT * FROM incomes WHERE walletId = :walletId')
  Future<List<Income>> findIncomesByWalletId(int walletId);

  @insert
  Future<void> insertIncome(Income income);

  @update
  Future<void> updateIncome(Income income);

  @delete
  Future<void> deleteIncome(Income income);

  @Query('DELETE FROM incomes WHERE walletId = :walletId')
  Future<void> deleteIncomesByWalletId(int walletId);
}