import 'package:expenses_tracker_tu/models/item.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:flutter/material.dart';
import 'package:floor/floor.dart';

enum TypeIncome {
  salary,
  side,
  other,
}

const typeIcon = {
  TypeIncome.salary: Icons.money_outlined,
  TypeIncome.side: Icons.work,
  TypeIncome.other: Icons.pending_actions_outlined,
};

@entity
class Income extends ItemModel {
  @PrimaryKey(autoGenerate: true)
  int? id;
  TypeIncome type;

  Income({
    required String title,
    required double amount,
    required DateTime date,
    required Wallet wallet,
    required this.type,
  }) : super(
          title: title,
          amount: amount,
          date: date,
          wallet: wallet,
        );
}



