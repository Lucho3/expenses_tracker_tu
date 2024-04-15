import 'dart:async';
import 'package:expenses_tracker_tu/models/converters/datetimeConverter.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';

// Import your entity models and DAOs
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:expenses_tracker_tu/models/expense.dart';
import 'package:expenses_tracker_tu/models/income.dart';
import 'package:expenses_tracker_tu/database/daos/expenses_dao.dart';
import 'package:expenses_tracker_tu/database/daos/incomes_dao.dart';
import 'package:expenses_tracker_tu/database/daos/wallet_dao.dart';


part 'expenses_database.g.dart'; // The code generated file

@TypeConverters([DateTimeConverter])
@Database(version: 3, entities: [Wallet, Expense, Income])
abstract class AppDatabase extends FloorDatabase {
  WalletDao get walletDao;
  ExpenseDao get expenseDao;
  IncomeDao get incomeDao;
}