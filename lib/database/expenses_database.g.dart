// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WalletDao? _walletDaoInstance;

  ExpenseDao? _expenseDaoInstance;

  IncomeDao? _incomeDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `wallets` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `amount` REAL NOT NULL, `isSelected` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `expenses` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `category` INTEGER NOT NULL, `title` TEXT NOT NULL, `amount` REAL NOT NULL, `date` INTEGER NOT NULL, `walletId` INTEGER NOT NULL, FOREIGN KEY (`walletId`) REFERENCES `wallets` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `incomes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `type` INTEGER NOT NULL, `title` TEXT NOT NULL, `amount` REAL NOT NULL, `date` INTEGER NOT NULL, `walletId` INTEGER NOT NULL, FOREIGN KEY (`walletId`) REFERENCES `wallets` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WalletDao get walletDao {
    return _walletDaoInstance ??= _$WalletDao(database, changeListener);
  }

  @override
  ExpenseDao get expenseDao {
    return _expenseDaoInstance ??= _$ExpenseDao(database, changeListener);
  }

  @override
  IncomeDao get incomeDao {
    return _incomeDaoInstance ??= _$IncomeDao(database, changeListener);
  }
}

class _$WalletDao extends WalletDao {
  _$WalletDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _walletInsertionAdapter = InsertionAdapter(
            database,
            'wallets',
            (Wallet item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'amount': item.amount,
                  'isSelected': item.isSelected ? 1 : 0
                }),
        _walletUpdateAdapter = UpdateAdapter(
            database,
            'wallets',
            ['id'],
            (Wallet item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'amount': item.amount,
                  'isSelected': item.isSelected ? 1 : 0
                }),
        _walletDeletionAdapter = DeletionAdapter(
            database,
            'wallets',
            ['id'],
            (Wallet item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'amount': item.amount,
                  'isSelected': item.isSelected ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Wallet> _walletInsertionAdapter;

  final UpdateAdapter<Wallet> _walletUpdateAdapter;

  final DeletionAdapter<Wallet> _walletDeletionAdapter;

  @override
  Future<List<Wallet>> getAllWallets() async {
    return _queryAdapter.queryList('SELECT * FROM wallets',
        mapper: (Map<String, Object?> row) => Wallet(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            isSelected: (row['isSelected'] as int) != 0));
  }

  @override
  Future<Wallet?> findWalletById(int id) async {
    return _queryAdapter.query('SELECT * FROM wallets WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Wallet(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            isSelected: (row['isSelected'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<void> deselectSelectedWallet() async {
    await _queryAdapter.queryNoReturn(
        'UPDATE wallets SET isSelected = 0 WHERE isSelected = 1');
  }

  @override
  Future<void> selectWallet(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE wallets SET isSelected = 1 WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> removeAllIncomes(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM incomes WHERE walletId = ?1',
        arguments: [id]);
  }

  @override
  Future<void> removeAllExpenses(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM expenses WHERE walletId = ?1',
        arguments: [id]);
  }

  @override
  Future<int> insertWallet(Wallet wallet) {
    return _walletInsertionAdapter.insertAndReturnId(
        wallet, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateWallet(Wallet wallet) async {
    await _walletUpdateAdapter.update(wallet, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWallet(Wallet wallet) async {
    await _walletDeletionAdapter.delete(wallet);
  }
}

class _$ExpenseDao extends ExpenseDao {
  _$ExpenseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _expenseInsertionAdapter = InsertionAdapter(
            database,
            'expenses',
            (Expense item) => <String, Object?>{
                  'id': item.id,
                  'category': item.category.index,
                  'title': item.title,
                  'amount': item.amount,
                  'date': _dateTimeConverter.encode(item.date),
                  'walletId': item.walletId
                }),
        _expenseUpdateAdapter = UpdateAdapter(
            database,
            'expenses',
            ['id'],
            (Expense item) => <String, Object?>{
                  'id': item.id,
                  'category': item.category.index,
                  'title': item.title,
                  'amount': item.amount,
                  'date': _dateTimeConverter.encode(item.date),
                  'walletId': item.walletId
                }),
        _expenseDeletionAdapter = DeletionAdapter(
            database,
            'expenses',
            ['id'],
            (Expense item) => <String, Object?>{
                  'id': item.id,
                  'category': item.category.index,
                  'title': item.title,
                  'amount': item.amount,
                  'date': _dateTimeConverter.encode(item.date),
                  'walletId': item.walletId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Expense> _expenseInsertionAdapter;

  final UpdateAdapter<Expense> _expenseUpdateAdapter;

  final DeletionAdapter<Expense> _expenseDeletionAdapter;

  @override
  Future<List<Expense>> getAllExpenses() async {
    return _queryAdapter.queryList('SELECT * FROM expenses',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            date: _dateTimeConverter.decode(row['date'] as int),
            walletId: row['walletId'] as int,
            category: CategoryExpense.values[row['category'] as int]));
  }

  @override
  Future<Expense?> findExpenseById(int id) async {
    return _queryAdapter.query('SELECT * FROM expenses WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            date: _dateTimeConverter.decode(row['date'] as int),
            walletId: row['walletId'] as int,
            category: CategoryExpense.values[row['category'] as int]),
        arguments: [id]);
  }

  @override
  Future<List<Expense>> findExpensesByWalletId(int walletId) async {
    return _queryAdapter.queryList('SELECT * FROM expenses WHERE walletId = ?1',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            date: _dateTimeConverter.decode(row['date'] as int),
            walletId: row['walletId'] as int,
            category: CategoryExpense.values[row['category'] as int]),
        arguments: [walletId]);
  }

  @override
  Future<void> deleteExpensesByWalletId(int walletId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM expenses WHERE walletId = ?1',
        arguments: [walletId]);
  }

  @override
  Future<void> insertExpense(Expense expense) async {
    await _expenseInsertionAdapter.insert(expense, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await _expenseUpdateAdapter.update(expense, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteExpense(Expense expense) async {
    await _expenseDeletionAdapter.delete(expense);
  }
}

class _$IncomeDao extends IncomeDao {
  _$IncomeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _incomeInsertionAdapter = InsertionAdapter(
            database,
            'incomes',
            (Income item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type.index,
                  'title': item.title,
                  'amount': item.amount,
                  'date': _dateTimeConverter.encode(item.date),
                  'walletId': item.walletId
                }),
        _incomeUpdateAdapter = UpdateAdapter(
            database,
            'incomes',
            ['id'],
            (Income item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type.index,
                  'title': item.title,
                  'amount': item.amount,
                  'date': _dateTimeConverter.encode(item.date),
                  'walletId': item.walletId
                }),
        _incomeDeletionAdapter = DeletionAdapter(
            database,
            'incomes',
            ['id'],
            (Income item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type.index,
                  'title': item.title,
                  'amount': item.amount,
                  'date': _dateTimeConverter.encode(item.date),
                  'walletId': item.walletId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Income> _incomeInsertionAdapter;

  final UpdateAdapter<Income> _incomeUpdateAdapter;

  final DeletionAdapter<Income> _incomeDeletionAdapter;

  @override
  Future<List<Income>> getAllIncomes() async {
    return _queryAdapter.queryList('SELECT * FROM incomes',
        mapper: (Map<String, Object?> row) => Income(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            date: _dateTimeConverter.decode(row['date'] as int),
            walletId: row['walletId'] as int,
            type: TypeIncome.values[row['type'] as int]));
  }

  @override
  Future<Income?> findIncomeById(int id) async {
    return _queryAdapter.query('SELECT * FROM incomes WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Income(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            date: _dateTimeConverter.decode(row['date'] as int),
            walletId: row['walletId'] as int,
            type: TypeIncome.values[row['type'] as int]),
        arguments: [id]);
  }

  @override
  Future<List<Income>> findIncomesByWalletId(int walletId) async {
    return _queryAdapter.queryList('SELECT * FROM incomes WHERE walletId = ?1',
        mapper: (Map<String, Object?> row) => Income(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            date: _dateTimeConverter.decode(row['date'] as int),
            walletId: row['walletId'] as int,
            type: TypeIncome.values[row['type'] as int]),
        arguments: [walletId]);
  }

  @override
  Future<void> deleteIncomesByWalletId(int walletId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM incomes WHERE walletId = ?1',
        arguments: [walletId]);
  }

  @override
  Future<void> insertIncome(Income income) async {
    await _incomeInsertionAdapter.insert(income, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateIncome(Income income) async {
    await _incomeUpdateAdapter.update(income, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteIncome(Income income) async {
    await _incomeDeletionAdapter.delete(income);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
