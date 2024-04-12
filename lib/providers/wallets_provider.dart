import 'package:expenses_tracker_tu/models/income.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletsNotifier extends Notifier<List<Wallet>> {
  @override
  List<Wallet> build() {
    return [new Wallet(title: "Salary", amount: 12345, isSelected: true), Wallet(title: "Other", amount: 12, isSelected: false)];
  }

  @override
  List<Wallet> get items {
     return state;
  }

  @override
  void addItem(Wallet wallet) {
    state = [...state, wallet];
  }
  
  @override
  void deleteItem(Wallet wallet) {
    state = state.where((element) => element!= wallet).toList();
  }
  
  @override
  void editItem(Wallet item) {
    final index = state.indexOf(item);
    if (index != -1) {
      state = List.from(state)..[index] = item;
    }
  }
}

final walletsProvider =
    NotifierProvider<WalletsNotifier, List<Wallet>>(
        () => WalletsNotifier());
