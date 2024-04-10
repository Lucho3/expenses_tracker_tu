import 'package:expenses_tracker_tu/models/income.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomesNotifier extends StateNotifier<List<Income>> {
  IncomesNotifier() : super([]);

  List<Income> get incomes {
     return state;
  }

  void addExpense(Income income) {
    state = [...state, income];
  }
}

final incomesProvider =
    StateNotifierProvider<IncomesNotifier, List<Income>>(
        (ref) => IncomesNotifier());
