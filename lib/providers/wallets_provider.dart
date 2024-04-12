import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletsNotifier extends Notifier<List<Wallet>> {
  @override
  List<Wallet> build() {
    return [
      new Wallet(title: "Salary", amount: 12345, isSelected: true),
      Wallet(title: "Other", amount: 12, isSelected: false)
    ];
  }

  List<Wallet> get items {
    return state;
  }

  void addItem(Wallet wallet) {
    state = [...state, wallet];
  }

  void deleteItem(Wallet wallet) {
    state = state.where((element) => element != wallet).toList();
  }

  void editItem(Wallet item) {
    final index = state.indexOf(item);
    if (index != -1) {
      state = List.from(state)..[index] = item;
    }
  }

  //TODO: Refactor
  void changeSelected(Wallet selectedWallet) {
    final index = state.indexOf(selectedWallet);
    if (index != -1) {
      final updatedWallets = state.map((wallet) {
        if (wallet == selectedWallet) {
          return Wallet(
            title: wallet.title,
            amount: wallet.amount,
            isSelected: true,
          );
        } else if (wallet.isSelected) {
          return Wallet(
            title: wallet.title,
            amount: wallet.amount,
            isSelected: false,
          );
        } else {
          return wallet;
        }
      }).toList();
      state = updatedWallets;
    }
  }
}

final walletsProvider =
    NotifierProvider<WalletsNotifier, List<Wallet>>(() => WalletsNotifier());
