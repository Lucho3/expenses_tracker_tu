import 'package:expenses_tracker_tu/database/expenses_database.dart';
import 'package:expenses_tracker_tu/models/income.dart';
import 'package:expenses_tracker_tu/providers/item_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomesNotifier extends ItemNotifier<Income> {
  late AppDatabase database;

  @override
  Future<List<Income>> build() async {
    database = await $FloorAppDatabase.databaseBuilder('expenses_database.db').build();
    List<Income> incomes = await database.incomeDao.getAllIncomes();
    return incomes;
  }

  Future<void> loadIncomes() async {
    List<Income> incomes = await database.incomeDao.getAllIncomes();
    state = AsyncValue.data(incomes);
  }

   @override
  AsyncValue<List<Income>> get items {
    return state;
  }

  @override
  Future<void> addItem(Income income) async {
    await database.incomeDao.insertIncome(income);
    await loadIncomes();
  }
  
  @override
  Future<void> deleteItem(Income income) async {
    await database.incomeDao.deleteIncome(income);
    await loadIncomes();
  }
  
  @override
   Future<void> editItem(Income income) async {
    await database.incomeDao.updateIncome(income);
    await loadIncomes();
  }
  
  @override
  Future<void> deleteItemByWalletId(int walletId) async{
    await database.incomeDao.deleteIncomesByWalletId(walletId);
    await loadIncomes();
  }
}

final incomesProvider = AsyncNotifierProvider<IncomesNotifier, List<Income>>(
    () => IncomesNotifier());
