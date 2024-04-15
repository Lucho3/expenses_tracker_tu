import 'package:expenses_tracker_tu/database/expenses_database.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class WalletsNotifier extends AsyncNotifier<List<Wallet>> {
  late AppDatabase database;

  @override
  Future<List<Wallet>> build() async {
    database =
        await $FloorAppDatabase.databaseBuilder('expenses_database.db').build();
    List<Wallet> wallets = await database.walletDao.findAllWallets();
    return wallets;
  }

  Future<void> loadWallets() async {
    List<Wallet> wallets = await database.walletDao.findAllWallets();
    state = AsyncValue.data(wallets);
  }

  AsyncValue<List<Wallet>> get items {
    return state;
  }

  Future<void> addItem(Wallet wallet) async {
    await database.walletDao.insertWallet(wallet);
    await loadWallets();
  }

  Future<void> deleteItem(Wallet wallet) async {
    await database.walletDao.deleteWallet(wallet);
    await database.walletDao.removeAllIncomes(wallet.id!);
    await database.walletDao.removeAllExpenses(wallet.id!);
    await loadWallets();
  }

  Future<void> editItem(Wallet item) async {
    await database.walletDao.updateWallet(item);
    await loadWallets();
  }

  Future<void> changeSelected(Wallet selectedWallet) async {
    await database.walletDao.deselectSelectedWallet();
    await database.walletDao.selectWallet(selectedWallet.id!);
    await loadWallets();
  }
}

final walletsProvider = AsyncNotifierProvider<WalletsNotifier, List<Wallet>>(
    () => WalletsNotifier());
