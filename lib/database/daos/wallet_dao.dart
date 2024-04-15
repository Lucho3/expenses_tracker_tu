import 'package:floor/floor.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';

@dao
abstract class WalletDao {
    @Query('SELECT * FROM wallets')
    Future<List<Wallet>> getAllWallets();

    @Query('SELECT * FROM wallets WHERE id = :id')
    Future<Wallet?> findWalletById(int id);

    @insert
    Future<int> insertWallet(Wallet wallet);

    @update
    Future<void> updateWallet(Wallet wallet);

    @delete
    Future<void> deleteWallet(Wallet wallet);

    @Query('UPDATE wallets SET isSelected = 0 WHERE isSelected = 1')
    Future<void> deselectSelectedWallet();

    @Query('UPDATE wallets SET isSelected = 1 WHERE id = :id')
    Future<void> selectWallet(int id);

    @Query('DELETE FROM incomes WHERE walletId = :id')
    Future<void> removeAllIncomes(int id);

    @Query('DELETE FROM expenses WHERE walletId = :id')
    Future<void> removeAllExpenses(int id);
}