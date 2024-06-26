import 'package:expenses_tracker_tu/models/converters/datetimeConverter.dart';
import 'package:expenses_tracker_tu/models/item.dart';
import 'package:expenses_tracker_tu/models/wallet.dart';
import 'package:flutter/material.dart';
import 'package:floor/floor.dart';


const typeIcon = {
  TypeIncome.salary: Icons.money_outlined,
  TypeIncome.side: Icons.work,
  TypeIncome.other: Icons.pending_actions_outlined,
};

enum TypeIncome {
  salary,
  side,
  other,
}

@TypeConverters([DateTimeConverter])
@Entity(tableName: 'incomes', foreignKeys:[ForeignKey(entity: Wallet, parentColumns: ['id'], childColumns: ['walletId'])
])
class Income extends ItemModel {
  @PrimaryKey(autoGenerate: true)
  int? id;
  TypeIncome type;

  Income({
    this.id,
    required super.title,
    required super.amount,
    required super.date,
    required super.walletId,
    required this.type,
  });
}



