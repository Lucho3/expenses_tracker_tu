import 'package:expenses_tracker_tu/models/income.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:expenses_tracker_tu/providers/item_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomesNotifier extends ItemNotifier<Income> {
  @override
  List<Income> build() {
    return [];
  }

  @override
  List<Income> get items {
     return state;
  }

  @override
  void addItem(Income income) {
    state = [...state, income];
  }
  
  @override
  void deleteItem(Income income) {
    state = state.where((element) => element!= income).toList();
  }
  
  @override
  void editItem(Income item) {
    final index = state.indexOf(item);
    if (index != -1) {
      state = List.from(state)..[index] = item;
    }
  }

  @override
  void removeAllItemsWithWallet(Wallet wallet) {
    state.removeWhere((item) => item.walletId == wallet.id);
    state = [...state];
  }
}

final incomesProvider =
    NotifierProvider<IncomesNotifier, List<Income>>(
        () => IncomesNotifier());
